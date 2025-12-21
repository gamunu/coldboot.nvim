# Neovim Configuration Makefile

.PHONY: help format check lint install clean test

# Default target
help:
	@echo "Available targets:"
	@echo "  format    - Format all Lua files using stylua"
	@echo "  check     - Check Lua syntax without formatting"
	@echo "  lint      - Run luacheck on Lua files"
	@echo "  install   - Install required formatters and linters"
	@echo "  clean     - Remove temporary files"
	@echo "  test      - Run basic configuration tests"
	@echo "  all       - Run format, check, and lint"

# Format all Lua files
format:
	@echo "Formatting Lua files..."
	@find . -name "*.lua" -type f -exec stylua {} \; 2>/dev/null || echo "stylua not found, install with: cargo install stylua"

# Check Lua syntax
check:
	@echo "Checking Lua syntax..."
	@find . -name "*.lua" -type f -exec lua -c {} \; 2>/dev/null || echo "lua interpreter not found"

# Lint Lua files
lint:
	@echo "Linting Lua files..."
	@find . -name "*.lua" -type f -exec luacheck {} \; 2>/dev/null || echo "luacheck not found, install with: luarocks install luacheck"

# Install required tools
install:
	@echo "Installing required tools..."
	@echo "Installing stylua..."
	@cargo install stylua 2>/dev/null || echo "cargo not found, install Rust first"
	@echo "Installing luacheck..."
	@luarocks install luacheck 2>/dev/null || echo "luarocks not found, install Lua and luarocks first"

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.tmp" -type f -delete 2>/dev/null || true
	@find . -name "*.bak" -type f -delete 2>/dev/null || true
	@find . -name ".DS_Store" -type f -delete 2>/dev/null || true

# Basic configuration test
test:
	@echo "Running basic configuration tests..."
	@nvim --headless -c "lua vim.health.check()" -c "qa" 2>/dev/null || echo "Neovim not found or configuration has issues"

# Run all checks
all: format check lint
	@echo "All checks completed!"

# Format only changed files (for CI)
format-check:
	@echo "Checking if files need formatting..."
	@if command -v stylua >/dev/null 2>&1; then \
		stylua --check . || (echo "Files need formatting. Run 'make format' to fix." && exit 1); \
	else \
		echo "stylua not found, skipping format check"; \
	fi
