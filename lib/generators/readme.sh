#!/usr/bin/env bash

# lib/generators/readme.sh - Generates README.md for cppinit

# Shell guard to prevent double-sourcing issues
# Use expansion ${VAR:-} to prevent failure from set -u if the variable is unbound.
if [[ -n "${__README_SH_SOURCED:-}" ]]; then
    return 0
fi
__README_SH_SOURCED=true

# Source necessary utilities and config
source "$(dirname "${BASH_SOURCE[0]}")/../helpers/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../core/config.sh"

# Generate README.md
generate_readme() {
    local file="$PROJECT_ROOT/README.md"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create README.md"
        return
    fi
    
    # --- Block 1: Initial content (needs variable expansion, so EOF is unquoted) ---
    cat > "$file" << EOF
# ${PROJECT_NAME}

A modern C++ project created with [cppinit](https://github.com/username/cppinit).

## Author

**${AUTHOR_NAME}**

## Description

${PROJECT_NAME} is a C++ application built with modern practices and clean architecture.

## Features

- Modern C++17 codebase
- Clean project structure
- Comprehensive build system with Makefile
- Built-in testing framework
- Documentation-ready code
- Cross-platform compatibility

## Quick Start

### Prerequisites

- g++ compiler (C++17 support required)
- Make build system
- Git (optional, for version control)

### Building

\`\`\`bash
# Clone and enter the project directory
cd ${PROJECT_NAME}

# Build the project
make build

# Run the application
make run
EOF
    
    # --- Block 2: Optional Test Section (uses quoted 'EOF' to prevent backtick/variable expansion) ---
    if [[ "$FLAG_MINIMAL" != true ]]; then
        cat >> "$file" << 'EOF'

# Run tests
make test
EOF
    fi
    
    # --- Block 3: Available Make Targets (uses quoted 'EOF' to prevent backtick interpretation) ---
    # We put the closing code fence here, outside the previous EOF.
    cat >> "$file" << 'EOF'
```

### Available Make Targets

- `make build` - Compile the project
- `make clean` - Remove build artifacts 
- `make run` - Build and execute the program
- `make debug` - Build with debug flags
- `make release` - Build with optimizations
EOF
    
    # --- Block 4: Optional Test Target (uses quoted 'EOF') ---
    if [[ "$FLAG_MINIMAL" != true ]]; then
        cat >> "$file" << 'EOF'
- `make test` - Build and run tests
EOF
    fi
    
    # --- Block 5: Project Structure Header (uses quoted 'EOF') ---
    cat >> "$file" << 'EOF'
- `make docs` - Generate documentation (requires Doxygen)
- `make help` - Show all available targets

### Project Structure

```
EOF

    # --- Block 6: Project Structure List (uses unquoted EOF to expand ${PROJECT_NAME}) ---
    cat >> "$file" << EOF
${PROJECT_NAME}/
├── src/             # Source files
├── include/         # Header files
├── build/           # Object files (generated)
├── bin/             # Compiled binaries (generated)
EOF

    # --- Block 7: Optional Test Directory (uses quoted 'EOF') ---
    if [[ "$FLAG_MINIMAL" != true ]]; then
        cat >> "$file" << 'EOF'
├── tests/           # Unit tests
EOF
    fi
    
    # --- Block 8: Final Structure List (uses quoted 'EOF') ---
    cat >> "$file" << 'EOF'
├── docs/            # Documentation
├── .config/         # Configuration files
├── Makefile         # Build configuration
├── README.md        # This file
├── LICENSE          # License information
└── .gitignore       # Git ignore rules
```

## Development

### Adding New Features

1. Add source files to `src/`
2. Add headers to `include/`
EOF

    # --- Block 9: Optional Test steps (uses quoted 'EOF') ---
    if [[ "$FLAG_MINIMAL" != true ]]; then
        cat >> "$file" << 'EOF'
3. Add tests to `tests/`
4. Run `make test` to verify
EOF
    fi
    
    # --- Block 10: Building Modes and Final Footer (needs variable expansion, so EOF is unquoted) ---
    cat >> "$file" << EOF

### Building in Different Modes

\`\`\`bash
# Debug build (default) - includes debugging symbols
make debug

# Release build - optimized for performance 
make release
\`\`\`

## License

This project is licensed under the ${LICENSE_TYPE} License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/username/${PROJECT_NAME}/issues) on GitHub.

---

*Generated with ❤️ by [cppinit](https://github.com/username/cppinit) v${SCRIPT_VERSION}*
EOF
    
    print_success "Generated README.md"
    print_verbose "README created with comprehensive project documentation"
}
