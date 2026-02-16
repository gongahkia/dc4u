package DC4U::TUI::JurisdictionSelector;

use strict;
use warnings;
use v5.32;
use Curses;

=head1 NAME

DC4U::TUI::JurisdictionSelector - TUI screen for selecting jurisdiction

=cut

my @JURISDICTIONS = (
    { key => 'singapore', label => 'Singapore', desc => 'Criminal Procedure Code 2010, Ch. 68' },
    { key => 'uk',        label => 'United Kingdom', desc => 'Criminal Justice Act 2003, Ch. 44' },
);

sub new {
    my ($class, %opts) = @_;
    my $self = {
        top    => $opts{top}    || 3,
        bottom => $opts{bottom} || 20,
        width  => $opts{width}  || 80,
        config => $opts{config},
        cursor => 0,
    };
    bless $self, $class;
    return $self;
}

=head2 run

Shows available jurisdictions with config preview panel.
Returns jurisdiction string or undef on quit.

=cut

sub run {
    my ($self, $win) = @_;
    while (1) {
        $self->_draw($win);
        my $ch = getch();
        if ($ch eq 'q' || $ch eq 'Q') {
            return undef;
        } elsif ($ch == KEY_UP || $ch eq 'k') {
            $self->{cursor}-- if $self->{cursor} > 0;
        } elsif ($ch == KEY_DOWN || $ch eq 'j') {
            $self->{cursor}++ if $self->{cursor} < $#JURISDICTIONS;
        } elsif ($ch == 10 || $ch == KEY_ENTER || $ch == 13) {
            return $JURISDICTIONS[$self->{cursor}]{key};
        }
    }
}

sub _draw {
    my ($self, $win) = @_;
    my $w = $self->{width};
    # jurisdiction list
    for my $i (0 .. $#JURISDICTIONS) {
        my $y = $self->{top} + $i;
        move($y, 0);
        clrtoeol();
        my $j = $JURISDICTIONS[$i];
        my $sel = ($i == $self->{cursor});
        my $radio = $sel ? '(●)' : '( )';
        my $line = sprintf("  %s  %-20s — %s", $radio, $j->{label}, $j->{desc});
        if ($sel) {
            attron(A_REVERSE);
            addstr(substr($line, 0, $w));
            attroff(A_REVERSE);
        } else {
            addstr(substr($line, 0, $w));
        }
    }

    # config preview panel
    my $preview_y = $self->{top} + scalar(@JURISDICTIONS) + 1;
    my $jkey = $JURISDICTIONS[$self->{cursor}]{key};
    move($preview_y, 0); clrtoeol();
    attron(A_BOLD | A_UNDERLINE);
    addstr("  Configuration Preview:");
    attroff(A_BOLD | A_UNDERLINE);

    if ($self->{config}) {
        my $settings = $self->{config}->{settings}->{$jkey} || {};
        my $row = $preview_y + 1;
        for my $k (sort keys %$settings) {
            move($row, 0); clrtoeol();
            addstr(sprintf("    %-20s %s", "$k:", $settings->{$k} // ''));
            $row++;
            last if $row >= $self->{bottom} - 1;
        }
        # clear remaining
        for my $r ($row .. $self->{bottom} - 1) {
            move($r, 0); clrtoeol();
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
