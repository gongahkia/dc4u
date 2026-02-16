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

* *Language*: [Python 3.8+](https://www.python.org/) (v1.0), [Perl 5.32+](https://www.perl.org/) (v2.0)
* *Package Manager*: [pip](https://pip.pypa.io/) (v1.0), [CPAN](https://www.cpan.org/) (v2.0)
* *Document Processing*: [R Markdown](https://rmarkdown.rstudio.com/), [Pandoc](https://pandoc.org/), [LaTeX](https://www.latex-project.org/)
* *PDF Generation*: [PDF::API2](https://metacpan.org/pod/PDF::API2) (v2.0), [TinyTeX](https://yihui.org/tinytex/) (v1.0)
* *Office Integration*: [officedown](https://davidgohel.github.io/officedown/) (v1.0), [RTF::Writer](https://metacpan.org/pod/RTF::Writer) (v2.0)
* *Configuration*: [YAML](https://yaml.org/) (v2.0)
* *Build System*: [Make](https://www.gnu.org/software/make/) (v1.0 & v2.0)
* *Testing*: [Perl Test Framework](https://perldoc.perl.org/perlunitut) (v2.0)

## Screenshots

### `DC4U` TUI

<div align="center">
    <img src="./asset/reference/1.png" width="42%">
    <img src="./asset/reference/2.png" width="42%">
</div>

<div align="center">
    <img src="./asset/reference/3.png" width="42%">
    <img src="./asset/reference/4.png" width="42%">
</div>

<div align="center">
    <img src="./asset/reference/5.png" width="42%">
    <img src="./asset/reference/6.png" width="42%">
</div>

### Eg. Draft Charge created with `DC4U`

![](assets/reference/draft-charge-eg.png)

## Usage

The below instructions are for using `DC4U` on your client machine.

1. First run the below commands to install `DC4U` locally.

```console
$
```

2. Next, execute ...

```console
$
```

## Architecture

<img src="./assets/reference/architecture.png">

## Output formats

| Format | Purpose | Implementation status |
| :---: | :---: | :---: |
| `.txt` | Universal viewing and plain text output | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.md` | Markdown formatted viewing with HTML styling | ![](https://img.shields.io/badge/build-up-darkgreen)|
| `.html` | Web-ready documents with CSS styling | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.rmd` | R Markdown for data visualization and analysis | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.pdf` | Professional documents via PDF::API2 (v2.0) or R/Pandoc (v1.0) | ![](https://img.shields.io/badge/build-up-darkgreen) |
| `.docx` | Microsoft Word documents via RTF::Writer (v2.0) or R/officedown (v1.0) | ![](https://img.shields.io/badge/build-up-darkgreen)|

## Reference

The name `dc4u` is in reference to [Funny Valentine](https://jojo.fandom.com/wiki/Funny_Valentine)'s (ファニー・ヴァレンタイン) [Stand](https://jojo.fandom.com/wiki/Stand) of the same name, [Dirty Deeds Done Dirt Cheap](https://jojo.fandom.com/wiki/Dirty_Deeds_Done_Dirt_Cheap) *(often shortened to D4C)* in [Part 7: Steel Ball Run](https://jojo.fandom.com/wiki/Steel_Ball_Run) of the ongoing manga series [JoJo's Bizarre Adventure](https://jojowiki.com/JoJo_Wiki).

<div align="center">
    <img src="./asset/logo/dc4u.png" width="50%">
</div>
