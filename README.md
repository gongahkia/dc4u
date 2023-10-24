![Static Badge](https://img.shields.io/badge/DC4U_1.0-passing-green)

# Draft Charges 4 U

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

## Output formats

| Output format | Purpose | Implementation status |
| :---: | :---: | :---: |
| `.txt` | Universal viewing | ![](https://img.shields.io/badge/build-in_progress-orange) |
| `.md` | Formatted viewing | ![](https://img.shields.io/badge/build-down-red)|
| `.rmd` | Rudimentary integration of calculation and data vis | ![](https://img.shields.io/badge/build-down-red)
| `.pdf` | Widely accepted format for sharing and viewing | ![](https://img.shields.io/badge/build-down-red) |
| `.html` | Rudimentary API implementation | ![](https://img.shields.io/badge/build-down-red) |
| `.docx` | Microsoft clowns and google doc integration | ![](https://img.shields.io/badge/build-down-red)|

> Further Output formats implemented later. 

## Language syntax

Refer to `samples/eg.dc` for examples and expansion on `.dc` syntax.

| **stylisation** | **syntax** | **notes** | **implementation status** |
| :---: | :---: | :---: | :---: |
| output format | \` ` | PDF, HTML, TXT, MD, DOC | ![](https://img.shields.io/badge/build-up-darkgreen) |
| Suspect name; NRIC; Race; Age; Gender; Nationality | < > | | ![](https://img.shields.io/badge/build-up-darkgreen) |
| Recommended charge title; Date of offence; Explication of charge | [ ] | | ![](https://img.shields.io/badge/build-up-darkgreen)  |
| Relevant statute | @ @ | | ![](https://img.shields.io/badge/build-up-darkgreen) |
| Charging officer; Role and Division; Date of charge | { } | | ![](https://img.shields.io/badge/build-up-darkgreen)  |
| Comments | # # | Comments are ignored in the final formatted draft charge | ![](https://img.shields.io/badge/build-up-darkgreen)  |
| Separator | --- | | ![](https://img.shields.io/badge/build-up-darkgreen)  |

# Screenshots

# Installation

```console
$ git clone https://github.com/gongahkia/dc4u
# add further instructions here 
```

# Troubleshooting

