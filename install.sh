#!/usr/bin/env bash

# install.sh - Installation script for cppinit

set -euo pipefail

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="cppinit"

# Color codes for beautiful terminal output
readonly RED=\'\\033[0;31m\'
readonly GREEN=\'\\033[0;32m\'
readonly YELLOW=\'\\033[0;33m\'
readonly RESET=\'\\033[0m\'

print_color() {
    local color="$1"
    local message="$2"
    printf "${color}${message}${RESET}\\n"
}

print_success() {
    print_color "$GREEN" "[✓] $1"
}

print_error() {
    print_color "$RED" "[✗] $1" >&2
}

print_warning() {
    print_color "$YELLOW" "[⚠] $1"
}

# Check for root privileges
check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        print_error "This script requires root privileges. Please run with sudo."
        exit 1
    fi
}

# Install the cppinit script
install_script() {
    print_success "Installing ${SCRIPT_NAME} to ${INSTALL_DIR}..."
    cp "$(dirname "${BASH_SOURCE[0]}")/${SCRIPT_NAME}" "${INSTALL_DIR}/"
    chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
    print_success "${SCRIPT_NAME} installed successfully!"
}

# Main installation logic
main() {
    check_root
    install_script
    print_success "Installation complete. You can now run '${SCRIPT_NAME}' from anywhere."
}

main "$@"

