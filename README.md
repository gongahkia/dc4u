> FUA: Implement syntax in `lexer.py`

# Draft Charges 4 U

A Legal Draft Charge Creator.

## Motivation

[Draft charges](https://mustsharenews.com/wp-content/uploads/2018/12/TOC-Charge-Sheet.jpg) are inane to format. This simplifies the entire process of creating Draft Charges, by transpiling a human-readable markup format (`.dc`) to different targets for viewing and distribution.

This format is intended to allow for quick integration with existing workflows when taking down material facts.

## Features

* Takes in a simple reworked markdown format, implement LEXER and PARSER that transpiles to multiple targets
	* `.pdf`: Converts it to a PDF using Rmarkdown
	* `.html`: For rudimentary webpage display
	* `.txt`: For universal viewing
	* `.md`: For formatted viewing
	* `.doc`: For microsoft clowns

## Language syntax

| **stylisation** | **syntax** | **implementation status** |
| :---: | :---: | :---: |
| | | |

## Purpose

* Speed up process of formatting draft charges
* Small source code binary and compilation target, faster compilation times
* Simplify inane legal admin work for lawyers
