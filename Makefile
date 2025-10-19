# DC4U Multi-Version Makefile
# Root makefile for navigating between versions

.PHONY: help v1 v2 test clean

# Default target
help:
	@echo "DC4U Multi-Version Repository"
	@echo "============================="
	@echo ""
	@echo "Available commands:"
	@echo "  make v1        - Work with DC4U v1.0 (Python)"
	@echo "  make v2        - Work with DC4U v2.0 (Perl)"
	@echo "  make test      - Test both versions"
	@echo "  make clean     - Clean up temporary files"
	@echo "  make help      - Show this help"
	@echo ""
	@echo "Version-specific commands:"
	@echo "  make v1-install    - Install DC4U v1.0"
	@echo "  make v1-test       - Test DC4U v1.0"
	@echo "  make v2-install    - Install DC4U v2.0"
	@echo "  make v2-test       - Test DC4U v2.0"
	@echo ""
	@echo "Documentation:"
	@echo "  v1/README.md       - DC4U v1.0 documentation"
	@echo "  v2/README-v2.md    - DC4U v2.0 documentation"

# Navigate to v1 directory
v1:
	@echo "Switching to DC4U v1.0 (Python)..."
	@echo "Run 'make help' in the v1/ directory for v1.0 commands"
	@cd v1 && make help

# Navigate to v2 directory  
v2:
	@echo "Switching to DC4U v2.0 (Perl)..."
	@echo "Run 'make help' in the v2/ directory for v2.0 commands"
	@cd v2 && make help

# Test both versions
test:
	@echo "Testing DC4U v1.0..."
	@cd v1 && make test
	@echo ""
	@echo "Testing DC4U v2.0..."
	@cd v2 && make test

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	@cd v1 && make clean
	@cd v2 && make clean
	@rm -f *.tmp *.temp

# Version-specific installs
v1-install:
	@echo "Installing DC4U v1.0..."
	@cd v1 && make install

v2-install:
	@echo "Installing DC4U v2.0..."
	@cd v2 && make install

# Version-specific tests
v1-test:
	@echo "Testing DC4U v1.0..."
	@cd v1 && make test

v2-test:
	@echo "Testing DC4U v2.0..."
	@cd v2 && make test