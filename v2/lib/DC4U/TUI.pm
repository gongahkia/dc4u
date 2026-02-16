package DC4U::TUI;

use strict;
use warnings;
use v5.32;

use Curses;
use FindBin;
use lib "$FindBin::Bin/../lib";

use DC4U;
use DC4U::Config;
use DC4U::Logger;
use DC4U::TUI::FileBrowser;
use DC4U::TUI::FormatSelector;
use DC4U::TUI::JurisdictionSelector;
use DC4U::TUI::Progress;
use DC4U::TUI::Preview;
use DC4U::TUI::ErrorDisplay;
use DC4U::TUI::ChargeNav;
use DC4U::TUI::LogViewer;

=head1 NAME

DC4U::TUI - Terminal User Interface controller

=head1 DESCRIPTION

Manages screen layout (header, content area, status bar) and dispatches
to sub-screens: FileBrowser, FormatSelector, JurisdictionSelector,
Progress, Preview, ErrorDisplay, ChargeNav.

=cut

sub new {
    my ($class, %opts) = @_;
    my $log_file = $opts{log_file} || 'dc4u_tui.log';
    my $self = {
        config   => DC4U::Config->new($opts{config_file}),
        logger   => DC4U::Logger->new('DEBUG', log_file => $log_file),
        screen   => undef,
        header_h => 3,
        status_h => 2,
        running  => 1,
    };
    bless $self, $class;
    return $self;
}

=head2 run

Main entry point. Initializes curses then drives the interactive flow:
select file → jurisdiction → format → process → preview → confirm write.

=cut

sub run {
    my $self = shift;
    $self->{logger}->info('TUI session started');
    $self->_init_curses();
    eval { $self->_main_flow(); };
    my $err = $@;
    $self->_end_curses();
    $self->{logger}->info('TUI session ended');
    die $err if $err;
}

sub _init_curses {
    my $self = shift;
    initscr();
    start_color() if has_colors();
    init_pair(1, COLOR_WHITE, COLOR_BLUE);   # header/status
    init_pair(2, COLOR_BLACK, COLOR_WHITE);  # content
    init_pair(3, COLOR_RED,   COLOR_BLACK);  # error
    init_pair(4, COLOR_GREEN, COLOR_BLACK);  # success
    init_pair(5, COLOR_YELLOW, COLOR_BLACK); # highlight
    noecho();
    cbreak();
    curs_set(0);
    keypad(stdscr, 1);
    $self->{screen} = stdscr;
}

sub _end_curses {
    endwin();
}

sub _draw_header {
    my ($self, $title) = @_;
    $title //= 'DC4U — Draft Charges 4 U';
    my $w = getmaxx($self->{screen});
    attron(COLOR_PAIR(1) | A_BOLD);
    for my $r (0 .. $self->{header_h} - 1) {
        move($r, 0);
        addstr(' ' x $w);
    }
    my $centered = int(($w - length($title)) / 2);
    $centered = 0 if $centered < 0;
    move(1, $centered);
    addstr($title);
    attroff(COLOR_PAIR(1) | A_BOLD);
}

sub _draw_status {
    my ($self, $msg) = @_;
    $msg //= '';
    my $h = getmaxy($self->{screen});
    my $w = getmaxx($self->{screen});
    my $y = $h - $self->{status_h};
    attron(COLOR_PAIR(1));
    for my $r ($y .. $h - 1) {
        move($r, 0);
        addstr(' ' x $w);
    }
    move($y, 1);
    addstr(substr($msg, 0, $w - 2));
    attroff(COLOR_PAIR(1));
}

sub _content_region {
    my $self = shift;
    my $h = getmaxy($self->{screen});
    my $w = getmaxx($self->{screen});
    my $top = $self->{header_h};
    my $bot = $h - $self->{status_h};
    return ($top, $bot, $w);
}

sub _clear_content {
    my $self = shift;
    my ($top, $bot, $w) = $self->_content_region();
    for my $r ($top .. $bot - 1) {
        move($r, 0);
        clrtoeol();
    }
}

