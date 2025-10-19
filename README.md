[![Static Badge](https://img.shields.io/badge/DC4U_1.0.0-passing-green)](https://github.com/gongahkia/dc4u/releases/tag/1.0.0)
[![Static Badge](https://img.shields.io/badge/DC4U_2.0.0-passing-dark_green)](https://github.com/gongahkia/dc4u/releases/tag/2.0.0)

# `Draft Charges 4 U`

A Legal Draft Charge Creator.

## Motivation

[Draft charges](https://mustsharenews.com/wp-content/uploads/2018/12/TOC-Charge-Sheet.jpg) are inane to format. `DC4U` simplifies the entire process of creating Draft Charges, by transpiling a human-readable markup format (`.dc`) to different targets for viewing and distribution.

This format is intended to allow for quick integration with existing workflows when taking down material facts.

## Purpose

* Speed up process of formatting draft charges
* Small source code binary and compilation target, faster compilation times
* Simplify inane legal admin work for lawyers
* `DC4U` transpiler takes in a simple reworked markup format and transpiles to multiple targets
* Afraid you won't remember `.dc` language syntax? The `DC4U` transpiler will *kindly* point out the error and correct you accordingly.

## Stack

* *Language*: [Python 3.8+](https://www.python.org/) (v1.0), [Perl 5.32+](https://www.perl.org/) (v2.0)
* *Package Manager*: [pip](https://pip.pypa.io/) (v1.0), [CPAN](https://www.cpan.org/) (v2.0)
* *Document Processing*: [R Markdown](https://rmarkdown.rstudio.com/), [Pandoc](https://pandoc.org/), [LaTeX](https://www.latex-project.org/)
* *PDF Generation*: [PDF::API2](https://metacpan.org/pod/PDF::API2) (v2.0), [TinyTeX](https://yihui.org/tinytex/) (v1.0)
* *Office Integration*: [officedown](https://davidgohel.github.io/officedown/) (v1.0), [RTF::Writer](https://metacpan.org/pod/RTF::Writer) (v2.0)
* *Configuration*: [YAML](https://yaml.org/) (v2.0)
* *Build System*: [Make](https://www.gnu.org/software/make/) (v1.0 & v2.0)
* *Testing*: [Perl Test Framework](https://perldoc.perl.org/perlunitut) (v2.0)

## Output formats

| Output format | Purpose | Implementation status |
| :---: | :---: | :---: |
| `.txt` | Universal viewing and plain text output | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.md` | Markdown formatted viewing with HTML styling | ![](https://img.shields.io/badge/build-up-darkgreen)|
| `.html` | Web-ready documents with CSS styling | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.rmd` | R Markdown for data visualization and analysis | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.pdf` | Professional documents via PDF::API2 (v2.0) or R/Pandoc (v1.0) | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.docx` | Microsoft Word documents via RTF::Writer (v2.0) or R/officedown (v1.0) | ![](https://img.shields.io/badge/build-up-darkgreen)|

## Language syntax

Refer to [`samples/`](./samples/) for examples and expansion on `.dc` syntax.

| **stylisation** | **syntax** | **notes** | **implementation status** |
| :---: | :---: | :---: | :---: |
| Output format | \` ` | PDF, HTML, TXT, MD, RMD, DOCX | ![](https://img.shields.io/badge/build-up-darkgreen) |
| Suspect info | < > | Name; NRIC; Race; Age; Gender; Nationality | ![](https://img.shields.io/badge/build-up-darkgreen) |
| Charge details | [ ] | Title; Date of offence; Explanation | ![](https://img.shields.io/badge/build-up-darkgreen)  |
| Legal statute | @ @ | Relevant statute or legal provision | ![](https://img.shields.io/badge/build-up-darkgreen) |
| Officer info | { } | Name; Role/Division; Date of charge | ![](https://img.shields.io/badge/build-up-darkgreen)  |
| Comments | # # | Ignored in final output, for documentation | ![](https://img.shields.io/badge/build-up-darkgreen)  |
| Separator | --- | Separates multiple charges in same file | ![](https://img.shields.io/badge/build-up-darkgreen)  |

# Screenshots

Example of a draft charge created with `DC4U`

![](assets/reference/draft-charge-eg.png)

# Installation

This installation also handles R markdown default toolchain's installation, as well as compilation targets to `.pdf` and `.docx`.

## WSL (Debian)

```console
$ git clone https://github.com/gongahkia/dc4u
$ sudo apt update && sudo apt upgrade && sudo apt autoremove
$ sudo apt -y install r-base gdebi-core pandoc-citeproc
$ sudo apt install texlive-latex-base texlive-fonts-recommended texlive-latex-extra
$ sudo R
> install.packages("rmarkdown")
> install.packages("officedown")
> install.packages('tinytex')
> tinytex::install_tinytex()
> Save workspace image? [y/n/c]: n
$ exit
```

## OSX

```console
$ git clone https://github.com/gongahkia/dc4u
$ brew install r 
$ brew install pandoc
$ brew install --cask rstudio
$ R
> install.packages("rmarkdown")
> install.packages("officedown")
> install.packages('tinytex')
> tinytex::install_tinytex()
> Save workspace image? [y/n/c]: n
$ exit
```

## Architecture

### Overview

```mermaid
C4Context
    title DC4U - Draft Charges 4 U System Context
    
    Person(legal, "Legal Professional", "Lawyer, Legal Officer, or Court Clerk")
    Person(admin, "System Administrator", "IT Administrator managing DC4U installation")
    
    System(dc4u, "DC4U", "Legal Document Generator", "Converts .dc markup to formatted legal documents")
    
    System_Ext(r_markdown, "R Markdown", "Document processing and PDF generation")
    System_Ext(pandoc, "Pandoc", "Document format conversion")
    System_Ext(latex, "LaTeX", "Professional document typesetting")
    System_Ext(office, "Microsoft Office", "Word document generation and editing")
    
    Rel(legal, dc4u, "Creates .dc files", "Markup language")
    Rel(legal, dc4u, "Generates documents", "PDF, HTML, DOCX, etc.")
    Rel(admin, dc4u, "Installs & configures", "System setup")
    
    Rel(dc4u, r_markdown, "Uses for PDF generation", "v1.0")
    Rel(dc4u, pandoc, "Uses for format conversion", "v1.0")
    Rel(dc4u, latex, "Uses for typesetting", "v1.0")
    Rel(dc4u, office, "Generates DOCX files", "v1.0 & v2.0")
    
    UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="2")
```

### Internal Architecture

```mermaid
C4Container
    title DC4U Internal Architecture
    
    Person(user, "Legal Professional", "Creates and processes legal documents")
    
    Container_Boundary(dc4u_system, "DC4U System") {
        Container(v1_python, "DC4U v1.0", "Python 3.8+", "Lexer, Parser, Interpreter")
        Container(v2_perl, "DC4U v2.0", "Perl 5.32+", "Modular architecture with generators")
        
        Container(lexer, "Lexer", "Python/Perl", "Tokenizes .dc markup language")
        Container(parser, "Parser", "Python/Perl", "Validates syntax and structure")
        Container(generator, "Generator", "Python/Perl", "Creates output in various formats")
        Container(config, "Config Manager", "YAML", "Manages system configuration")
        Container(templates, "Template Engine", "Perl", "Handles document templates")
    }
    
    Container_Boundary(external_tools, "External Tools") {
        Container(r_markdown, "R Markdown", "R", "Document processing")
        Container(pandoc, "Pandoc", "Haskell", "Format conversion")
        Container(pdf_api, "PDF::API2", "Perl", "Native PDF generation")
        Container(rtf_writer, "RTF::Writer", "Perl", "Word document generation")
    }
    
    Container_Boundary(output_formats, "Output Formats") {
        Container(pdf_out, "PDF", "Binary", "Professional documents")
        Container(html_out, "HTML", "Web", "Web-ready documents")
        Container(txt_out, "TXT", "Plain text", "Universal viewing")
        Container(docx_out, "DOCX", "Microsoft Word", "Office integration")
    }
    
    Rel(user, v1_python, "Uses", "Command line")
    Rel(user, v2_perl, "Uses", "Command line")
    
    Rel(v1_python, lexer, "Processes", "Tokenization")
    Rel(v1_python, parser, "Validates", "Syntax checking")
    Rel(v1_python, generator, "Generates", "Output creation")
    
    Rel(v2_perl, lexer, "Processes", "Tokenization")
    Rel(v2_perl, parser, "Validates", "Syntax checking")
    Rel(v2_perl, generator, "Generates", "Output creation")
    Rel(v2_perl, config, "Uses", "Configuration")
    Rel(v2_perl, templates, "Uses", "Document templates")
    
    Rel(generator, r_markdown, "Uses", "v1.0 PDF generation")
    Rel(generator, pandoc, "Uses", "v1.0 format conversion")
    Rel(generator, pdf_api, "Uses", "v2.0 PDF generation")
    Rel(generator, rtf_writer, "Uses", "v2.0 DOCX generation")
    
    Rel(generator, pdf_out, "Creates", "PDF documents")
    Rel(generator, html_out, "Creates", "HTML documents")
    Rel(generator, txt_out, "Creates", "Text documents")
    Rel(generator, docx_out, "Creates", "Word documents")
    
    UpdateLayoutConfig($c4ShapeInRow="2", $c4BoundaryInRow="1")
```

## Reference

The name `dc4u` is in reference to [Funny Valentine](https://jojo.fandom.com/wiki/Funny_Valentine)'s (ファニー・ヴァレンタイン) [Stand](https://jojo.fandom.com/wiki/Stand) of the same name, [Dirty Deeds Done Dirt Cheap](https://jojo.fandom.com/wiki/Dirty_Deeds_Done_Dirt_Cheap) *(often shortened to D4C)* in [Part 7: Steel Ball Run](https://jojo.fandom.com/wiki/Steel_Ball_Run) of the ongoing manga series [JoJo's Bizarre Adventure](https://jojowiki.com/JoJo_Wiki).

<div align="center">
    <img src="./assets/logo/dc4u.png" width="50%">
</div>
