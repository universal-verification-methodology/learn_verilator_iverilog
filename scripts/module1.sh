#!/bin/bash

# Module 1: iverilog Deep Dive Orchestrator
# This script runs examples and tests for Module 1
# Usage: ./module1.sh [OPTIONS]

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
MODULE1_DIR="$PROJECT_ROOT/module1"

# Options
RUN_COMPILATION=true
RUN_SIMULATION=true
RUN_TESTBENCH_BASICS=true
RUN_FILE_IO=true
RUN_WAVEFORMS=true
RUN_DEBUGGING=true
RUN_ADVANCED=false  # Default false (advanced topics)
RUN_BASIC_TESTS=true
RUN_FILE_IO_TESTS=true

# Parallel build jobs
PARALLEL_JOBS=8

# Clean builds by default
CLEAN_BUILDS=true

# Log file setup - will be initialized in main()
LOG_FILE=""

# Function to setup logging (redirects stdout and stderr to both console and log file)
setup_logging() {
    # Initialize log file path
    LOG_FILE="$MODULE1_DIR/module1.log"
    mkdir -p "$MODULE1_DIR"
    
    # Create log file with timestamp header
    {
        echo "=========================================="
        echo "Module 1 Execution Log"
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

Module 1: iverilog Deep Dive
This script runs examples and tests for Module 1.

OPTIONS:
    Examples:
        --compilation          Run compilation examples
        --simulation           Run VVP simulation examples
        --testbench-basics     Run testbench basics examples
        --file-io              Run file I/O examples
        --waveforms            Run waveform generation examples
        --debugging            Run debugging examples
        --advanced             Run advanced iverilog features
        --all-examples         Run all examples (default)
        --skip-examples        Skip all examples
    
    Tests:
        --basic-tests          Run basic testbenches
        --file-io-tests       Run file I/O testbenches
        --all-tests            Run all tests (default)
        --skip-tests           Skip all tests
    
    Environment:
        --jobs N               Number of parallel build jobs (default: 8)
        --no-clean             Skip cleaning before build (faster rebuilds)
    
    Other:
        --help, -h             Show this help message

EXAMPLES:
    # Run all examples and tests
    $0
    
    # Run only compilation examples
    $0 --compilation
    
    # Run only testbench basics
    $0 --testbench-basics
    
    # Run all tests
    $0 --all-tests
    
    # Faster rebuilds
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
    
    # Check Make
    if ! command -v make &> /dev/null; then
        print_status $RED "Error: make not found. Please install it first."
        missing_tools=$((missing_tools + 1))
    fi
    
    if [[ $missing_tools -gt 0 ]]; then
        print_status $RED "Please install missing tools before running Module 1 examples."
        exit 1
    fi
    
    print_status $GREEN "Prerequisites check passed"
}

# Function to run example directory
run_example_dir() {
    local example_dir=$1
    local example_name=$2
    
    print_header "Running: $example_name"
    
    cd "$MODULE1_DIR/examples/$example_dir" || {
        print_status $RED "Error: Failed to change to example directory: $example_dir"
        return 1
    }
    
    # Clean previous builds
    if [[ "$CLEAN_BUILDS" == true ]]; then
        make clean >/dev/null 2>&1 || true
    fi
    
    # Run make
    set +e
    make all 2>&1 | tee run.log
    local exit_code=${PIPESTATUS[0]}
    set -e
    
    cd "$PROJECT_ROOT"
    
    if [[ $exit_code -eq 0 ]]; then
        print_status $GREEN "✓ $example_name completed successfully"
        return 0
    else
        print_status $RED "✗ $example_name failed (exit code: $exit_code)"
        print_status $YELLOW "Check $MODULE1_DIR/examples/$example_dir/run.log for details"
        return 1
    fi
}

# Function to run test directory
run_test_dir() {
    local test_dir=$1
    local test_name=$2
    
    print_header "Running: $test_name"
    
    cd "$MODULE1_DIR/tests/$test_dir" || {
        print_status $RED "Error: Failed to change to test directory: $test_dir"
        return 1
    }
    
    # Clean previous builds
    if [[ "$CLEAN_BUILDS" == true ]]; then
        make clean >/dev/null 2>&1 || true
    fi
    
    # Run make
    set +e
    make all 2>&1 | tee test.log
    local exit_code=${PIPESTATUS[0]}
    set -e
    
    cd "$PROJECT_ROOT"
    
    if [[ $exit_code -eq 0 ]]; then
        print_status $GREEN "✓ $test_name passed"
        return 0
    else
        print_status $RED "✗ $test_name failed (exit code: $exit_code)"
        print_status $YELLOW "Check $MODULE1_DIR/tests/$test_dir/test.log for details"
        return 1
    fi
}

# Parse command line arguments (before logging setup)
parse_args() {
while [[ $# -gt 0 ]]; do
    case $1 in
        --compilation)
            RUN_COMPILATION=true
            RUN_SIMULATION=false
            RUN_TESTBENCH_BASICS=false
            RUN_FILE_IO=false
            RUN_WAVEFORMS=false
            RUN_DEBUGGING=false
            shift
            ;;
        --simulation)
            RUN_COMPILATION=false
            RUN_SIMULATION=true
            RUN_TESTBENCH_BASICS=false
            RUN_FILE_IO=false
            RUN_WAVEFORMS=false
            RUN_DEBUGGING=false
            shift
            ;;
        --testbench-basics)
            RUN_COMPILATION=false
            RUN_SIMULATION=false
            RUN_TESTBENCH_BASICS=true
            RUN_FILE_IO=false
            RUN_WAVEFORMS=false
            RUN_DEBUGGING=false
            shift
            ;;
        --file-io)
            RUN_COMPILATION=false
            RUN_SIMULATION=false
            RUN_TESTBENCH_BASICS=false
            RUN_FILE_IO=true
            RUN_WAVEFORMS=false
            RUN_DEBUGGING=false
            shift
            ;;
        --waveforms)
            RUN_COMPILATION=false
            RUN_SIMULATION=false
            RUN_TESTBENCH_BASICS=false
            RUN_FILE_IO=false
            RUN_WAVEFORMS=true
            RUN_DEBUGGING=false
            shift
            ;;
        --debugging)
            RUN_COMPILATION=false
            RUN_SIMULATION=false
            RUN_TESTBENCH_BASICS=false
            RUN_FILE_IO=false
            RUN_WAVEFORMS=false
            RUN_DEBUGGING=true
            shift
            ;;
        --advanced)
            RUN_ADVANCED=true
            shift
            ;;
        --all-examples)
            RUN_COMPILATION=true
            RUN_SIMULATION=true
            RUN_TESTBENCH_BASICS=true
            RUN_FILE_IO=true
            RUN_WAVEFORMS=true
            RUN_DEBUGGING=true
            shift
            ;;
        --skip-examples)
            RUN_COMPILATION=false
            RUN_SIMULATION=false
            RUN_TESTBENCH_BASICS=false
            RUN_FILE_IO=false
            RUN_WAVEFORMS=false
            RUN_DEBUGGING=false
            shift
            ;;
        --basic-tests)
            RUN_BASIC_TESTS=true
            RUN_FILE_IO_TESTS=false
            shift
            ;;
        --file-io-tests)
            RUN_BASIC_TESTS=false
            RUN_FILE_IO_TESTS=true
            shift
            ;;
        --all-tests)
            RUN_BASIC_TESTS=true
            RUN_FILE_IO_TESTS=true
            shift
            ;;
        --skip-tests)
            RUN_BASIC_TESTS=false
            RUN_FILE_IO_TESTS=false
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
        --check)
            # shellcheck source=lib/media_check.sh
            source "$SCRIPT_DIR/lib/media_check.sh"
            media_module_check "$PROJECT_ROOT" 1
            exit $?
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
    
    print_header "Module 1: iverilog Deep Dive"
    print_status $BLUE "Log file: $LOG_FILE"
    
    # Check prerequisites
    check_prerequisites
    
    local failed=0
    local vcd_file_to_open=""
    
    # Run examples
    if [[ "$RUN_COMPILATION" == true ]]; then
        run_example_dir "compilation" "Compilation Examples" || failed=$((failed + 1))
    fi
    
    if [[ "$RUN_SIMULATION" == true ]]; then
        run_example_dir "simulation" "Simulation Examples" || failed=$((failed + 1))
    fi
    
    if [[ "$RUN_TESTBENCH_BASICS" == true ]]; then
        run_example_dir "testbench_basics" "Testbench Basics Examples" || failed=$((failed + 1))
        # Track VCD files
        local vcd1="$MODULE1_DIR/examples/testbench_basics/mux_4to1_test.vcd"
        local vcd2="$MODULE1_DIR/examples/testbench_basics/counter_test.vcd"
        if [[ -f "$vcd1" ]]; then
            vcd_file_to_open="$vcd1"
        elif [[ -f "$vcd2" ]]; then
            vcd_file_to_open="$vcd2"
        fi
    fi
    
    if [[ "$RUN_FILE_IO" == true ]]; then
        run_example_dir "file_io" "File I/O Examples" || failed=$((failed + 1))
    fi
    
    if [[ "$RUN_WAVEFORMS" == true ]]; then
        run_example_dir "waveforms" "Waveform Examples" || failed=$((failed + 1))
        local vcd="$MODULE1_DIR/examples/waveforms/waveform_example.vcd"
        if [[ -f "$vcd" ]]; then
            vcd_file_to_open="$vcd"
        fi
    fi
    
    if [[ "$RUN_DEBUGGING" == true ]]; then
        run_example_dir "debugging" "Debugging Examples" || failed=$((failed + 1))
    fi
    
    if [[ "$RUN_ADVANCED" == true ]]; then
        if [[ -d "$MODULE1_DIR/examples/advanced" ]]; then
            run_example_dir "advanced" "Advanced Examples" || failed=$((failed + 1))
        else
            print_status $YELLOW "Advanced examples directory not found (optional)"
        fi
    fi
    
    # Run tests
    if [[ "$RUN_BASIC_TESTS" == true ]]; then
        run_test_dir "basic_tests" "Basic Tests" || failed=$((failed + 1))
        local test_vcd="$MODULE1_DIR/tests/basic_tests/test_mux_4to1.vcd"
        if [[ -f "$test_vcd" ]]; then
            vcd_file_to_open="$test_vcd"
        fi
    fi
    
    if [[ "$RUN_FILE_IO_TESTS" == true ]]; then
        if [[ -d "$MODULE1_DIR/tests/file_io_tests" ]]; then
            run_test_dir "file_io_tests" "File I/O Tests" || failed=$((failed + 1))
        else
            print_status $YELLOW "File I/O tests directory not found (optional)"
        fi
    fi
    
    # Open GTKWave if VCD file was generated
    if [[ -n "$vcd_file_to_open" ]] && [[ -f "$vcd_file_to_open" ]]; then
        if command -v gtkwave &> /dev/null; then
            print_status $BLUE "Opening GTKWave to view waveforms..."
            if [[ -n "${DISPLAY:-}" ]] || [[ "$OSTYPE" == "darwin"* ]]; then
                local gtkw_file="${vcd_file_to_open%.vcd}.gtkw"
                if [[ -f "$gtkw_file" ]]; then
                    gtkwave "$vcd_file_to_open" "$gtkw_file" &
                else
                    gtkwave "$vcd_file_to_open" &
                    print_status $YELLOW "Note: Add signals manually in GTKWave (drag from left panel to right)"
                fi
                print_status $GREEN "✓ GTKWave opened with waveform file: $(basename "$vcd_file_to_open")"
            else
                print_status $YELLOW "No display available. To view waveforms:"
                print_status $YELLOW "  gtkwave $vcd_file_to_open"
            fi
        fi
    fi
    
    # Summary
    echo ""
    print_header "Summary"
    if [[ $failed -eq 0 ]]; then
        print_status $GREEN "✓ All examples and tests completed successfully!"
        echo ""
        print_status $BLUE "Full log saved to: $LOG_FILE"
        
        # Add footer to log file
        {
            echo ""
            echo "=========================================="
            echo "Module 1 Execution Log - Completed"
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
            echo "Module 1 Execution Log - Completed"
            echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Exit code: $failed"
            echo "=========================================="
        } >> "$LOG_FILE"
        
        return 1
    fi
}

# Run main function
main "$@"