sub _main_flow {
    my $self = shift;
    my $log = $self->{logger};

    # step 1: file browser (loops back if user opens log viewer)
    my ($top, $bot, $w) = $self->_content_region();
    my $file;
    while (1) {
        $log->info('Screen: FileBrowser');
        $self->_draw_header('DC4U - Select Input File');
        $self->_draw_status('Up/Down=navigate  Enter=select  l=view logs  q=quit');
        refresh();
        my $fb = DC4U::TUI::FileBrowser->new(
            top => $top, bottom => $bot, width => $w
        );
        $file = $fb->run($self->{screen});
        unless ($file) { $log->info('User quit at FileBrowser'); return; }
        if ($file eq '__VIEW_LOGS__') {
            $log->info('User opened LogViewer');
            erase();
            $self->_draw_header('DC4U - Session Logs');
            $self->_draw_status('Up/Down=scroll  g/G=top/bottom  r=reload  q=back');
            refresh();
            my $lv = DC4U::TUI::LogViewer->new(
                top => $top, bottom => $bot, width => $w,
                log_file => $self->{logger}->{log_file} // 'dc4u_tui.log',
            );
            $lv->run($self->{screen});
            next; # loop back to file browser
        }
        last; # valid file selected
    }
    $log->info("File selected: $file");

    # step 2: jurisdiction selector
    $log->info('Screen: JurisdictionSelector');
    $self->_clear_content();
    $self->_draw_header('DC4U — Select Jurisdiction');
    $self->_draw_status('Navigate with ↑↓, Enter to select');
    refresh();
    my $js = DC4U::TUI::JurisdictionSelector->new(
        top => $top, bottom => $bot, width => $w,
        config => $self->{config},
    );
    my $jurisdiction = $js->run($self->{screen});
    unless ($jurisdiction) { $log->info('User quit at JurisdictionSelector'); return; }
    $log->info("Jurisdiction selected: $jurisdiction");
    $self->{config}->set('jurisdiction', $jurisdiction);

    # step 3: format selector
    $log->info('Screen: FormatSelector');
    $self->_clear_content();
    $self->_draw_header('DC4U — Select Output Format');
    $self->_draw_status('Navigate with ↑↓, Enter to select');
    refresh();
    my $fs = DC4U::TUI::FormatSelector->new(
        top => $top, bottom => $bot, width => $w
    );
    my $format = $fs->run($self->{screen});
    unless ($format) { $log->info('User quit at FormatSelector'); return; }
    $log->info("Format selected: $format");

    # step 4: process with progress
    $log->info("Processing file=$file format=$format jurisdiction=$jurisdiction");
    $self->_clear_content();
    $self->_draw_header('DC4U — Processing');
    $self->_draw_status('Processing...');
    refresh();
    my $pg = DC4U::TUI::Progress->new(
        top => $top, bottom => $bot, width => $w
    );
    my ($results, $proc_err);
    $pg->start($self->{screen});
    eval {
        my $options = {
            output_format => $format,
            config_file   => $self->{config}->{config_file},
        };
        $results = DC4U::process_dc_file($file, $format, $options);
    };
    $proc_err = $@;
    $pg->finish($self->{screen}, !$proc_err);

    if ($proc_err) {
        $log->error("Processing error: $proc_err");
        $self->_clear_content();
        $self->_draw_header('DC4U — Error');
        $self->_draw_status('Press any key to exit');
        refresh();
        my $ed = DC4U::TUI::ErrorDisplay->new(
            top => $top, bottom => $bot, width => $w
        );
        $ed->show($self->{screen}, $proc_err);
        return;
    }

    unless ($results && @$results > 0) {
        $log->error('No output generated');
        $self->_clear_content();
        $self->_draw_header('DC4U — Error');
        $self->_draw_status('Press any key to exit');
        refresh();
        my $ed = DC4U::TUI::ErrorDisplay->new(
            top => $top, bottom => $bot, width => $w
        );
        $ed->show($self->{screen}, 'No output generated.');
        return;
    }

    $log->info('Processing complete, ' . scalar(@$results) . ' charge(s) generated');

    # step 5: preview (with charge nav if multiple charges)
    my $selected_result;
    if (@$results > 1) {
        $log->info('Screen: ChargeNav (' . scalar(@$results) . ' charges)');
        $self->_clear_content();
        $self->_draw_header('DC4U — Charge Navigator');
        $self->_draw_status('Tab between charges, Enter to preview');
        refresh();
        my $cn = DC4U::TUI::ChargeNav->new(
            top => $top, bottom => $bot, width => $w,
            results => $results,
        );
        $selected_result = $cn->run($self->{screen});
    } else {
        $selected_result = $results->[0];
    }
    unless ($selected_result) { $log->info('User quit at Preview/ChargeNav'); return; }

    $log->info('Screen: Preview');
    $self->_clear_content();
    $self->_draw_header('DC4U — Preview');
    $self->_draw_status('Enter to confirm write, q to cancel');
    refresh();
    my $pv = DC4U::TUI::Preview->new(
        top => $top, bottom => $bot, width => $w
    );
    my $confirmed = $pv->show($self->{screen}, $selected_result);
    unless ($confirmed) { $log->info('User cancelled write at Preview'); return; }

    # step 6: write to disk
    my $ext = lc($format);
    $ext = 'Rmd' if $ext eq 'rmd';

    require File::Basename;
    my ($name, $path, $suffix) = File::Basename::fileparse($file, qr/\.[^.]*$/);
    my $outfile = "${path}${name}.${ext}";

    $log->info("Writing output to: $outfile");
    eval {
        open my $fh, '>', $outfile or die "Cannot write $outfile: $!";
        if (ref $selected_result eq 'HASH') {
            print $fh $selected_result->{output};
        } else {
            print $fh $selected_result;
        }
        close $fh;
    };
    if ($@) {
        $log->error("Write error: $@");
        $self->_clear_content();
        $self->_draw_header('DC4U — Write Error');
        $self->_draw_status('Press any key');
        refresh();
        my $ed = DC4U::TUI::ErrorDisplay->new(
            top => $top, bottom => $bot, width => $w
        );
        $ed->show($self->{screen}, $@);
        return;
    }

    $log->info("File written successfully: $outfile");
    $self->_clear_content();
    $self->_draw_header('DC4U — Complete');
    $self->_draw_status('Press any key to exit');
    refresh();
    my ($ct, $cb, $cw) = $self->_content_region();
    my $msg = "File written: $outfile";
    attron(COLOR_PAIR(4) | A_BOLD);
    move(int(($ct + $cb) / 2), int(($cw - length($msg)) / 2));
    addstr($msg);
    attroff(COLOR_PAIR(4) | A_BOLD);
    refresh();
    getch();
}

1;

__END__

=head1 AUTHOR

DC4U Development Team

=head1 LICENSE

This software is licensed under the MIT License.

=cut
