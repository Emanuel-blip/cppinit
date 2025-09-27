#!/usr/bin/env bash

# lib/core/directory_manager.sh - Manages directory creation for cppinit

# Source necessary utilities and config
source "$(dirname "${BASH_SOURCE[0]}")/../helpers/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

# Create project directories
create_directories() {
    print_info "Creating project structure..."
    
    local dirs=("src" "include" "build" "bin" "docs" ".config")
    
    if [[ "$FLAG_MINIMAL" != true ]]; then
        dirs+=("tests")
    fi
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create directories: ${dirs[*]}"
        return
    fi
    
    # Create project root
    if [[ "$FLAG_FORCE" == true && -d "$PROJECT_ROOT" ]]; then
        rm -rf "$PROJECT_ROOT"
        print_verbose "Removed existing directory"
    fi
    
    mkdir -p "$PROJECT_ROOT"
    print_verbose "Created project root: $PROJECT_ROOT"
    
    # Create subdirectories
    for dir in "${dirs[@]}"; do
        mkdir -p "$PROJECT_ROOT/$dir"
        print_success "Created $dir/"
        print_verbose "Directory path: $PROJECT_ROOT/$dir"
    done
}

