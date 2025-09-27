# cppinit

A modern C++ project created with [cppinit](https://github.com/username/cppinit).

## Author

**C++ Project Initializer Team**

## Description

cppinit is a C++ application built with modern practices and clean architecture.

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

```bash
# Clone and enter the project directory
cd cppinit

# Build the project
make build

# Run the application
make run

# Run tests
make test
```

### Available Make Targets

- `make build` - Compile the project
- `make clean` - Remove build artifacts  
- `make run` - Build and execute the program
- `make debug` - Build with debug flags
- `make release` - Build with optimizations
- `make test` - Build and run tests
- `make docs` - Generate documentation (requires Doxygen)
- `make help` - Show all available targets

### Project Structure

```
cppinit/
├── src/              # Source files
├── include/          # Header files
├── build/            # Object files (generated)
├── bin/              # Compiled binaries (generated)
├── tests/            # Unit tests
├── docs/             # Documentation
├── .config/          # Configuration files
├── Makefile          # Build configuration
├── README.md         # This file
├── LICENSE           # License information
└── .gitignore        # Git ignore rules
```

## Development

### Adding New Features

1. Add source files to `src/`
2. Add headers to `include/`
3. Add tests to `tests/`
4. Run `make test` to verify

### Building in Different Modes

```bash
# Debug build (default) - includes debugging symbols
make debug

# Release build - optimized for performance  
make release
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/username/cppinit/issues) on GitHub.

---

*Generated with ❤️ by [cppinit](https://github.com/username/cppinit) v1.0.0*
