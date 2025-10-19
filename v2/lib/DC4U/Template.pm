package DC4U::Template;

use strict;
use warnings;
use v5.32;

=head1 NAME

DC4U::Template - Template management system

=head1 SYNOPSIS

    my $template = DC4U::Template->new();
    my $rendered = $template->render('singapore_charge', $data);

=head1 DESCRIPTION

Manages document templates for different jurisdictions and output formats.
Supports Singapore legal document templates with extensibility for UK templates.

=cut

sub new {
    my $class = shift;
    my $self = {
        templates => {
            singapore => {
                charge => {
                    header => _singapore_header(),
                    suspect => _singapore_suspect(),
                    charge => _singapore_charge(),
                    officer => _singapore_officer()
                }
            },
            uk => {
                charge => {
                    header => _uk_header(),
                    suspect => _uk_suspect(),
                    charge => _uk_charge(),
                    officer => _uk_officer()
                }
            }
        }
    };
    bless $self, $class;
    return $self;
}

=head2 render

Renders template with data.

=cut

sub render {
    my ($self, $template_name, $data, $format) = @_;
    
    my ($jurisdiction, $type) = split /_/, $template_name;
    
    unless (exists $self->{templates}->{$jurisdiction}->{$type}) {
        die "Template not found: $template_name";
    }
    
    my $template = $self->{templates}->{$jurisdiction}->{$type};
    
    # Render based on format
    if ($format eq 'HTML') {
        return $self->_render_html($template, $data);
    } elsif ($format eq 'PDF') {
        return $self->_render_pdf($template, $data);
    } elsif ($format eq 'TXT') {
        return $self->_render_txt($template, $data);
    } elsif ($format eq 'MD') {
        return $self->_render_md($template, $data);
    } else {
        return $self->_render_html($template, $data);
    }
}

=head2 _render_html

Renders HTML template.

=cut

sub _render_html {
    my ($self, $template, $data) = @_;
    
    my $html = $template->{header};
    $html .= $template->{suspect};
    $html .= $template->{charge};
    $html .= $template->{officer};
    
    # Replace placeholders
    $html =~ s/\{\{suspect_name\}\}/$data->{suspect_info}->{name}/g;
    $html =~ s/\{\{suspect_nric\}\}/$data->{suspect_info}->{nric}/g;
    $html =~ s/\{\{suspect_race\}\}/$data->{suspect_info}->{race}/g;
    $html =~ s/\{\{suspect_age\}\}/$data->{suspect_info}->{age}/g;
    $html =~ s/\{\{suspect_gender\}\}/$data->{suspect_info}->{gender}/g;
    $html =~ s/\{\{suspect_nationality\}\}/$data->{suspect_info}->{nationality}/g;
    
    $html =~ s/\{\{charge_title\}\}/$data->{charge_info}->{title}/g;
    $html =~ s/\{\{charge_date\}\}/$data->{charge_info}->{date}/g;
    $html =~ s/\{\{charge_explanation\}\}/$data->{charge_info}->{explanation}/g;
    
    $html =~ s/\{\{statute\}\}/$data->{statute_info}/g;
    
    $html =~ s/\{\{officer_name\}\}/$data->{officer_info}->{name}/g;
    $html =~ s/\{\{officer_role\}\}/$data->{officer_info}->{role_division}/g;
    $html =~ s/\{\{officer_date\}\}/$data->{officer_info}->{date}/g;
    
    return $html;
}

=head2 _render_pdf

Renders PDF template.

=cut

sub _render_pdf {
    my ($self, $template, $data) = @_;
    
    # For now, return HTML that can be converted to PDF
    return $self->_render_html($template, $data);
}

=head2 _render_txt

Renders plain text template.

=cut

sub _render_txt {
    my ($self, $template, $data) = @_;
    
    my $html = $self->_render_html($template, $data);
    
    # Convert HTML to plain text
    $html =~ s/<[^>]+>//g;
    $html =~ s/&nbsp;/ /g;
    $html =~ s/&amp;/&/g;
    $html =~ s/&lt;/</g;
    $html =~ s/&gt;/>/g;
    
    return $html;
}

