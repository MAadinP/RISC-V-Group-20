#!/bin/bash
set -e

# Step 1: Run all CPU tests
echo "Running all CPU tests..."
cd tb/
if ! ./doit.sh; then
    echo "ERROR: CPU tests (doit.sh) failed."
    exit 1
fi
echo "CPU tests completed."

# Step 2: Check if Vbuddy is connected and proceed with Vbuddy-specific tests
VBUDDY_REGEX="[0-9]-[0-9] .* USB-SERIAL CH340"

# Get USB device info using Windows usbipd
USB_INFO=$(powershell.exe /c usbipd list)

if ! echo "$USB_INFO" | grep -q "$VBUDDY_REGEX"; then
    echo "WARNING: Vbuddy not connected. Skipping Vbuddy-specific tests."
else
    echo "Vbuddy detected. Proceeding with Vbuddy-specific tests."

    # Attach Vbuddy if not already attached
    if ! echo "$USB_INFO" | grep -q "$VBUDDY_REGEX .* Attached"; then
        BUS_ID=$(echo "$USB_INFO" | grep "$VBUDDY_REGEX" | awk '{print $1}')
        powershell.exe /c usbipd attach --wsl --busid $BUS_ID
    fi

    echo "Running F1 testbench..."
    
    cd f1_test/
    ./f1.sh
    echo "F1 testbench completed."
fi

# Step 3: Run PDF-related tests with data.hex substitution
cd ../reference
echo "Running PDF-related testbenches..."

DATA_FILES=("noisy.mem" "gaussian.mem" "triangle.mem" "sine.mem")
for DATA_FILE in "${DATA_FILES[@]}"; do
    echo "Processing $DATA_FILE"
    cp "$DATA_FILE" data.hex
    ./reference.sh
    if [ $? -ne 0 ]; then
        echo "ERROR: Verilator command failed for $DATA_FILE"
        exit 1
    fi
    echo "Testbench execution completed for $DATA_FILE"
    rm -f data.hex
done

echo "All tests executed successfully."
