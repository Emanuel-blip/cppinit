#!/usr/bin/env bash

# lib/generators/cpp_files.sh - Generates C++ source and header files for cppinit

# Shell guard to prevent double-sourcing issues
if [[ -n "${__CPP_FILES_SH_SOURCED:-}" ]]; then
    return 0
fi
__CPP_FILES_SH_SOURCED=true

# Source necessary utilities and config
source "$(dirname "${BASH_SOURCE[0]}")/../helpers/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../core/config.sh"

# --- Internal Class/File Naming ---
# Sanitizes PROJECT_NAME for use as a C++ class and file prefix (e.g., My-Project -> MyProject)
get_sanitized_name() {
    echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9_]//g'
}

# Generates the header file content
generate_header() {
    if [[ "$FLAG_INIT_ONLY" == true ]]; then
        return
    fi
    
    local sanitized_name
    local class_name
    local header_path
    local header_guard
    
    sanitized_name=$(get_sanitized_name)
    class_name="${sanitized_name}Class"
    # Re-added safe expansion for INCLUDE_DIR
    header_path="$PROJECT_ROOT/${INCLUDE_DIR:-include}/${sanitized_name}.hpp"
    header_guard=$(echo "${sanitized_name}_${class_name}_HPP" | tr '[:lower:]' '[:upper:]')
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create header file: ${INCLUDE_DIR:-include}/${sanitized_name}.hpp"
        return
    fi

    # Use single quotes for EOF to ensure literal output of Doxygen and C++ syntax
    cat > "$header_path" << 'EOF'
#ifndef ${header_guard}
#define ${header_guard}

/**
 * @file ${sanitized_name}.hpp
 *
 * @brief Definition of class
 * @class ${PROJECT_NAME}::${class_name}
 * * @copyright ${AUTHOR_NAME}
 */

// Headers from this project
#include "${sanitized_name}.hpp"

// Headers from other projects

// Headers from standard libraries
#include <string>
#include <iostream>

namespace ${PROJECT_NAME} {
    class ${class_name};
}

/**
 * @brief Object for describing ${class_name}.
 *
 * Object for describing ${class_name} properties.
 */
class ${PROJECT_NAME}::${class_name}
{
private:

public:
};

#endif // ${header_guard}
EOF
    
    # Replace variables after literal EOF to insert dynamic values
    sed -i \
        -e "s/\${header_guard}/${header_guard}/g" \
        -e "s/\${sanitized_name}/${sanitized_name}/g" \
        -e "s/\${class_name}/${class_name}/g" \
        -e "s/\${PROJECT_NAME}/${PROJECT_NAME}/g" \
        -e "s/\${AUTHOR_NAME}/${AUTHOR_NAME}/g" \
        "$header_path"
        
    print_success "Generated header: ${INCLUDE_DIR:-include}/${sanitized_name}.hpp"
    # Updated print message to reflect new namespace
    print_verbose "Header created for class ${PROJECT_NAME}::${class_name}"
}

# Generates the source file content (implementation)
generate_implementation() {
    if [[ "$FLAG_INIT_ONLY" == true ]]; then
        return
    fi
    
    local sanitized_name
    local class_name
    local impl_path
    
    sanitized_name=$(get_sanitized_name)
    class_name="${sanitized_name}Class"
    # Re-added safe expansion for SRC_DIR
    impl_path="$PROJECT_ROOT/${SRC_DIR:-src}/${sanitized_name}.cpp"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create implementation file: ${SRC_DIR:-src}/${sanitized_name}.cpp"
        return
    fi
    
    # Use single quotes for EOF for literal output
    cat > "$impl_path" << 'EOF'
/**
 * @file ${sanitized_name}.cpp
 *
 * @brief Implementation of class
 * @class ${PROJECT_NAME}::${class_name}
 * * @copyright ${AUTHOR_NAME}
 */

// Headers from this project
#include "${sanitized_name}.hpp"

// Headers from other projects

// Headers from standard libraries
#include <string>
#include <iostream>
EOF

    # Replace variables after literal EOF
    sed -i \
        -e "s/\${sanitized_name}/${sanitized_name}/g" \
        -e "s/\${class_name}/${class_name}/g" \
        -e "s/\${PROJECT_NAME}/${PROJECT_NAME}/g" \
        -e "s/\${AUTHOR_NAME}/${AUTHOR_NAME}/g" \
        "$impl_path"
    
    print_success "Generated implementation: ${SRC_DIR:-src}/${sanitized_name}.cpp"
    print_verbose "Implementation created for class ${PROJECT_NAME}::${class_name}"
}

