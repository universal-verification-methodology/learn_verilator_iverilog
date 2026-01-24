#!/bin/bash

# Icarus Verilog (iverilog) Uninstallation Script
# Uninstalls iverilog installed via this script
# Usage: ./uninstall_iverilog.sh [--system] [--keep-source]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TOOLS_DIR="$PROJECT_ROOT/tools"
IVERILOG_DIR="$TOOLS_DIR/iverilog"

# Options
UNINSTALL_SYSTEM=false
KEEP_SOURCE=false

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] ${message}${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --system           Also uninstall system package (apt/yum/brew)"
    echo "  --keep-source      Keep the source directory (don't remove it)"
    echo "  --help, -h         Show this help message"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            echo "debian"
        elif command_exists yum; then
            echo "rhel"
        elif command_exists dnf; then
            echo "fedora"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to uninstall from source build
uninstall_from_source() {
    if [[ -d "$IVERILOG_DIR" ]]; then
        print_status $BLUE "Uninstalling iverilog from source build..."
        cd "$IVERILOG_DIR"
        
        if [[ -f "Makefile" ]]; then
            print_status $BLUE "Running make uninstall..."
            sudo make uninstall 2>/dev/null || print_status $YELLOW "make uninstall failed or already uninstalled"
        else
            print_status $YELLOW "Makefile not found, skipping make uninstall"
        fi
        
        cd "$PROJECT_ROOT"
    else
        print_status $YELLOW "iverilog source directory not found: $IVERILOG_DIR"
    fi
}

# Function to uninstall system package
uninstall_system_package() {
    local os=$(detect_os)
    print_status $BLUE "Uninstalling iverilog system package..."
    
    case $os in
        debian)
            sudo apt-get remove -y iverilog gtkwave || true
            sudo apt-get autoremove -y || true
            ;;
        rhel|fedora)
            if command_exists dnf; then
                sudo dnf remove -y iverilog gtkwave || true
            else
                sudo yum remove -y iverilog gtkwave || true
            fi
            ;;
        macos)
            brew uninstall icarus-verilog gtkwave || true
            ;;
        *)
            print_status $YELLOW "Warning: System package uninstallation not supported on this OS"
            ;;
    esac
}

# Function to remove source directory
remove_source() {
    if [[ -d "$IVERILOG_DIR" ]]; then
        print_status $BLUE "Removing iverilog source directory..."
        rm -rf "$IVERILOG_DIR"
        print_status $GREEN "Source directory removed"
    else
        print_status $YELLOW "iverilog source directory not found: $IVERILOG_DIR"
    fi
}

# Function to parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --system)
                UNINSTALL_SYSTEM=true
                shift
                ;;
            --keep-source)
                KEEP_SOURCE=true
                shift
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            *)
                print_status $RED "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Main function
main() {
    print_status $BLUE "Starting Icarus Verilog uninstallation..."
    
    # Parse arguments
    parse_args "$@"
    
    # Check if iverilog is installed
    if ! command_exists iverilog && ! command_exists vvp; then
        print_status $YELLOW "iverilog/vvp is not installed or not in PATH"
    else
        if command_exists iverilog; then
            local version=$(iverilog -v 2>&1 | head -1 || echo "unknown")
            print_status $BLUE "Found iverilog: $version"
        fi
        if command_exists vvp; then
            print_status $BLUE "Found vvp: $(which vvp)"
        fi
    fi
    
    # Uninstall from source build
    uninstall_from_source
    
    # Uninstall system package if requested
    if [[ "$UNINSTALL_SYSTEM" == true ]]; then
        uninstall_system_package
    fi
    
    # Remove source directory if not keeping it
    if [[ "$KEEP_SOURCE" == false ]]; then
        remove_source
    else
        print_status $BLUE "Keeping source directory as requested"
    fi
    
    # Verify uninstallation
    if command_exists iverilog || command_exists vvp; then
        print_status $YELLOW "Warning: iverilog/vvp command still available. You may need to:"
        echo "  - Restart your terminal"
        echo "  - Check other installation locations"
        echo "  - Remove from PATH manually"
    else
        print_status $GREEN "Icarus Verilog uninstallation completed successfully!"
    fi
}

# Run main function with all arguments
main "$@"
