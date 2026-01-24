#!/bin/bash

# Script to demonstrate GTKWave usage with iverilog testbenches
# This script runs a testbench, generates a VCD file, and opens it in GTKWave

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DUT_DIR="$SCRIPT_DIR/../../dut"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}GTKWave Waveform Viewing Example${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if GTKWave is installed
if ! command -v gtkwave &> /dev/null; then
    echo -e "${RED}Error: GTKWave is not installed${NC}"
    echo -e "${YELLOW}Install it with: ./scripts/install_gtkwave.sh${NC}"
    exit 1
fi

# Check if iverilog is installed
if ! command -v iverilog &> /dev/null; then
    echo -e "${RED}Error: iverilog is not installed${NC}"
    echo -e "${YELLOW}Install it with: ./scripts/install_iverilog.sh${NC}"
    exit 1
fi

echo -e "${BLUE}Step 1: Compiling testbench...${NC}"
iverilog -o and_gate_test and_gate_test.v "$DUT_DIR/simple_gates/and_gate.v" || {
    echo -e "${RED}Compilation failed${NC}"
    exit 1
}

echo -e "${BLUE}Step 2: Running simulation to generate VCD file...${NC}"
vvp and_gate_test || {
    echo -e "${RED}Simulation failed${NC}"
    exit 1
}

# Check if VCD file was generated
if [[ ! -f "and_gate_test.vcd" ]]; then
    echo -e "${RED}Error: VCD file not generated${NC}"
    exit 1
fi

echo -e "${GREEN}✓ VCD file generated: and_gate_test.vcd${NC}"
echo ""

# Check if running in a GUI environment
if [[ -z "${DISPLAY:-}" ]] && [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}Warning: No DISPLAY variable set. GTKWave requires a GUI environment.${NC}"
    echo -e "${YELLOW}To view waveforms:${NC}"
    echo -e "${YELLOW}  1. Copy and_gate_test.vcd to a machine with GUI${NC}"
    echo -e "${YELLOW}  2. Run: gtkwave and_gate_test.vcd${NC}"
    echo ""
    echo -e "${BLUE}VCD file is ready for viewing: $(pwd)/and_gate_test.vcd${NC}"
    exit 0
fi

echo -e "${BLUE}Step 3: Opening GTKWave...${NC}"
echo -e "${YELLOW}Note: GTKWave will open in a new window.${NC}"
echo -e "${YELLOW}In GTKWave:${NC}"
echo -e "${YELLOW}  - Expand signals in the left panel${NC}"
echo -e "${YELLOW}  - Drag signals to the waveform viewer${NC}"
echo -e "${YELLOW}  - Use zoom controls to examine timing${NC}"
echo ""

# Open GTKWave (non-blocking)
gtkwave and_gate_test.vcd &

echo -e "${GREEN}✓ GTKWave opened with waveform file${NC}"
echo ""
echo -e "${BLUE}To view waveforms manually, run:${NC}"
echo -e "${BLUE}  gtkwave and_gate_test.vcd${NC}"
