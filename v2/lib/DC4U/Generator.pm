package DC4U::Generator;

use strict;
use warnings;
use v5.32;

=head1 NAME

DC4U::Generator - Generates documents in various formats

=head1 SYNOPSIS

    my $generator = DC4U::Generator->new();
    my $output = $generator->generate($parsed_data, 'PDF', $config);

=head1 DESCRIPTION

Generates legal documents in various output formats using Perl modules.
Supports PDF, HTML, TXT, MD, RMD, and DOCX formats.

=cut

sub new {
    my $class = shift;
    my $self = {
        generators => {
            'PDF' => \&_generate_pdf,
            'HTML' => \&_generate_html,
            'TXT' => \&_generate_txt,
            'MD' => \&_generate_md,
            'RMD' => \&_generate_rmd,
            'DOCX' => \&_generate_docx
        }
    };
    bless $self, $class;
    return $self;
}

=head2 generate

Generates document in specified format.

=cut

sub generate {
    my ($self, $parsed_data, $format, $config) = @_;
    
    unless (exists $self->{generators}->{$format}) {
        die "Unsupported output format: $format";
    }
    
    return $self->{generators}->{$format}->($parsed_data, $config);
}

=head2 _generate_pdf

Generates PDF document.

=cut

sub _generate_pdf {
    my ($data, $config) = @_;
    
    # Use PDF::API2 for PDF generation
    eval { require PDF::API2; };
    if ($@) {
        die "PDF::API2 required for PDF output. Install via: cpan PDF::API2";
    }

    # read config
    my $font_family = 'Times-Roman';
    my $font_size   = 12;
    my $margin_top  = 50;
    my $margin_bot  = 50;
    my $margin_left = 50;
    my $margin_right = 50;
    if ($config && $config->can('get')) {
        $font_family = $config->get('formats.pdf.font_family') // $font_family;
        $font_size   = $config->get('formats.pdf.font_size')   // $font_size;
        my $margins  = $config->get('formats.pdf.margins');
        if (ref $margins eq 'HASH') {
            $margin_top   = $margins->{top}    // $margin_top;
            $margin_bot   = $margins->{bottom} // $margin_bot;
            $margin_left  = $margins->{left}   // $margin_left;
            $margin_right = $margins->{right}  // $margin_right;
        }
    }

    my $pdf = PDF::API2->new();
    my $font = $pdf->corefont($font_family);
    my $font_bold = $pdf->corefont("$font_family-Bold") || $font;

    my $page_w = 612; # letter
    my $page_h = 792;
    my $usable_w = $page_w - $margin_left - $margin_right;

    my $page = $pdf->page();
    $page->mediabox($page_w, $page_h);
    my $text = $page->text();
    my $y = $page_h - $margin_top;

    my $content = _build_charge_content($data);
    # strip html to plain text lines
    $content =~ s/<br\s*\/?>/\n/gi;
    $content =~ s/<\/(?:p|div|h[1-6]|li|tr)>/\n/gi;
    $content =~ s/<[^>]+>//g;
    $content =~ s/&nbsp;/ /g;
    $content =~ s/&amp;/&/g;
    $content =~ s/&lt;/</g;
    $content =~ s/&gt;/>/g;

    my @lines = split /\n/, $content;

    for my $line (@lines) {
        # word-wrap
        my @wrapped = _pdf_wrap($line, $font, $font_size, $usable_w);
        for my $wline (@wrapped) {
            if ($y < $margin_bot + $font_size) { # page break
                $page = $pdf->page();
                $page->mediabox($page_w, $page_h);
                $text = $page->text();
                $y = $page_h - $margin_top;
            }
            $text->font($font, $font_size);
            $text->translate($margin_left, $y);
            $text->text($wline);
            $y -= $font_size * 1.4;
        }
    }

    return $pdf->stringify();
}

=head2 _generate_html

Generates HTML document.

=cut

