#!/bin/bash

# Icarus Verilog (iverilog) Installation Script
# Installs iverilog from system package manager or builds from source
# Usage: ./install_iverilog.sh [--system] [--source] [OPTIONS]

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
IVERILOG_REPO="https://github.com/steveicarus/iverilog.git"

# Installation mode
INSTALL_MODE="system"  # system or source
FORCE_REINSTALL=false
IVERILOG_VERSION=""  # Can specify version tag

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
    echo "Installs Icarus Verilog (iverilog) and vvp runtime"
    echo ""
    echo "Options:"
    echo "  --system            Install using system package manager (default)"
    echo "  --source            Build from source"
    echo "  --force             Force reinstall even if iverilog is already installed"
    echo "  --version VERSION   Install specific version from source (e.g., v12_0)"
    echo "  --help, -h          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  # Install via package manager"
    echo "  $0 --system         # Install via package manager"
    echo "  $0 --source         # Build from source"
    echo "  $0 --source --version v12_0  # Build specific version from source"
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
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to install system dependencies
install_system_dependencies() {
    local os=$(detect_os)
    print_status $BLUE "Installing system dependencies for $os..."
    
    case $os in
        debian)
            sudo apt-get update
            sudo apt-get install -y build-essential git autoconf gperf bison flex
            sudo apt-get install -y libreadline-dev gawk tcl-dev libffi-dev
            ;;
        rhel|fedora)
            if command_exists dnf; then
                sudo dnf install -y gcc gcc-c++ make git autoconf gperf bison flex
                sudo dnf install -y readline-devel gawk tcl-devel libffi-devel
            else
                sudo yum install -y gcc gcc-c++ make git autoconf gperf bison flex
                sudo yum install -y readline-devel gawk tcl-devel libffi-devel
            fi
            ;;
        macos)
            if ! command_exists brew; then
                print_status $RED "Error: Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            brew install autoconf gperf bison flex readline gawk tcl-tk
            ;;
        *)
            print_status $YELLOW "Warning: Unknown OS. You may need to install dependencies manually."
            ;;
    esac
}

# Function to check if iverilog is installed
check_iverilog_installed() {
    if command_exists iverilog && command_exists vvp; then
        local version=$(iverilog -v 2>&1 | head -1 || echo "unknown")
        print_status $GREEN "Icarus Verilog is already installed: $version"
        if [[ "$FORCE_REINSTALL" == false ]]; then
            print_status $YELLOW "Use --force to reinstall"
            return 0
        else
            print_status $YELLOW "Force reinstall requested"
            return 1
        fi
    else
        return 1
    fi
}

# Function to install from system package manager
install_from_system() {
    local os=$(detect_os)
    print_status $BLUE "Installing iverilog from system package manager ($os)..."
    
    case $os in
        debian)
            sudo apt-get update
            sudo apt-get install -y iverilog gtkwave
            ;;
        rhel|fedora)
            if command_exists dnf; then
                sudo dnf install -y iverilog gtkwave
            else
                sudo yum install -y iverilog gtkwave
            fi
            ;;
        macos)
            if ! command_exists brew; then
                print_status $RED "Error: Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            brew install icarus-verilog gtkwave
            ;;
        *)
            print_status $RED "Error: System package installation not supported for this OS"
            print_status $YELLOW "Please use --source to build from source"
            exit 1
            ;;
    esac
    
    # Verify installation
    if command_exists iverilog && command_exists vvp; then
        local version=$(iverilog -v 2>&1 | head -1 || echo "unknown")
        print_status $GREEN "Successfully installed: $version"
        return 0
    else
        print_status $RED "Installation failed: iverilog or vvp not found"
        return 1
    fi
}

# Function to install from source
install_from_source() {
    print_status $BLUE "Installing iverilog from source..."
    
    # Install system dependencies first
    install_system_dependencies
    
    # Create tools directory if it doesn't exist
    mkdir -p "$TOOLS_DIR"
    
    # Clone or update repository
    if [[ -d "$IVERILOG_DIR" ]]; then
        print_status $BLUE "Updating existing repository..."
        cd "$IVERILOG_DIR"
        git fetch --all --tags
        if [[ -n "$IVERILOG_VERSION" ]]; then
            git checkout "$IVERILOG_VERSION" || {
                print_status $RED "Error: Version $IVERILOG_VERSION not found"
                exit 1
            }
        else
            git checkout master || git checkout main
        fi
        git pull
    else
        print_status $BLUE "Cloning iverilog repository..."
        git clone "$IVERILOG_REPO" "$IVERILOG_DIR"
        cd "$IVERILOG_DIR"
        if [[ -n "$IVERILOG_VERSION" ]]; then
            git checkout "$IVERILOG_VERSION" || {
                print_status $RED "Error: Version $IVERILOG_VERSION not found"
                exit 1
            }
        fi
    fi
    
    # Build and install
    print_status $BLUE "Building iverilog..."
    sh autoconf.sh
    ./configure --prefix=/usr/local
    make -j$(nproc 2>/dev/null || echo 4)
    sudo make install
    
    # Verify installation
    if command_exists iverilog && command_exists vvp; then
        local version=$(iverilog -v 2>&1 | head -1 || echo "unknown")
        print_status $GREEN "Successfully installed from source: $version"
        return 0
    else
        print_status $RED "Installation failed: iverilog or vvp not found"
        return 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --system)
            INSTALL_MODE="system"
            shift
            ;;
        --source)
            INSTALL_MODE="source"
            shift
            ;;
        --force)
            FORCE_REINSTALL=true
            shift
            ;;
        --version)
            IVERILOG_VERSION="$2"
            shift 2
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

# Main installation
print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Icarus Verilog Installation${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_header

# Check if already installed
if check_iverilog_installed && [[ "$FORCE_REINSTALL" == false ]]; then
    print_status $GREEN "Icarus Verilog is already installed. Skipping installation."
    exit 0
fi

# Install based on mode
case $INSTALL_MODE in
    system)
        install_from_system
        ;;
    source)
        install_from_source
        ;;
    *)
        print_status $RED "Invalid installation mode: $INSTALL_MODE"
        exit 1
        ;;
esac

# Final verification
print_status $BLUE "Verifying installation..."
if command_exists iverilog && command_exists vvp; then
    print_status $GREEN "✓ iverilog: $(which iverilog)"
    print_status $GREEN "✓ vvp: $(which vvp)"
    print_status $GREEN "Installation complete!"
    
    # Show version
    echo ""
    iverilog -v 2>&1 | head -5
    echo ""
else
    print_status $RED "Installation verification failed"
    exit 1
fi
