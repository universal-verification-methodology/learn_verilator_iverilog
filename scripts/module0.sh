#!/bin/bash

# Module 0: Installation and Setup Orchestrator
# This script runs examples and tests for Module 0
# Usage: ./module0.sh [OPTIONS]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MODULE0_DIR="$PROJECT_ROOT/module0"

# Options
RUN_IVERILOG_BASICS=true
RUN_VERILATOR_BASICS=true
RUN_IVERILOG_TESTS=true
RUN_VERILATOR_TESTS=true
RUN_COMPARISON=true
RUN_GTKWAVE_EXAMPLE=false  # Default false (requires GUI)

# Parallel build jobs (default: 8)
PARALLEL_JOBS=8

# Clean builds by default
CLEAN_BUILDS=true

# Log file setup - will be initialized in main()
LOG_FILE=""

# Function to setup logging (redirects stdout and stderr to both console and log file)
setup_logging() {
    # Initialize log file path
    LOG_FILE="$MODULE0_DIR/module0.log"
    mkdir -p "$MODULE0_DIR"
    
    # Create log file with timestamp header
    {
        echo "=========================================="
        echo "Module 0 Execution Log"
        echo "Started: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Command: $0 $*"
        echo "Working directory: $(pwd)"
        echo "Parallel jobs: $PARALLEL_JOBS"
        echo "Clean builds: $CLEAN_BUILDS"
        echo "=========================================="
        echo ""
    } > "$LOG_FILE"
    
    # Redirect stdout and stderr to both console and log file
    exec > >(tee -a "$LOG_FILE")
    exec 2>&1
}

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] ${message}${NC}"
}