sub _generate_html {
    my ($data, $config) = @_;
    
    my $content = _build_charge_content($data);
    
    return <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Draft Charge</title>
    <style>
        body { font-family: 'Times New Roman', serif; margin: 40px; line-height: 1.6; }
        .header { text-align: center; margin-bottom: 30px; }
        .charge-section { margin: 20px 0; }
        .suspect-info { margin: 15px 0; }
        .officer-info { margin-top: 30px; }
        h1, h2 { color: #333; }
        .bold { font-weight: bold; }
    </style>
</head>
<body>
    $content
</body>
</html>
HTML
}

=head2 _generate_txt

Generates plain text document.

=cut

sub _generate_txt {
    my ($data, $config) = @_;
    
    my $content = _build_charge_content($data);
    
    # Remove HTML tags and format for plain text
    $content =~ s/<[^>]+>//g;
    $content =~ s/&nbsp;/ /g;
    $content =~ s/&amp;/&/g;
    $content =~ s/&lt;/</g;
    $content =~ s/&gt;/>/g;
    
    return $content;
}

=head2 _generate_md

Generates Markdown document.

=cut

sub _generate_md {
    my ($data, $config) = @_;
    
    my $content = _build_charge_content($data);
    
    # Convert HTML to Markdown
    $content =~ s/<h1[^>]*>(.*?)<\/h1>/# $1\n\n/g;
    $content =~ s/<h2[^>]*>(.*?)<\/h2>/## $1\n\n/g;
    $content =~ s/<p[^>]*>(.*?)<\/p>/$1\n\n/g;
    $content =~ s/<br\s*\/?>\s*/\n/g;
    $content =~ s/<[^>]+>//g;
    $content =~ s/&nbsp;/ /g;
    $content =~ s/&amp;/&/g;
    $content =~ s/&lt;/</g;
    $content =~ s/&gt;/>/g;
    
    return $content;
}

=head2 _generate_rmd

Generates R Markdown document.

=cut

sub _generate_rmd {
    my ($data, $config) = @_;
    
    my $content = _build_charge_content($data);
    
    return <<"RMD";
---
output: pdf_document
---

$content
RMD
}

=head2 _generate_docx

Generates DOCX document (via RTF).

=cut

sub _generate_docx {
    my ($data, $config) = @_;
    
    # Generate RTF content that can be converted to DOCX
    my $content = _build_charge_content($data);
    
    # Convert HTML to RTF
    $content =~ s/<h1[^>]*>(.*?)<\/h1>/{\\b\\fs24 $1}\\par\n/g;
    $content =~ s/<h2[^>]*>(.*?)<\/h2>/{\\b\\fs20 $1}\\par\n/g;
    $content =~ s/<p[^>]*>(.*?)<\/p>/$1\\par\n/g;
    $content =~ s/<br\s*\/?>\s*/\\par\n/g;
    $content =~ s/<[^>]+>//g;
    $content =~ s/&nbsp;/ /g;
    $content =~ s/&amp;/&/g;
    $content =~ s/&lt;/</g;
    $content =~ s/&gt;/>/g;
    
    return "{\\rtf1\\ansi\\deff0 $content}";
}

=head2 _build_charge_content

Builds the charge content in HTML format.

=cut

sub _build_charge_content {
    my ($data) = @_;
    
    my $suspect = $data->{suspect_info};
    my $charge = $data->{charge_info};
    my $officer = $data->{officer_info};
    
    return <<"HTML";
<div class="header">
    <h1>Criminal Procedure Code 2010</h1>
    <h2>(CHAPTER 68)</h2>
    <h2>REVISED EDITION 2012</h2>
    <h2>SECTIONS 123-125</h2>
    <h1>CHARGE</h1>
</div>

<div class="charge-section">
    <p>You,</p>
    
    <div class="suspect-info">
        <p><span class="bold">Name:</span> $suspect->{name}</p>
        <p><span class="bold">NRIC:</span> $suspect->{nric}</p>
        <p><span class="bold">Race:</span> $suspect->{race}</p>
        <p><span class="bold">Age:</span> $suspect->{age}</p>
        <p><span class="bold">Sex:</span> $suspect->{gender}</p>
        <p><span class="bold">Nationality:</span> $suspect->{nationality}</p>
    </div>
    
    <p>are charged that you, on (or about) $charge->{date} at [location, add as necessary], Singapore, did [add brief summary of charge], <em>to wit</em> $charge->{explanation}, and you have thereby committed an offence under $data->{statute_info}.</p>
</div>

<div class="officer-info">
    <p>$officer->{name}</p>
    <p>$officer->{role_division}</p>
    <p>$officer->{date}</p>
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
