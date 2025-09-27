#!/usr/bin/env bash

# lib/helpers/utils.sh - Utility functions for cppinit

# Color codes for beautiful terminal output
readonly RED=\'\\033[0;31m\'
readonly GREEN=\'\\033[0;32m\'
readonly YELLOW=\'\\033[0;33m\'
readonly BLUE=\'\\033[0;34m\'
readonly MAGENTA=\'\\033[0;35m\'
readonly CYAN=\'\\033[0;36m\'
readonly WHITE=\'\\033[0;37m\'
readonly BOLD=\'\\033[1m\'
readonly DIM=\'\\033[2m\'
readonly UNDERLINE=\'\\033[4m\'
readonly RESET=\'\\033[0m\'

# Print colored output
print_color() {
    local color="$1"
    local message="$2"
    if [[ "$FLAG_QUIET" != true ]]; then
        printf "${color}${message}${RESET}\\n"
    fi
}

# Print success message
print_success() {
    print_color "$GREEN" "[✓] $1"
}

# Print error message
print_error() {
    print_color "$RED" "[✗] $1" >&2
}

# Print warning message
print_warning() {
    print_color "$YELLOW" "[⚠] $1"
}

# Print info message
print_info() {
    print_color "$CYAN" "[ℹ] $1"
}

# Print verbose message
print_verbose() {
    if [[ "$FLAG_VERBOSE" == true ]]; then
        print_color "$DIM" "    $1"
    fi
}

# Print separator
print_separator() {
    if [[ "$FLAG_QUIET" != true ]]; then
        printf "${CYAN}%s${RESET}\\n" "$(printf \'%.0s─\' {1..60})"
    fi
}

# Print ASCII banner
print_banner() {
    if [[ "$FLAG_ASCII" == true && "$FLAG_QUIET" != true ]]; then
        cat << \'EOF\'
 ██████╗██████╗ ██████╗ ██╗███╗   ██╗██╗████████╗
██╔════╝██╔══██╗██╔══██╗██║████╗  ██║██║╚══██╔══╝
██║     ██████╔╝██████╔╝██║██╔██╗ ██║██║   ██║   
██║     ██╔═══╝ ██╔═══╝ ██║██║╚██╗██║██║   ██║   
╚██████╗██║     ██║     ██║██║ ╚████║██║   ██║   
 ╚═════╝╚═╝     ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   
                                                  
        🚀 C++ Project Initializer v1.0.0
EOF
        printf "\\n"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_verbose "Checking system prerequisites..."
    
    local missing_deps=()
    
    if ! command_exists "g++"; then
        missing_deps+=("g++")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install the missing dependencies and try again."
        exit 1
    fi
    
    print_verbose "All prerequisites satisfied"
}

# Validate project name
validate_project_name() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        print_error "Project name cannot be empty"
        return 1
    fi
    
    if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
        print_error "Invalid project name. Use alphanumeric characters, hyphens, and underscores only"
        return 1
    fi
    
    return 0
}

# Check if directory exists and handle conflicts
check_directory_conflict() {
    local dir="$1"
    
    if [[ -d "$dir" ]]; then
        if [[ "$FLAG_FORCE" == true ]]; then
            print_warning "Directory \'$dir\' exists. Forcing overwrite..."
            return 0
        else
            print_error "Directory \'$dir\' already exists"
            print_info "Use --force to overwrite existing directory"
            return 1
        fi
    fi
    
    return 0
}

