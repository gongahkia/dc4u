package DC4U::TUI;

use strict;
use warnings;
use v5.32;

use Curses;
use FindBin;
use lib "$FindBin::Bin/../lib";

use DC4U;
use DC4U::Config;
use DC4U::TUI::FileBrowser;
use DC4U::TUI::FormatSelector;
use DC4U::TUI::JurisdictionSelector;
use DC4U::TUI::Progress;
use DC4U::TUI::Preview;
use DC4U::TUI::ErrorDisplay;
use DC4U::TUI::ChargeNav;

=head1 NAME

DC4U::TUI - Terminal User Interface controller

=head1 DESCRIPTION

Manages screen layout (header, content area, status bar) and dispatches
to sub-screens: FileBrowser, FormatSelector, JurisdictionSelector,
Progress, Preview, ErrorDisplay, ChargeNav.

=cut

sub new {
    my ($class, %opts) = @_;
    my $self = {
        config => DC4U::Config->new($opts{config_file}),
        screen => undef, # curses main window
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
    $self->_init_curses();
    eval { $self->_main_flow(); };
    my $err = $@;
    $self->_end_curses();
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

    # step 1: file browser
    $self->_draw_header('DC4U — Select Input File');
    $self->_draw_status('Navigate with ↑↓, Enter to select, q to quit');
    refresh();
    my ($top, $bot, $w) = $self->_content_region();
    my $fb = DC4U::TUI::FileBrowser->new(
        top => $top, bottom => $bot, width => $w
    );
    my $file = $fb->run($self->{screen});
    return unless $file; # user quit

    # step 2: jurisdiction selector
    $self->_clear_content();
    $self->_draw_header('DC4U — Select Jurisdiction');
    $self->_draw_status('Navigate with ↑↓, Enter to select');
    refresh();
    my $js = DC4U::TUI::JurisdictionSelector->new(
        top => $top, bottom => $bot, width => $w,
        config => $self->{config},
    );
    my $jurisdiction = $js->run($self->{screen});
    return unless $jurisdiction;
    $self->{config}->set('jurisdiction', $jurisdiction);

    # step 3: format selector
    $self->_clear_content();
    $self->_draw_header('DC4U — Select Output Format');
    $self->_draw_status('Navigate with ↑↓, Enter to select');
    refresh();
    my $fs = DC4U::TUI::FormatSelector->new(
        top => $top, bottom => $bot, width => $w
    );
    my $format = $fs->run($self->{screen});
    return unless $format;

    # step 4: process with progress
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

    # step 5: preview (with charge nav if multiple charges)
    my $selected_result;
    if (@$results > 1) {
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
    return unless $selected_result;

    $self->_clear_content();
    $self->_draw_header('DC4U — Preview');
    $self->_draw_status('Enter to confirm write, q to cancel');
    refresh();
    my $pv = DC4U::TUI::Preview->new(
        top => $top, bottom => $bot, width => $w
    );
    my $confirmed = $pv->show($self->{screen}, $selected_result);
    return unless $confirmed;

    # step 6: write to disk
    my $ext = lc($format);
    $ext = 'html' if $ext eq 'html';
    $ext = 'txt'  if $ext eq 'txt';
    $ext = 'md'   if $ext eq 'md';
    $ext = 'Rmd'  if $ext eq 'rmd';
    $ext = 'docx' if $ext eq 'docx';
    $ext = 'pdf'  if $ext eq 'pdf';

    require File::Basename;
    my ($name, $path, $suffix) = File::Basename::fileparse($file, qr/\.[^.]*$/);
    my $outfile = "${path}${name}.${ext}";

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
