#!/usr/bin/env bash

# lib/core/config.sh - Configuration and constants for cppinit

readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_NAME="cppinit"

# Default values
DEFAULT_LICENSE="MIT"
DEFAULT_MODE="Debug"
DEFAULT_AUTHOR="$(whoami)"

# Global variables
PROJECT_NAME=""
AUTHOR_NAME="$DEFAULT_AUTHOR"
LICENSE_TYPE="$DEFAULT_LICENSE"
BUILD_MODE="$DEFAULT_MODE"
PROJECT_ROOT=""

# Flags
FLAG_MINIMAL=false
FLAG_NO_GIT=false
FLAG_QUIET=false
FLAG_VERBOSE=false
FLAG_DRY_RUN=false
FLAG_FORCE=false
FLAG_INIT_ONLY=false
FLAG_ASCII=true
FLAG_NON_INTERACTIVE=false

