#!/usr/bin/env bash

# === SHELL LIBRARY GUARD ===
# Prevent this file from being sourced multiple times
if [[ -n "${CPPINIT_CONFIG_LOADED:-}" ]]; then
    return 0
fi
readonly CPPINIT_CONFIG_LOADED=true

# lib/core/config.sh - Core configuration and metadata for cppinit

# --- Project Metadata & Constants (Readonly) ---

readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_NAME="cppinit"

# Default C++ standard to use
readonly CXX_STANDARD="c++17"

# Default executable name
readonly EXECUTABLE_NAME="cppinit_app"

# Default testing framework command
readonly TEST_COMMAND="./bin/${EXECUTABLE_NAME}_test"

# Default directories structure
readonly SRC_DIR="src"
readonly INCLUDE_DIR="include"
readonly BUILD_DIR="build"
readonly BIN_DIR="bin"
readonly TESTS_DIR="tests"
readonly DOCS_DIR="docs"

# --- Runtime Configuration Defaults ---

# Default values used for initialization
DEFAULT_LICENSE="MIT"
DEFAULT_MODE="Debug"
DEFAULT_AUTHOR="$(whoami)"

# Global variables (mutable, intended to be set by flags or user interaction)
PROJECT_NAME=""
AUTHOR_NAME="$DEFAULT_AUTHOR"
LICENSE_TYPE="$DEFAULT_LICENSE"
BUILD_MODE="$DEFAULT_MODE"
PROJECT_ROOT=""

# Flags (boolean variables, typically set via command-line options)
FLAG_MINIMAL=false
FLAG_NO_GIT=false
FLAG_QUIET=false
FLAG_VERBOSE=false
FLAG_DRY_RUN=false
FLAG_FORCE=false
FLAG_INIT_ONLY=false
FLAG_ASCII=true
FLAG_NON_INTERACTIVE=false

