#!/usr/bin/env bash

# lib/generators/cpp_files.sh - Generates C++ source and header files for cppinit

# Source necessary utilities and config
source "$(dirname "${BASH_SOURCE[0]}")/../helpers/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../core/config.sh"

# Generate main.cpp
generate_main_cpp() {
    local file="$PROJECT_ROOT/src/main.cpp"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create main.cpp"
        return
    fi
    
    cat > "$file" << EOF
#include <iostream>
#include "${PROJECT_NAME}.hpp"

int main() {
    std::cout << "Hello from ${PROJECT_NAME}!" << std::endl;
    
    // Example usage of generated header
    ${PROJECT_NAME}::greet("World");
    
    return 0;
}
EOF
    
    print_success "Generated src/main.cpp"
    print_verbose "Main source file created with basic I/O and header usage"
}

# Generate header file
generate_header() {
    local header_guard="${PROJECT_NAME^^}_HPP"
    local file="$PROJECT_ROOT/include/${PROJECT_NAME}.hpp"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create ${PROJECT_NAME}.hpp"
        return
    fi
    
    cat > "$file" << EOF
#ifndef ${header_guard}
#define ${header_guard}

#include <string>

/**
 * @brief Main namespace for ${PROJECT_NAME}
 */
namespace ${PROJECT_NAME} {
    
    /**
     * @brief Greet someone with a personalized message
     * @param name The name to greet
     */
    void greet(const std::string& name);
    
    /**
     * @brief Get the version of this library
     * @return Version string
     */
    std::string getVersion();
    
} // namespace ${PROJECT_NAME}

#endif // ${header_guard}
EOF
    
    print_success "Generated include/${PROJECT_NAME}.hpp"
    print_verbose "Header file created with namespace and documentation"
}

# Generate implementation file
generate_implementation() {
    local file="$PROJECT_ROOT/src/${PROJECT_NAME}.cpp"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create ${PROJECT_NAME}.cpp"
        return
    fi
    
    cat > "$file" << EOF
#include "${PROJECT_NAME}.hpp"
#include <iostream>

namespace ${PROJECT_NAME} {
    
    void greet(const std::string& name) {
        std::cout << "Hello, " << name << "! Welcome to ${PROJECT_NAME}." << std::endl;
    }
    
    std::string getVersion() {
        return "1.0.0";
    }
    
} // namespace ${PROJECT_NAME}
EOF
    
    print_success "Generated src/${PROJECT_NAME}.cpp"
    print_verbose "Implementation file created with basic functionality"
}

# Generate test file
generate_test_file() {
    if [[ "$FLAG_MINIMAL" == true ]]; then
        return
    fi
    
    local file="$PROJECT_ROOT/tests/test_${PROJECT_NAME}.cpp"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create test file"
        return
    fi
    
    cat > "$file" << EOF
#include "${PROJECT_NAME}.hpp"
#include <iostream>
#include <cassert>
#include <string>

// Simple test framework macros
#define ASSERT_TRUE(condition) \\
    do { \\
        if (!(condition)) { \\
            std::cerr << "FAIL: " << #condition << " at line " << __LINE__ << std::endl; \\
            return false; \\
        } else { \\
            std::cout << "PASS: " << #condition << std::endl; \\
        } \\
    } while (0)

#define ASSERT_EQ(expected, actual) \\
    do { \\
        if ((expected) != (actual)) { \\
            std::cerr << "FAIL: Expected " << (expected) << " but got " << (actual) \\
                      << " at line " << __LINE__ << std::endl; \\
            return false; \\
        } else { \\
            std::cout << "PASS: " << #expected << " == " << #actual << std::endl; \\
        } \\
    } while (0)

bool test_version() {
    std::cout << "Testing getVersion()..." << std::endl;
    std::string version = ${PROJECT_NAME}::getVersion();
    ASSERT_TRUE(!version.empty());
    ASSERT_EQ("1.0.0", version);
    return true;
}

bool test_greet() {
    std::cout << "Testing greet()..." << std::endl;
    // This test just ensures greet doesn\'t crash
    // In a real scenario, you might capture stdout
    ${PROJECT_NAME}::greet("Test");
    ASSERT_TRUE(true); // If we reach here, greet didn\'t crash
    return true;
}

int main() {
    std::cout << "Running tests for ${PROJECT_NAME}..." << std::endl;
    std::cout << "================================" << std::endl;
    
    bool all_passed = true;
    
    all_passed &= test_version();
    all_passed &= test_greet();
    
    std::cout << "================================" << std::endl;
    if (all_passed) {
        std::cout << "All tests PASSED!" << std::endl;
        return 0;
    } else {
        std::cout << "Some tests FAILED!" << std::endl;
        return 1;
    }
}
EOF
    
    print_success "Generated tests/test_${PROJECT_NAME}.cpp"
    print_verbose "Test file created with basic assertion framework"
}