# Generates a basic main.cpp file
generate_main_cpp() {
    if [[ "$FLAG_INIT_ONLY" == true ]]; then
        return
    fi
    
    local sanitized_name
    local class_name
    local main_path
    
    sanitized_name=$(get_sanitized_name)
    class_name="${sanitized_name}Class"
    # Re-added safe expansion for SRC_DIR
    main_path="$PROJECT_ROOT/${SRC_DIR:-src}/main.cpp"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create main executable file: ${SRC_DIR:-src}/main.cpp"
        return
    fi

    cat > "$main_path" << 'EOF'
/**
 * @file main.cpp
 *
 * @brief Main application entry point.
 * * @copyright ${AUTHOR_NAME}
 */

// Headers from this project
#include "${sanitized_name}.hpp"

// Headers from other projects

// Headers from standard libraries
#include <iostream>
#include <string>

int main(int argc, char* argv[])
{
    (void)argc;
    (void)argv;
    
    // Use the generated class
    ${PROJECT_NAME}::${class_name} app;

    std::cout << "Starting ${PROJECT_NAME} application..." << std::endl;

    // Example of using a member function
    app.perform_operation();

    return 0;
}
EOF

    # Replace variables after literal EOF
    sed -i \
        -e "s/\${sanitized_name}/${sanitized_name}/g" \
        -e "s/\${class_name}/${class_name}/g" \
        -e "s/\${PROJECT_NAME}/${PROJECT_NAME}/g" \
        -e "s/\${AUTHOR_NAME}/${AUTHOR_NAME}/g" \
        "$main_path"
    
    print_success "Generated main executable: ${SRC_DIR:-src}/main.cpp"
}

# Generates a basic test file
generate_test_file() {
    if [[ "$FLAG_MINIMAL" == true || "$FLAG_INIT_ONLY" == true ]]; then
        return
    fi
    
    local sanitized_name
    local class_name
    local test_path
    
    sanitized_name=$(get_sanitized_name)
    class_name="${sanitized_name}Class"
    # Re-added safe expansion for TEST_DIR
    test_path="$PROJECT_ROOT/${TEST_DIR:-tests}/${sanitized_name}_test.cpp"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create test file: ${TEST_DIR:-tests}/${sanitized_name}_test.cpp"
        return
    fi

    cat > "$test_path" << 'EOF'
/**
 * @file ${sanitized_name}_test.cpp
 *
 * @brief Unit tests for the ${PROJECT_NAME}::${class_name} class.
 * * @copyright ${AUTHOR_NAME}
 */

// Headers from this project
#include "${sanitized_name}.hpp"

// Headers from standard libraries
#include <iostream>
#include <cassert>

// Simple assertion macro (replace with a proper testing framework like Catch2/GoogleTest)
#define TEST_ASSERT(condition, message) \
    if (!(condition)) { \
        std::cerr << "FAILED: " << message << std::endl; \
        exit(1); \
    }

void test_default_construction()
{
    ${PROJECT_NAME}::${class_name} obj;
    // Test that the constructor runs without exception
    std::cout << "Test 'test_default_construction' passed." << std::endl;
}

void test_helper_function()
{
    ${PROJECT_NAME}::${class_name} obj;
    // Test that the function can be called
    obj.perform_operation();
    std::cout << "Test 'test_helper_function' passed." << std::endl;
}

int main()
{
    std::cout << "--- Running Unit Tests for ${PROJECT_NAME}::${class_name} ---" << std::endl;
    test_default_construction();
    test_helper_function();
    std::cout << "--- All Tests Passed Successfully ---" << std::endl;
    return 0;
}
EOF

    # Replace variables after literal EOF
    sed -i \
        -e "s/\${sanitized_name}/${sanitized_name}/g" \
        -e "s/\${class_name}/${class_name}/g" \
        -e "s/\${PROJECT_NAME}/${PROJECT_NAME}/g" \
        -e "s/\${AUTHOR_NAME}/${AUTHOR_NAME}/g" \
        "$test_path"
    
    print_success "Generated test file: ${TEST_DIR:-tests}/${sanitized_name}_test.cpp"
}