=head2 _render_md

Renders Markdown template.

=cut

sub _render_md {
    my ($self, $template, $data) = @_;
    
    my $html = $self->_render_html($template, $data);
    
    # Convert HTML to Markdown
    $html =~ s/<h1[^>]*>(.*?)<\/h1>/# $1\n\n/g;
    $html =~ s/<h2[^>]*>(.*?)<\/h2>/## $1\n\n/g;
    $html =~ s/<p[^>]*>(.*?)<\/p>/$1\n\n/g;
    $html =~ s/<br\s*\/?>\s*/\n/g;
    $html =~ s/<[^>]+>//g;
    $html =~ s/&nbsp;/ /g;
    $html =~ s/&amp;/&/g;
    $html =~ s/&lt;/</g;
    $html =~ s/&gt;/>/g;
    
    return $html;
}

=head2 _singapore_header

Singapore charge header template.

=cut

sub _singapore_header {
    return <<'HTML';
<div class="header">
    <h1>Criminal Procedure Code 2010</h1>
    <h2>(CHAPTER 68)</h2>
    <h2>REVISED EDITION 2012</h2>
    <h2>SECTIONS 123-125</h2>
    <h1>CHARGE</h1>
</div>
HTML
}

=head2 _singapore_suspect

Singapore suspect information template.

=cut

sub _singapore_suspect {
    return <<'HTML';
<div class="suspect-info">
    <p>You,</p>
    <p><span class="bold">Name:</span> {{suspect_name}}</p>
    <p><span class="bold">NRIC:</span> {{suspect_nric}}</p>
    <p><span class="bold">Race:</span> {{suspect_race}}</p>
    <p><span class="bold">Age:</span> {{suspect_age}}</p>
    <p><span class="bold">Sex:</span> {{suspect_gender}}</p>
    <p><span class="bold">Nationality:</span> {{suspect_nationality}}</p>
</div>
HTML
}

=head2 _singapore_charge

Singapore charge information template.

=cut

sub _singapore_charge {
    return <<'HTML';
<div class="charge-section">
    <p>are charged that you, on (or about) {{charge_date}} at [location, add as necessary], Singapore, did [add brief summary of charge], <em>to wit</em> {{charge_explanation}}, and you have thereby committed an offence under {{statute}}.</p>
</div>
HTML
}

=head2 _singapore_officer

Singapore officer information template.

=cut

sub _singapore_officer {
    return <<'HTML';
<div class="officer-info">
    <p>{{officer_name}}</p>
    <p>{{officer_role}}</p>
    <p>{{officer_date}}</p>
</div>
HTML
}

=head2 _uk_header

UK charge header template (for future use).

=cut

sub _uk_header {
    return <<'HTML';
<div class="header">
    <h1>Criminal Justice Act 2003</h1>
    <h2>CHARGE SHEET</h2>
</div>
HTML
}

=head2 _uk_suspect

UK suspect information template (for future use).

=cut

sub _uk_suspect {
    return <<'HTML';
<div class="suspect-info">
    <p>Defendant:</p>
    <p><span class="bold">Name:</span> {{suspect_name}}</p>
    <p><span class="bold">Date of Birth:</span> {{suspect_dob}}</p>
    <p><span class="bold">Address:</span> {{suspect_address}}</p>
</div>
HTML
}

=head2 _uk_charge

UK charge information template (for future use).

=cut

sub _uk_charge {
    return <<'HTML';
<div class="charge-section">
    <p>That you on {{charge_date}} at {{charge_location}}, did {{charge_description}}, contrary to {{statute}}.</p>
</div>
HTML
}

=head2 _uk_officer

UK officer information template (for future use).

=cut

sub _uk_officer {
    return <<'HTML';
<div class="officer-info">
    <p>Prosecutor: {{officer_name}}</p>
    <p>{{officer_role}}</p>
    <p>Date: {{officer_date}}</p>
</div>
HTML
}

1;

__END__

=head1 AUTHOR

DC4U Development Team

=head1 LICENSE

This software is licensed under the MIT License.

=cut