print_header() {
    local message=$1
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$message${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Module 0: Installation and Setup
This script runs examples and tests for Module 0.

OPTIONS:
    Examples:
        --iverilog-basics      Run iverilog basic examples
        --verilator-basics      Run Verilator basic examples
        --gtkwave-example      Run GTKWave waveform example (requires GUI)
        --all-examples         Run all examples (default)
        --skip-examples        Skip all examples
    
    Tests:
        --iverilog-tests       Run iverilog testbenches
        --verilator-tests      Run Verilator testbenches
        --all-tests            Run all tests (default)
        --skip-tests           Skip all tests
    
    Comparison:
        --comparison           Run comparison examples (default)
        --skip-comparison      Skip comparison examples
    
    Environment:
        --jobs N               Number of parallel build jobs (default: 8)
        --no-clean             Skip cleaning before build (faster rebuilds)
    
    Other:
        --help, -h             Show this help message

EXAMPLES:
    # Run all examples and tests
    $0
    
    # Run only iverilog examples
    $0 --iverilog-basics
    
    # Run only Verilator examples
    $0 --verilator-basics
    
    # Run all tests
    $0 --all-tests
    
    # Faster rebuilds (skip cleaning)
    $0 --no-clean --jobs 8

EOF
}

# Function to check prerequisites
check_prerequisites() {
    print_status $BLUE "Checking prerequisites..."
    
    local missing_tools=0
    
    # Check iverilog
    if ! command -v iverilog &> /dev/null; then
        print_status $RED "Error: iverilog not found. Please install it first."
        print_status $YELLOW "Run: ./scripts/install_iverilog.sh"
        missing_tools=$((missing_tools + 1))
    else
        local iverilog_version=$(iverilog -v 2>&1 | head -1 || echo "unknown")
        print_status $GREEN "Found iverilog: $iverilog_version"
    fi
    
    # Check vvp
    if ! command -v vvp &> /dev/null; then
        print_status $RED "Error: vvp not found. Please install iverilog first."
        missing_tools=$((missing_tools + 1))
    else
        print_status $GREEN "Found vvp: $(which vvp)"
    fi
    
    # Check Verilator
    if ! command -v verilator &> /dev/null; then
        print_status $RED "Error: verilator not found. Please install it first."
        print_status $YELLOW "Run: ./scripts/install_verilator.sh"
        missing_tools=$((missing_tools + 1))
    else
        local verilator_version=$(verilator --version | head -1 | awk '{print $2}')
        print_status $GREEN "Found Verilator version: $verilator_version"
    fi
    
    # Check Make
    if ! command -v make &> /dev/null; then
        print_status $RED "Error: make not found. Please install it first."
        missing_tools=$((missing_tools + 1))
    fi
    
    # Check GTKWave (optional, but recommended)
    if ! command -v gtkwave &> /dev/null; then
        print_status $YELLOW "Note: GTKWave not found (optional but recommended for waveform viewing)"
        print_status $YELLOW "Install with: ./scripts/install_gtkwave.sh"
    else
        print_status $GREEN "Found gtkwave: $(which gtkwave)"
    fi
    
    if [[ $missing_tools -gt 0 ]]; then
        print_status $RED "Please install missing tools before running Module 0 examples."
        exit 1
    fi
    
    print_status $GREEN "Prerequisites check passed"
}

# Function to run iverilog example
run_iverilog_example() {
    local example_dir=$1
    local example_name=$2
    
    print_header "Running iverilog example: $example_name"
    
    cd "$MODULE0_DIR/examples/$example_dir" || {
        print_status $RED "Error: Failed to change to example directory: $example_dir"
        return 1
    }
    
    # Clean previous builds
    if [[ "$CLEAN_BUILDS" == true ]]; then
        make clean >/dev/null 2>&1 || true
    fi
    
    # Run make
    set +e
    make 2>&1 | tee run.log
    local exit_code=${PIPESTATUS[0]}
    set -e
    
    cd "$PROJECT_ROOT"
    
    if [[ $exit_code -eq 0 ]]; then
        print_status $GREEN "✓ $example_name completed successfully"
        return 0
    else
        print_status $RED "✗ $example_name failed (exit code: $exit_code)"
        print_status $YELLOW "Check $MODULE0_DIR/examples/$example_dir/run.log for details"
        return 1
    fi
}

# Function to run Verilator example
run_verilator_example() {
    local example_dir=$1
    local example_name=$2
    
    print_header "Running Verilator example: $example_name"
    
    cd "$MODULE0_DIR/examples/$example_dir" || {
        print_status $RED "Error: Failed to change to example directory: $example_dir"
        return 1
    }
    
    # Clean previous builds
    if [[ "$CLEAN_BUILDS" == true ]]; then
        make clean >/dev/null 2>&1 || true
    fi
    
    # Run make
    set +e
    make 2>&1 | tee run.log
    local exit_code=${PIPESTATUS[0]}
    set -e
    
    cd "$PROJECT_ROOT"
    
    if [[ $exit_code -eq 0 ]]; then
        print_status $GREEN "✓ $example_name completed successfully"
        return 0
    else
        print_status $RED "✗ $example_name failed (exit code: $exit_code)"
        print_status $YELLOW "Check $MODULE0_DIR/examples/$example_dir/run.log for details"
        return 1
    fi
}

# Function to run iverilog tests
run_iverilog_tests() {
    print_header "Running iverilog Tests"
    
    cd "$MODULE0_DIR/tests/iverilog_tests" || {
        print_status $RED "Error: Failed to change to iverilog tests directory"
        return 1
    }
    
    local failed=0
    
    # Clean and run tests
    if [[ "$CLEAN_BUILDS" == true ]]; then
        make clean >/dev/null 2>&1 || true
    fi
    
    set +e
    make 2>&1 | tee test.log
    local exit_code=${PIPESTATUS[0]}
    set -e
    
    cd "$PROJECT_ROOT"
    
    if [[ $exit_code -eq 0 ]]; then
        print_status $GREEN "✓ All iverilog tests passed"
        return 0
    else
        print_status $RED "✗ Some iverilog tests failed (exit code: $exit_code)"
        print_status $YELLOW "Check $MODULE0_DIR/tests/iverilog_tests/test.log for details"
        return 1
    fi
}

# Function to run Verilator tests
run_verilator_tests() {
    print_header "Running Verilator Tests"
    
    cd "$MODULE0_DIR/tests/verilator_tests" || {
        print_status $RED "Error: Failed to change to Verilator tests directory"
        return 1
    }
    
    local failed=0
    
    # Clean and run tests
    if [[ "$CLEAN_BUILDS" == true ]]; then
        make clean >/dev/null 2>&1 || true
    fi
    
    set +e
    make 2>&1 | tee test.log
    local exit_code=${PIPESTATUS[0]}
    set -e
    
    cd "$PROJECT_ROOT"
    
    if [[ $exit_code -eq 0 ]]; then
        print_status $GREEN "✓ All Verilator tests passed"
        return 0
    else
        print_status $RED "✗ Some Verilator tests failed (exit code: $exit_code)"
        print_status $YELLOW "Check $MODULE0_DIR/tests/verilator_tests/test.log for details"
        return 1
    fi
}

# Function to run comparison examples
run_comparison() {
    print_header "Running Comparison Examples"
    
    print_status $BLUE "This section demonstrates the differences between iverilog and Verilator testbenches."
    print_status $BLUE "See module0/examples/comparison/ for side-by-side comparisons."
    
    # Check if comparison examples exist
    if [[ -d "$MODULE0_DIR/examples/comparison" ]]; then
        print_status $GREEN "Comparison examples directory found"
        print_status $YELLOW "Run individual comparison examples from module0/examples/comparison/"
    else
        print_status $YELLOW "Comparison examples directory not found (optional)"
    fi
    
    return 0
}

# Parse command line arguments (before logging setup)
parse_args() {
while [[ $# -gt 0 ]]; do
    case $1 in
        --iverilog-basics)
            RUN_IVERILOG_BASICS=true
            RUN_VERILATOR_BASICS=false
            shift
            ;;
        --verilator-basics)
            RUN_IVERILOG_BASICS=false
            RUN_VERILATOR_BASICS=true
            shift
            ;;
        --all-examples)
            RUN_IVERILOG_BASICS=true
            RUN_VERILATOR_BASICS=true
            shift
            ;;
        --skip-examples)
            RUN_IVERILOG_BASICS=false
            RUN_VERILATOR_BASICS=false
            shift
            ;;
        --iverilog-tests)
            RUN_IVERILOG_TESTS=true
            RUN_VERILATOR_TESTS=false
            shift
            ;;
        --verilator-tests)
            RUN_IVERILOG_TESTS=false
            RUN_VERILATOR_TESTS=true
            shift
            ;;
        --all-tests)
            RUN_IVERILOG_TESTS=true
            RUN_VERILATOR_TESTS=true
            shift
            ;;
        --skip-tests)
            RUN_IVERILOG_TESTS=false
            RUN_VERILATOR_TESTS=false
            shift
            ;;
        --comparison)
            RUN_COMPARISON=true
            shift
            ;;
        --skip-comparison)
            RUN_COMPARISON=false
            shift
            ;;
        --gtkwave-example)
            RUN_GTKWAVE_EXAMPLE=true
            shift
            ;;
        --jobs)
            PARALLEL_JOBS="$2"
            shift 2
            ;;
        --no-clean)
            CLEAN_BUILDS=false
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

