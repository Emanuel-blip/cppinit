#!/usr/bin/env bash

# lib/generators/gitignore.sh - Generates .gitignore for cppinit

# Source necessary utilities and config
source "$(dirname "${BASH_SOURCE[0]}")/../helpers/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../core/config.sh"

# Generate .gitignore
generate_gitignore() {
    local file="$PROJECT_ROOT/.gitignore"
    
    if [[ "$FLAG_DRY_RUN" == true ]]; then
        print_warning "DRY RUN: Would create .gitignore"
        return
    fi
    
    cat > "$file" << \'EOF\'
# Compiled Object files
*.o
*.obj

# Compiled Dynamic libraries
*.so
*.dylib
*.dll

# Compiled Static libraries
*.a
*.lib

# Executables
*.exe
*.out
*.app

# Build directories
build/
bin/
dist/

# CMake generated files
CMakeCache.txt
CMakeFiles/
cmake_install.cmake
Makefile
!Makefile  # Keep our custom Makefile

# Debug files
*.dSYM/
*.su
*.idb
*.pdb

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Vim temporary files
.*.sw[a-p]
.*.un~
Session.vim
.netrwhist

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Log files
*.log

# Temporary files
*.tmp
*.temp

# Package files
*.tar.gz
*.zip
*.rar

# Documentation generated files
html/
latex/
docs/html/
docs/latex/

# Clang files
.clangd/
compile_commands.json

# Coverage files
*.gcov
*.gcda
*.gcno
coverage.info
coverage/

# Valgrind files
*.memcheck
*.helgrind
*.cachegrind
*.callgrind

# Profiling files
gmon.out
*.prof

# Core dumps
core
core.*
EOF
    
    print_success "Generated .gitignore"
    print_verbose ".gitignore created with C++ and Vim-specific rules"
}

