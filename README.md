# Draft Charges 4 U

Simplifies the process of creating Draft Charges, transpiling a human-readable markup format to different targets.

## Motivation

> FUA: beef up this section later and give screenshot example of draft charge, format this readme similar to https://github.com/YongJieYongJie/SSOjs

## Features
* Takes in a simple reworked markdown format, implement LEXER and PARSER that transpiles to multiple targets
	* `.pdf`: Converts it to a PDF using Rmarkdown
	* `.html`: For rudimentary webpage display
	* `.txt`: For universal viewing
	* `.md`: For formatted viewing
* Calls the necessary APIs from SSO (Penal Code, POFMA etc.) and scrapes the webpage for relevant statutes
* Web scrape for similar common law cases to the given charge 
* Possible future front-end implementation *(in Dart)*

## Purpose
* Speed up process of formatting draft charges
* Small source code binary and compilation target, faster compilation times
* Simplify inane legal admin work for lawyers

## Other goals
* Integrate this [legislation parser](https://github.com/YongJieYongJie/SSOjs)
