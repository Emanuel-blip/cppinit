#!/usr/bin/env bash

# === SHELL LIBRARY GUARD ===
# Prevent this file from being sourced multiple times
if [[ -n "${CPPINIT_INPUT_LOADED:-}" ]]; then
    return 0
fi
readonly CPPINIT_INPUT_LOADED=true

# lib/core/input_handler.sh - Handles user input for cppinit

# Source necessary utilities and config (assuming this file is in lib/core)
source "$(dirname "${BASH_SOURCE[0]}")/../helpers/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

# Prompt for user input
prompt_input() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"
    
    # Non-interactive mode: set the default value and exit function
    if [[ "$FLAG_NON_INTERACTIVE" == true ]]; then
        eval "$var_name=\"$default\""
        return
    fi # Added missing 'fi'

    # Print prompt and default value (if available)
    printf "${CYAN}$prompt${RESET}"
    if [[ -n "$default" ]]; then
        printf " ${DIM}[$default]${RESET}"
    fi # Added missing 'fi'
    printf ": "
    
    local input
    # Read user input
    read -r input
    
    # If input is empty and a default exists, use the default
    if [[ -z "$input" && -n "$default" ]]; then
        input="$default"
    fi # Added missing 'fi'
    
    # Use eval to assign the collected input back to the variable name passed in $3
    eval "$var_name=\"$input\""
}

# Interactive project setup
interactive_setup() {
    print_info "Starting interactive project setup..."
    printf "\n"
    
    # --- 1. Project name ---
    if [[ -z "$PROJECT_NAME" ]]; then
        while true; do
            # Note: We pass an empty string as default here, as the name is mandatory
            prompt_input "Project name" "" PROJECT_NAME
            # The validate_project_name function is sourced from utils.sh
            if validate_project_name "$PROJECT_NAME"; then
                break
            fi
        done
    else
        print_success "Project name set to: $PROJECT_NAME (from command line)"
    fi

    # --- 2. Author name ---
    prompt_input "Author name" "$DEFAULT_AUTHOR" AUTHOR_NAME
    
    # --- 3. License selection ---
    printf "\n${CYAN}Select license type:${RESET}\n"
    printf "  1) MIT\n  2) GPL-3.0\n  3) Apache-2.0\n  4) BSD-3-Clause\n  5) Unlicense\n"
    printf "${CYAN}License choice${RESET} ${DIM}[1]${RESET}: "
    
    local license_choice
    read -r license_choice
    
    case "${license_choice:-1}" in
        1|MIT|mit) LICENSE_TYPE="MIT" ;;
        2|GPL-3.0|gpl-3.0|GPL|gpl) LICENSE_TYPE="GPL-3.0" ;;
        3|Apache-2.0|apache-2.0|Apache|apache) LICENSE_TYPE="Apache-2.0" ;;
        4|BSD-3-Clause|bsd-3-clause|BSD|bsd) LICENSE_TYPE="BSD-3-Clause" ;;
        5|Unlicense|unlicense) LICENSE_TYPE="Unlicense" ;;
        *) LICENSE_TYPE="MIT"; print_warning "Invalid choice. Using MIT license." ;;
    esac
    
    # --- 4. Build mode ---
    printf "\n${CYAN}Build mode:${RESET}\n"
    printf "  1) Debug (-g -Wall -Wextra)\n  2) Release (-O2 -DNDEBUG)\n"
    printf "${CYAN}Mode choice${RESET} ${DIM}[1]${RESET}: "
    
    local mode_choice
    read -r mode_choice
    
    case "${mode_choice:-1}" in
        1|Debug|debug) BUILD_MODE="Debug" ;;
        2|Release|release) BUILD_MODE="Release" ;;
        *) BUILD_MODE="Debug"; print_warning "Invalid choice. Using Debug mode." ;;
    esac
    
    printf "\n"
}

