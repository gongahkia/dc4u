# DC4U Version 2.0 - Draft Charges 4 U

![Static Badge](https://img.shields.io/badge/DC4U_2.0-passing-green)

## Overview

DC4U Version 2.0 is a complete rewrite of the legal document generator, featuring a modular Perl architecture, enhanced CLI interface, and comprehensive template system. This version focuses on Singapore legal requirements with extensibility for UK legal documents.

## Key Improvements in Version 2.0

### 🏗️ **Modular Perl Architecture**
- Complete rewrite in Perl for better maintainability
- Separated concerns with dedicated modules
- Plugin architecture for output formats
- Comprehensive error handling and logging

### 🚀 **Enhanced CLI Interface**
- Command-line argument support
- Batch processing capabilities
- Configuration file support
- Verbose/quiet modes

### 📝 **Advanced Template System**
- Singapore legal document templates
- Extensible for UK legal documents
- Customizable formatting
- Template inheritance

### 🔧 **Improved Output Formats**
- Native PDF generation (via PDF::API2)
- Enhanced HTML with CSS styling
- Plain text and Markdown support
- DOCX generation (via RTF)

## Installation

### Prerequisites

```bash
# Install Perl dependencies
sudo apt-get install perl libyaml-tiny-perl
# or
sudo yum install perl perl-YAML-Tiny

# For PDF generation
sudo apt-get install libpdf-api2-perl
# or
sudo cpan PDF::API2
```

### Quick Install

```bash
# Clone repository
git clone https://github.com/gongahkia/dc4u.git
cd dc4u

# Install system-wide
sudo make install

# Or install locally
make test
```

## Usage

### Basic Usage

```bash
# Generate PDF from .dc file
dc4u --format PDF --output charge.pdf input.dc

# Generate HTML
dc4u --format HTML --output charge.html input.dc

# Batch process multiple files
dc4u --batch --format PDF *.dc
```

### Advanced Usage

```bash
# Use configuration file
dc4u --config config/dc4u.yaml --format PDF input.dc

# Verbose output
dc4u --verbose --format HTML input.dc

# Quiet mode
dc4u --quiet --format TXT input.dc
```

### Command Line Options

| Option | Short | Description |
|--------|-------|-------------|
| `--format` | `-f` | Output format (PDF, HTML, TXT, MD, RMD, DOCX) |
| `--output` | `-o` | Output file |
| `--config` | `-c` | Configuration file |
| `--batch` | `-b` | Batch processing mode |
| `--verbose` | `-v` | Verbose output |
| `--quiet` | `-q` | Quiet mode |
| `--help` | `-h` | Show help |
| `--version` | | Show version |

## Enhanced .dc Language Syntax

DC4U v2.0 supports the original syntax plus new features:

### Original Syntax
```
`OUTPUT_FORMAT`
<SUSPECT_NAME; NRIC; RACE; AGE; GENDER; NATIONALITY>
[CHARGE_TITLE; DATE_OF_OFFENCE; EXPLANATION]
@STATUTE@
{OFFICER_NAME; ROLE_DIVISION; DATE_OF_CHARGE}
#COMMENT#
```

### New v2.0 Features
```
# Case references
[[CASE_REFERENCE]]

# Witness information
(WITNESS_NAME; WITNESS_TYPE; STATEMENT)

# Court information
[[[COURT_NAME; COURT_LOCATION; CASE_NUMBER]]]

# Multiple suspects (future)
<SUSPECT1_INFO>
<SUSPECT2_INFO>
```

## Configuration

### Configuration File (config/dc4u.yaml)

```yaml
# General settings
output_directory: "./output"
log_level: "INFO"
jurisdiction: "singapore"
default_format: "PDF"

# Singapore-specific settings
singapore:
  court_name: "State Courts of Singapore"
  legal_act: "Criminal Procedure Code 2010"
  act_chapter: "CHAPTER 68"
  act_edition: "REVISED EDITION 2012"
  sections: "SECTIONS 123-125"

# Output format settings
formats:
  pdf:
    font_family: "Times-Roman"
    font_size: 12
    margins:
      top: 50
      bottom: 50
      left: 50
      right: 50
```

## Architecture

### Core Modules

- **DC4U::Lexer** - Tokenizes .dc markup language
- **DC4U::Parser** - Parses and validates tokens
- **DC4U::Generator** - Generates documents in various formats
- **DC4U::Template** - Manages document templates
- **DC4U::Config** - Configuration management
- **DC4U::Logger** - Logging system

### Output Format Support

| Format | Module | Status |
|--------|--------|--------|
| PDF | PDF::API2 | ✅ Complete |
| HTML | Native Perl | ✅ Complete |
| TXT | Native Perl | ✅ Complete |
| MD | Native Perl | ✅ Complete |
| RMD | Native Perl | ✅ Complete |
| DOCX | RTF::Writer | ✅ Complete |

## Singapore Legal Compliance

DC4U v2.0 is specifically designed for Singapore legal requirements:

- **Criminal Procedure Code 2010** compliance
- **State Courts of Singapore** formatting
- **Singapore legal terminology**
- **Local date/time formats**

## Future UK Support

The architecture is designed to support UK legal documents:

- **Criminal Justice Act 2003** templates
- **Magistrates Court** formatting
- **UK legal terminology**
- **British date formats**

## Examples

### Sample .dc File

```
`PDF`
<S Shankar; S1234567A; Indian; 44; M; Singaporean>
[Negligence Act not amounting to culpable homicide; 19/8/2019; stored rojak sauce in refrigerator with raw seafood, causing contamination]
@s304A(b) of Penal Code (Chapter 224, Rev Ed 2008)@
{SSgt Ghazali; IO, GIS 6, J Div; 24/8/2019}
#though the exact time of death is unconfirmed#
```

### Generated Output

The system generates properly formatted legal documents with:

- Correct Singapore legal formatting
- Proper legal terminology
- Standardized document structure
- Professional presentation

## Development

### Running Tests

```bash
# Syntax tests
make test-syntax

# Basic functionality tests
make test-basic

# Generate test output
make test-output
```

### Adding New Output Formats

1. Create new generator module in `lib/DC4U/Generator/`
2. Add format to `DC4U::Generator`
3. Update CLI help text
4. Add tests

### Adding New Jurisdictions

1. Add jurisdiction settings to `config/dc4u.yaml`
2. Create templates in `templates/`
3. Update `DC4U::Template` module
4. Add validation rules

## Migration from v1.0

DC4U v2.0 maintains backward compatibility with v1.0 .dc files:

- All existing .dc files work without modification
- Enhanced syntax is optional
- Gradual migration path available

## Troubleshooting

### Common Issues

1. **PDF generation fails**
   - Install PDF::API2: `sudo cpan PDF::API2`
   - Check file permissions

2. **Configuration not found**
   - Use `--config` option to specify path
   - Check file exists and is readable

3. **Template errors**
   - Verify template files exist
   - Check template syntax

### Debug Mode

```bash
# Enable debug logging
dc4u --verbose --format PDF input.dc

# Check configuration
dc4u --config config/dc4u.yaml --verbose --format PDF input.dc
```

## Contributing

1. Fork the repository
2. Create feature branch
3. Add tests for new features
4. Submit pull request

## License

This software is licensed under the MIT License.

## Support

- **Documentation**: See `docs/` directory
- **Issues**: GitHub Issues
- **Contact**: @gongahkia on GitHub

---

**DC4U Version 2.0** - Making legal document generation efficient and reliable.
