[![](https://img.shields.io/badge/DC4U_1.0.0-passing-%23004D00)](https://github.com/gongahkia/dc4u/releases/tag/1.0.0)
[![](https://img.shields.io/badge/DC4U_2.0.0-passing-%23228B22)](https://github.com/gongahkia/dc4u/releases/tag/2.0.0)
[![](https://img.shields.io/badge/DC4U_3.0.0-passing-%2332CD32)](https://github.com/gongahkia/dc4u/releases/tag/3.0.0)
![](https://github.com/gongahkia/dc4u/actions/workflows/ci.yml/badge.svg)

# `Draft Charges 4 U`

A Legal Draft Charge Creator.

## Motivation

[Draft charges](https://mustsharenews.com/wp-content/uploads/2018/12/TOC-Charge-Sheet.jpg) are inane to format. `DC4U` simplifies the entire process of creating Draft Charges, by transpiling a human-readable markup format (`.dc`) to [multiple targets outputs](#output-formats) for viewing and distribution.

## Purpose

* Speed up formatting of draft charges
* Simplify inane legal admin work for lawyers
* Quick integration with existing programmatic workflows via pipes
* Small source code binary and compilation target, faster compilation times

## Stack

* *Language*: [Python 3.8+](https://www.python.org/), [Perl 5.32+](https://www.perl.org/)
* *Package Manager*: [pip](https://pip.pypa.io/), [CPAN](https://www.cpan.org/)
* *Document Processing*: [R Markdown](https://rmarkdown.rstudio.com/), [Pandoc](https://pandoc.org/), [LaTeX](https://www.latex-project.org/)
* *PDF Generation*: [PDF::API2](https://metacpan.org/pod/PDF::API2), [TinyTeX](https://yihui.org/tinytex/)
* *Office Integration*: [officedown](https://davidgohel.github.io/officedown/), [RTF::Writer](https://metacpan.org/pod/RTF::Writer)
* *Configuration*: [YAML](https://yaml.org/)
* *Build System*: [Make](https://www.gnu.org/software/make/)
* *Testing*: [Perl Test Framework](https://perldoc.perl.org/perlunitut)

## Screenshots

### `DC4U` TUI

<div align="center">
    <img src="./asset/reference/1.png" width="45%">
    <img src="./asset/reference/2.png" width="45%">
</div>

<div align="center">
    <img src="./asset/reference/3.png" width="45%">
    <img src="./asset/reference/4.png" width="45%">
</div>

<div align="center">
    <img src="./asset/reference/5.png" width="45%">
    <img src="./asset/reference/6.png" width="45%">
</div>

### Eg. Draft Charge created with `DC4U`

<img src="asset/reference/draft-charge-eg.png" width="60%">

## Usage

The below instructions are for using `DC4U` on your client machine.

1. First run the below commands to install `DC4U` locally.

```console
$ make v2-install
```

2. Alternatively, you can use the interactive TUI for a guided experience:

```console
$ make tui
```

3. For command-line usage, specify the input file and desired format:

```console
$ dc4u -f PDF samples/v2/singapore_assault.dc
```

## Output formats

| Format | Purpose | Implementation status |
| :---: | :---: | :---: |
| `.txt` | Universal viewing and plain text output | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.md` | Markdown formatted viewing with HTML styling | ![](https://img.shields.io/badge/build-up-darkgreen)|
| `.html` | Web-ready documents with CSS styling | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.rmd` | R Markdown for data visualization and analysis | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.pdf` | Professional documents via PDF::API2 (v2.0) or R/Pandoc (v1.0) | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.docx` | Microsoft Word documents via RTF::Writer (v2.0) or R/officedown (v1.0) | ![](https://img.shields.io/badge/build-up-darkgreen)|

## Architecture

```mermaid
graph TD
    A[.dc Source File] --> B[Lexer]
    B -->|Tokens| C[Parser]
    C -->|Structured Data| D[Generator]
    D -->|Data| E[Template Engine]
    E -->|Applied Styles| F[Final Output]
    
    subgraph "DC4U Core (v2.0 Perl)"
        B
        C
        D
        E
    end
    
    F --> G[PDF]
    F --> H[HTML]
    F --> I[TXT]
    F --> J[DOCX]
    
    K[Config YAML] --> D
    K --> E
    L[Logger] --> B
    L --> C
    L --> D
```

## Reference

The name `dc4u` is in reference to [Funny Valentine](https://jojo.fandom.com/wiki/Funny_Valentine)'s (ファニー・ヴァレンタイン) [Stand](https://jojo.fandom.com/wiki/Stand) of the same name, [Dirty Deeds Done Dirt Cheap](https://jojo.fandom.com/wiki/Dirty_Deeds_Done_Dirt_Cheap) *(often shortened to D4C)* in [Part 7: Steel Ball Run](https://jojo.fandom.com/wiki/Steel_Ball_Run) of the ongoing manga series [JoJo's Bizarre Adventure](https://jojowiki.com/JoJo_Wiki).

<div align="center">
    <img src="./asset/logo/dc4u.png" width="50%">
</div>
