package DC4U::TUI::FileBrowser;

use strict;
use warnings;
use v5.32;
use Curses;
use Cwd qw(getcwd);
use File::Find qw(find);

=head1 NAME

DC4U::TUI::FileBrowser - TUI screen for browsing and selecting .dc files

=cut

sub new {
    my ($class, %opts) = @_;
    my $self = {
        top    => $opts{top}    || 3,
        bottom => $opts{bottom} || 20,
        width  => $opts{width}  || 80,
        cursor => 0,
        scroll => 0,
        files  => [],
    };
    bless $self, $class;
    $self->_scan_files();
    return $self;
}

sub _scan_files {
    my $self = shift;
    my $cwd = getcwd();
    my @dc_files;
    find(sub {
        return unless -f $_ && /\.dc$/i;
        return if $File::Find::dir =~ /\/\./; # skip hidden dirs
        my $rel = $File::Find::name;
        $rel =~ s/^\Q$cwd\E\///;
        push @dc_files, $rel;
    }, $cwd);
    @dc_files = sort @dc_files;
    my @file_info;
    for my $f (@dc_files) {
        my $full = "$cwd/$f";
        my $size = -s $full || 0;
        my $charges = _count_charges($full);
        push @file_info, { name => $f, path => $full, size => $size, charges => $charges };
    }
    $self->{files} = \@file_info;
}

sub _count_charges {
    my $path = shift;
    open my $fh, '<', $path or return 0;
    my $content = do { local $/; <$fh> };
    close $fh;
    my @blocks = split /^---$/m, $content;
    my $count = 0;
    for (@blocks) { $count++ if /\S/; }
    return $count || 1;
}

sub _format_size {
    my $bytes = shift;
    return sprintf("%.1fK", $bytes / 1024) if $bytes >= 1024;
    return "${bytes}B";
}

=head2 run

Renders scrollable list with arrow-key nav and enter-to-select.
Returns selected file path or undef on quit.

=cut

sub run {
    my ($self, $win) = @_;
    return undef unless @{$self->{files}};
    my $visible = $self->{bottom} - $self->{top} - 1;
    while (1) {
        erase();
        $self->_draw($win, $visible);
        my $ch = getch();
        next unless defined $ch;
        if ($ch eq 'q' || $ch eq 'Q') {
            return undef;
        } elsif ($ch eq 'l' || $ch eq 'L') {
            return '__VIEW_LOGS__';
        }
        my $code = (length($ch) == 1) ? ord($ch) : $ch;
        if ($code == KEY_UP || $ch eq 'k') {
            $self->{cursor}-- if $self->{cursor} > 0;
            $self->{scroll}-- if $self->{cursor} < $self->{scroll};
        } elsif ($code == KEY_DOWN || $ch eq 'j') {
            if ($self->{cursor} < $#{$self->{files}}) {
                $self->{cursor}++;
                $self->{scroll}++ if $self->{cursor} >= $self->{scroll} + $visible;
            }
        } elsif ($code == 10 || $code == 13 || $code == KEY_ENTER) {
            return $self->{files}[$self->{cursor}]{path};
        }
    }
}

sub _draw {
    my ($self, $win, $visible) = @_;
    my $w = $self->{width};
    # column header
    move($self->{top}, 0);
    attron(A_BOLD | A_UNDERLINE);
    my $hdr = sprintf("  %-40s %8s %8s", "File", "Size", "Charges");
    addstr(substr($hdr, 0, $w));
    attroff(A_BOLD | A_UNDERLINE);
    clrtoeol();

    for my $i (0 .. $visible - 1) {
        my $idx = $self->{scroll} + $i;
        my $y = $self->{top} + 1 + $i;
        move($y, 0);
        clrtoeol();
        next if $idx > $#{$self->{files}};
        my $f = $self->{files}[$idx];
        my $sel = ($idx == $self->{cursor});
        my $line = sprintf("%s %-40s %8s %8d",
            $sel ? '▸' : ' ',
            $f->{name},
            _format_size($f->{size}),
            $f->{charges},
        );
        if ($sel) {
            attron(A_REVERSE);
            addstr(substr($line, 0, $w));
            attroff(A_REVERSE);
        } else {
            addstr(substr($line, 0, $w));
        }
    }
    refresh();
}

1;

__END__

=head1 AUTHOR

DC4U Development Team

=head1 LICENSE

This software is licensed under the MIT License.

=cut
