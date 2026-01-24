#!/bin/bash

# Script to create a GTKWave save file (.gtkw) that pre-loads signals
# This makes waveforms visible immediately when GTKWave opens

VCD_FILE="${1:-gtkwave_example.vcd}"
GTKW_FILE="${VCD_FILE%.vcd}.gtkw"

if [[ ! -f "$VCD_FILE" ]]; then
    echo "Error: VCD file not found: $VCD_FILE"
    exit 1
fi

# Create a basic GTKWave save file
# This file tells GTKWave which signals to display and how
cat > "$GTKW_FILE" << 'EOF'
[*] GTKWave save file
[*] Generated automatically
[*]
[*] Signal hierarchy
[*] Format: [hierarchy] [signal_name] [color] [format]
[*]
[*] Note: This is a basic template. GTKWave will populate it when you:
[*] 1. Open the VCD file
[*] 2. Select signals from the hierarchy
[*] 3. Drag them to the waveform viewer
[*] 4. Save the file (File -> Write Save File)
EOF

echo "Created GTKWave save file template: $GTKW_FILE"
echo "To use:"
echo "  1. Open GTKWave: gtkwave $VCD_FILE"
echo "  2. Expand the hierarchy in the left panel"
echo "  3. Select signals and drag them to the waveform viewer"
echo "  4. Save: File -> Write Save File (saves to $GTKW_FILE)"
echo "  5. Next time: gtkwave $VCD_FILE $GTKW_FILE (loads signals automatically)"