# Main execution
main() {
    # Parse arguments first (so help can be shown without logging)
    parse_args "$@"
    # Setup logging after argument parsing (before actual work)
    setup_logging "$@"
    
    print_header "Module 0: Installation and Setup"
    print_status $BLUE "Log file: $LOG_FILE"
    
    # Check prerequisites
    check_prerequisites
    
    local failed=0
    local gtkwave_opened=false  # Track if GTKWave has been opened
    local vcd_file_to_open=""   # Track which VCD file to open
    
    # Run iverilog examples
    if [[ "$RUN_IVERILOG_BASICS" == true ]]; then
        cd "$MODULE0_DIR/examples/iverilog_basics" || {
            print_status $RED "Error: Failed to change to iverilog examples directory"
            exit 1
        }
        if [[ "$CLEAN_BUILDS" == true ]]; then
            make clean >/dev/null 2>&1 || true
        fi
        set +e
        make all 2>&1 | tee run.log
        local exit_code=${PIPESTATUS[0]}
        set -e
        cd "$PROJECT_ROOT"
        if [[ $exit_code -eq 0 ]]; then
            print_status $GREEN "✓ All iverilog examples completed successfully"
            
            # Track VCD file for opening at the end (don't open yet)
            local vcd_file="$MODULE0_DIR/examples/iverilog_basics/gtkwave_example.vcd"
            if [[ -f "$vcd_file" ]]; then
                vcd_file_to_open="$vcd_file"
            fi
        else
            print_status $RED "✗ Some iverilog examples failed"
            failed=$((failed + 1))
        fi
    fi
    
    # Run Verilator examples
    if [[ "$RUN_VERILATOR_BASICS" == true ]]; then
        cd "$MODULE0_DIR/examples/verilator_basics" || {
            print_status $RED "Error: Failed to change to Verilator examples directory"
            exit 1
        }
        if [[ "$CLEAN_BUILDS" == true ]]; then
            make clean >/dev/null 2>&1 || true
        fi
        set +e
        make all 2>&1 | tee run.log
        local exit_code=${PIPESTATUS[0]}
        set -e
        cd "$PROJECT_ROOT"
        if [[ $exit_code -eq 0 ]]; then
            print_status $GREEN "✓ All Verilator examples completed successfully"
        else
            print_status $RED "✗ Some Verilator examples failed"
            failed=$((failed + 1))
        fi
    fi
    
    # Run tests
    if [[ "$RUN_IVERILOG_TESTS" == true ]]; then
        run_iverilog_tests || failed=$((failed + 1))
        
        # Track test VCD file (prefer test VCD over example VCD if both exist)
        local test_vcd="$MODULE0_DIR/tests/iverilog_tests/test_and_gate.vcd"
        if [[ -f "$test_vcd" ]]; then
            vcd_file_to_open="$test_vcd"
        fi
    fi
    
    if [[ "$RUN_VERILATOR_TESTS" == true ]]; then
        run_verilator_tests || failed=$((failed + 1))
    fi
    
    # Run comparison
    if [[ "$RUN_COMPARISON" == true ]]; then
        run_comparison || failed=$((failed + 1))
    fi
    
    # Run GTKWave example (if explicitly requested and not already run as part of iverilog basics)
    if [[ "$RUN_GTKWAVE_EXAMPLE" == true ]] && [[ "$RUN_IVERILOG_BASICS" != true ]]; then
        print_header "Running GTKWave Example"
        cd "$MODULE0_DIR/examples/iverilog_basics" || {
            print_status $RED "Error: Failed to change to iverilog examples directory"
            exit 1
        }
        if [[ "$CLEAN_BUILDS" == true ]]; then
            make clean >/dev/null 2>&1 || true
        fi
        set +e
        make gtkwave_example 2>&1 | tee gtkwave.log
        local exit_code=${PIPESTATUS[0]}
        set -e
        
        if [[ $exit_code -eq 0 ]]; then
            print_status $GREEN "✓ GTKWave example completed successfully"
            local vcd_file="$MODULE0_DIR/examples/iverilog_basics/gtkwave_example.vcd"
            if [[ -f "$vcd_file" ]]; then
                vcd_file_to_open="$vcd_file"
            fi
        else
            print_status $RED "✗ GTKWave example failed"
            failed=$((failed + 1))
        fi
        
        cd "$PROJECT_ROOT"
    fi
    
    # Open GTKWave once at the end if VCD file was generated
    if [[ -n "$vcd_file_to_open" ]] && [[ -f "$vcd_file_to_open" ]]; then
        if command -v gtkwave &> /dev/null; then
            print_status $BLUE "Opening GTKWave to view waveforms..."
            if [[ -n "${DISPLAY:-}" ]] || [[ "$OSTYPE" == "darwin"* ]]; then
                # Check for corresponding .gtkw save file
                local gtkw_file="${vcd_file_to_open%.vcd}.gtkw"
                if [[ -f "$gtkw_file" ]]; then
                    gtkwave "$vcd_file_to_open" "$gtkw_file" &
                    print_status $GREEN "✓ GTKWave opened with waveform and signal configuration"
                else
                    gtkwave "$vcd_file_to_open" &
                    print_status $GREEN "✓ GTKWave opened with waveform file: $(basename "$vcd_file_to_open")"
                    print_status $YELLOW "Note: Signals need to be added manually:"
                    print_status $YELLOW "  1. Expand hierarchy in left panel (SST)"
                    print_status $YELLOW "  2. Select signals (clk, a, b, y, etc.)"
                    print_status $YELLOW "  3. Drag to waveform viewer (right panel)"
                    print_status $YELLOW "  4. Save: File -> Write Save File (creates .gtkw for next time)"
                fi
                print_status $YELLOW "GTKWave is running in the background"
                gtkwave_opened=true
            else
                print_status $YELLOW "No display available. To view waveforms:"
                print_status $YELLOW "  gtkwave $vcd_file_to_open"
            fi
        else
            print_status $YELLOW "GTKWave not found. Install with: ./scripts/install_gtkwave.sh"
            print_status $YELLOW "VCD file generated: $vcd_file_to_open"
        fi
    fi
    
    # Summary
    echo ""
    print_header "Summary"
    if [[ $failed -eq 0 ]]; then
        print_status $GREEN "✓ All examples and tests completed successfully!"
        if [[ "$gtkwave_opened" == true ]]; then
            print_status $BLUE "Waveforms are available in GTKWave"
        fi
        echo ""
        print_status $BLUE "Full log saved to: $LOG_FILE"
        
        # Add footer to log file
        {
            echo ""
            echo "=========================================="
            echo "Module 0 Execution Log - Completed"
            echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Exit code: 0"
            echo "=========================================="
        } >> "$LOG_FILE"
        
        return 0
    else
        print_status $RED "✗ $failed example(s) or test(s) failed"
        echo ""
        print_status $YELLOW "Check log file for details: $LOG_FILE"
        
        # Add footer to log file
        {
            echo ""
            echo "=========================================="
            echo "Module 0 Execution Log - Completed"
            echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Exit code: $failed"
            echo "=========================================="
        } >> "$LOG_FILE"
        
        return 1
    fi
}

# Run main function
main
