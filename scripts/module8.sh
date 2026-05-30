#!/bin/bash

# Module 8: Verification Methodology and Best Practices Orchestrator
# This script runs examples and tests for Module 8
# Usage: ./module8.sh [OPTIONS]

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
MODULE8_DIR="$PROJECT_ROOT/module8"

# Options
RUN_TESTBENCH_ARCHITECTURE=true
RUN_CODING_STANDARDS=true
RUN_VERIFICATION_METRICS=true
RUN_TOOL_SELECTION=true
RUN_VERILOG_TESTS=true
RUN_CPP_TESTS=true

# Parallel build jobs
PARALLEL_JOBS=8

# Clean builds by default
CLEAN_BUILDS=true

# Log file setup - will be initialized in main()
LOG_FILE=""

# Function to setup logging (redirects stdout and stderr to both console and log file)
setup_logging() {
    # Initialize log file path
    LOG_FILE="$MODULE8_DIR/module8.log"
    mkdir -p "$MODULE8_DIR"
    
    # Create log file with timestamp header
    {
        echo "=========================================="
        echo "Module 8 Execution Log"
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

Module 8: Verification Methodology and Best Practices
This script runs examples and tests for Module 8.
Focuses on methodology, best practices, and real-world verification.

OPTIONS:
    Examples:
        --testbench-architecture   Run modular testbench architecture examples
        --coding-standards          Show coding standards guide
        --verification-metrics      Run verification metrics examples
        --tool-selection             Show tool selection guide
        --all-examples              Run all examples (default)
        --skip-examples             Skip all examples
    
    Tests:
        --verilog-tests             Run Verilog testbenches
        --cpp-tests                 Run C++ testbenches
        --all-tests                 Run all tests (default)
        --skip-tests                Skip all tests
    
    Environment:
        --jobs N                    Number of parallel build jobs (default: 8)
        --no-clean                  Skip cleaning before build (faster rebuilds)
    
    Other:
        --help, -h                  Show this help message

EXAMPLES:
    # Run all examples and tests
    $0
    
    # Run only testbench architecture examples
    $0 --testbench-architecture
    
    # Run only verification metrics examples
    $0 --verification-metrics

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
        print_status $GREEN "Found iverilog: $(iverilog -v 2>&1 | head -1)"
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
    
    # Check C++ compiler
    if ! command -v g++ &> /dev/null && ! command -v clang++ &> /dev/null; then
        print_status $RED "Error: C++ compiler (g++ or clang++) not found."
        missing_tools=$((missing_tools + 1))
    else
        if command -v g++ &> /dev/null; then
            print_status $GREEN "Found g++: $(g++ --version | head -1)"
        else
            print_status $GREEN "Found clang++: $(clang++ --version | head -1)"
        fi
    fi
    
    # Check Make
    if ! command -v make &> /dev/null; then
        print_status $RED "Error: make not found. Please install it first."
        missing_tools=$((missing_tools + 1))
    fi
    
    if [[ $missing_tools -gt 0 ]]; then
        print_status $RED "Please install missing tools before running Module 8 examples."
        exit 1
    fi
    
    print_status $GREEN "Prerequisites check passed"
}

# Function to run example directory
run_example_dir() {
    local example_dir=$1
    local example_name=$2
    
    print_header "Running: $example_name"
    
    cd "$MODULE8_DIR/examples/$example_dir" || {
        print_status $RED "Error: Failed to change to example directory: $example_dir"
        return 1
    }
    
    # Check if it's a markdown file (guide)
    local md_files=$(find . -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l)
    if [[ $md_files -gt 0 ]] && [[ ! -f Makefile ]]; then
        print_status $BLUE "This is a documentation guide. Displaying..."
        for md_file in *.md; do
            if [[ -f "$md_file" ]]; then
                print_status $BLUE "Guide: $md_file"
                if command -v less &> /dev/null; then
                    less "$md_file" || cat "$md_file"
                else
                    cat "$md_file"
                fi
            fi
        done
        cd "$PROJECT_ROOT"
        return 0
    fi
    
    # Check if Makefile exists
    if [[ ! -f Makefile ]]; then
        print_status $YELLOW "No Makefile found in $example_dir (skipping)"
        cd "$PROJECT_ROOT"
        return 0
    fi
    
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
        print_status $YELLOW "Check $MODULE8_DIR/examples/$example_dir/run.log for details"
        return 1
    fi
}

# Function to run test directory
run_test_dir() {
    local test_dir=$1
    local test_name=$2
    
    print_header "Running: $test_name"
    
    cd "$MODULE8_DIR/tests/$test_dir" || {
        print_status $RED "Error: Failed to change to test directory: $test_dir"
        return 1
    }
    
    # Check if Makefile exists
    if [[ ! -f Makefile ]]; then
        print_status $YELLOW "No Makefile found in $test_dir (skipping)"
        cd "$PROJECT_ROOT"
        return 0
    fi
    
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
        print_status $YELLOW "Check $MODULE8_DIR/tests/$test_dir/test.log for details"
        return 1
    fi
}

# Parse command line arguments (before logging setup)
parse_args() {
while [[ $# -gt 0 ]]; do
    case $1 in
        --testbench-architecture)
            RUN_TESTBENCH_ARCHITECTURE=true
            RUN_CODING_STANDARDS=false
            RUN_VERIFICATION_METRICS=false
            RUN_TOOL_SELECTION=false
            shift
            ;;
        --coding-standards)
            RUN_TESTBENCH_ARCHITECTURE=false
            RUN_CODING_STANDARDS=true
            RUN_VERIFICATION_METRICS=false
            RUN_TOOL_SELECTION=false
            shift
            ;;
        --verification-metrics)
            RUN_TESTBENCH_ARCHITECTURE=false
            RUN_CODING_STANDARDS=false
            RUN_VERIFICATION_METRICS=true
            RUN_TOOL_SELECTION=false
            shift
            ;;
        --tool-selection)
            RUN_TESTBENCH_ARCHITECTURE=false
            RUN_CODING_STANDARDS=false
            RUN_VERIFICATION_METRICS=false
            RUN_TOOL_SELECTION=true
            shift
            ;;
        --all-examples)
            RUN_TESTBENCH_ARCHITECTURE=true
            RUN_CODING_STANDARDS=true
            RUN_VERIFICATION_METRICS=true
            RUN_TOOL_SELECTION=true
            shift
            ;;
        --skip-examples)
            RUN_TESTBENCH_ARCHITECTURE=false
            RUN_CODING_STANDARDS=false
            RUN_VERIFICATION_METRICS=false
            RUN_TOOL_SELECTION=false
            shift
            ;;
        --verilog-tests)
            RUN_VERILOG_TESTS=true
            RUN_CPP_TESTS=false
            shift
            ;;
        --cpp-tests)
            RUN_VERILOG_TESTS=false
            RUN_CPP_TESTS=true
            shift
            ;;
        --all-tests)
            RUN_VERILOG_TESTS=true
            RUN_CPP_TESTS=true
            shift
            ;;
        --skip-tests)
            RUN_VERILOG_TESTS=false
            RUN_CPP_TESTS=false
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
            media_module_check "$PROJECT_ROOT" 8
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
    
    print_header "Module 8: Verification Methodology and Best Practices"
    print_status $BLUE "Log file: $LOG_FILE"
    
    # Check prerequisites
    check_prerequisites
    
    local failed=0
    local vcd_file_to_open=""
    
    # Run examples
    if [[ "$RUN_TESTBENCH_ARCHITECTURE" == true ]]; then
        run_example_dir "testbench_architecture" "Modular Testbench Architecture Examples" || failed=$((failed + 1))
        local vcd="$MODULE8_DIR/examples/testbench_architecture/modular_testbench.vcd"
        if [[ -f "$vcd" ]] && [[ -z "$vcd_file_to_open" ]]; then
            vcd_file_to_open="$vcd"
        fi
    fi
    
    if [[ "$RUN_CODING_STANDARDS" == true ]]; then
        run_example_dir "coding_standards" "Coding Standards Guide" || failed=$((failed + 1))
    fi
    
    if [[ "$RUN_VERIFICATION_METRICS" == true ]]; then
        run_example_dir "verification_metrics" "Verification Metrics Examples" || failed=$((failed + 1))
    fi
    
    if [[ "$RUN_TOOL_SELECTION" == true ]]; then
        run_example_dir "tool_selection" "Tool Selection Guide" || failed=$((failed + 1))
    fi
    
    # Run tests
    if [[ "$RUN_VERILOG_TESTS" == true ]]; then
        if [[ -d "$MODULE8_DIR/tests/verilog_tests" ]]; then
            run_test_dir "verilog_tests" "Verilog Tests" || failed=$((failed + 1))
        else
            print_status $YELLOW "Verilog tests directory not found (optional)"
        fi
    fi
    
    if [[ "$RUN_CPP_TESTS" == true ]]; then
        if [[ -d "$MODULE8_DIR/tests/cpp_tests" ]]; then
            run_test_dir "cpp_tests" "C++ Tests" || failed=$((failed + 1))
        else
            print_status $YELLOW "C++ tests directory not found (optional)"
        fi
    fi
    
    # Open GTKWave if VCD file was generated
    if [[ -n "$vcd_file_to_open" ]] && [[ -f "$vcd_file_to_open" ]]; then
        if command -v gtkwave &> /dev/null; then
            print_status $BLUE "Opening GTKWave to view waveforms..."
            if [[ -n "${DISPLAY:-}" ]] || [[ "$OSTYPE" == "darwin"* ]]; then
                gtkwave "$vcd_file_to_open" &
                print_status $YELLOW "Note: Add signals manually in GTKWave (drag from left panel to right)"
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
        print_status $GREEN "Congratulations on completing Module 8!"
        print_status $GREEN "You've mastered verification methodology and best practices!"
        echo ""
        print_status $BLUE "Full log saved to: $LOG_FILE"
        
        # Add footer to log file
        {
            echo ""
            echo "=========================================="
            echo "Module 8 Execution Log - Completed"
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
            echo "Module 8 Execution Log - Completed"
            echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Exit code: $failed"
            echo "=========================================="
        } >> "$LOG_FILE"
        
        return 1
    fi
}

# Run main function
main "$@"
