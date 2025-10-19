# DC4U - Draft Charges 4 U

![Static Badge](https://img.shields.io/badge/DC4U-multi--version-blue)

A Legal Draft Charge Creator with support for multiple versions.

## 📁 Repository Structure

This repository contains two major versions of DC4U:

### 🐍 **DC4U v1.0** (Python-based)
- **Location**: `v1/` directory
- **Language**: Python
- **Architecture**: Monolithic
- **Dependencies**: R, Pandoc, Python
- **Status**: Legacy version

### 🐪 **DC4U v2.0** (Perl-based)
- **Location**: `v2/` directory  
- **Language**: Perl
- **Architecture**: Modular
- **Dependencies**: Perl modules
- **Status**: Current version

## 🚀 Quick Start

### Using DC4U v2.0 (Recommended)

```bash
# Navigate to v2 directory
cd v2/

# Test the installation
make test

# Install system-wide
sudo make install

# Generate a document
bin/dc4u --format HTML --output charge.html examples/test_simple.dc
```

### Using DC4U v1.0 (Legacy)

```bash
# Navigate to v1 directory
cd v1/

# Install dependencies
make install-deps

# Run the application
make run
```

## 📖 Documentation

- **v1.0 Documentation**: See `v1/README.md`
- **v2.0 Documentation**: See `v2/README-v2.md`
- **v2.0 Implementation Summary**: See `v2/IMPLEMENTATION_SUMMARY.md`

## 🔄 Migration Guide

### From v1.0 to v2.0

1. **Backward Compatibility**: All v1.0 `.dc` files work with v2.0
2. **Enhanced Syntax**: v2.0 supports additional features
3. **Better CLI**: v2.0 has comprehensive command-line interface
4. **No R Dependencies**: v2.0 uses native Perl modules

### Key Differences

| Feature | v1.0 | v2.0 |
|---------|------|------|
| **Language** | Python | Perl |
| **Architecture** | Monolithic | Modular |
| **CLI** | Interactive only | Full CLI + batch |
| **Templates** | Hardcoded | Flexible system |
| **Dependencies** | R, Pandoc | Perl modules |
| **Configuration** | None | YAML config |

## 🎯 Which Version to Use?

### Use **DC4U v2.0** if you want:
- ✅ Modern, modular architecture
- ✅ Comprehensive CLI interface
- ✅ Flexible template system
- ✅ Better error handling
- ✅ No external dependencies
- ✅ Batch processing
- ✅ Configuration management

### Use **DC4U v1.0** if you:
- 🔄 Need to maintain existing Python workflows
- 🔄 Have R/Pandoc infrastructure already set up
- 🔄 Prefer the original interactive interface

## 📋 Installation Requirements

### DC4U v2.0 Requirements
```bash
# Ubuntu/Debian
sudo apt-get install perl libyaml-tiny-perl
sudo cpan PDF::API2

# CentOS/RHEL
sudo yum install perl perl-YAML-Tiny
sudo cpan PDF::API2
```

### DC4U v1.0 Requirements
```bash
# Ubuntu/Debian
sudo apt-get install python3 r-base pandoc
sudo R -e "install.packages(c('rmarkdown', 'officedown', 'tinytex'))"

# macOS
brew install python r pandoc
```

## 🤝 Contributing

1. **For v2.0**: Work in the `v2/` directory
2. **For v1.0**: Work in the `v1/` directory
3. **Documentation**: Update the respective README files
4. **Testing**: Use the appropriate Makefile commands

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

- **v2.0 Issues**: Create issues for v2.0 features
- **v1.0 Issues**: Legacy support only
- **Documentation**: Check the respective version directories

---

**DC4U** - Making legal document generation efficient and reliable across multiple versions! 🚀
