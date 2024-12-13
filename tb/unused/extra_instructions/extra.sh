#!/bin/bash

# Step 1: List all .s files in the current directory
asm_files=$(ls *.s)

# Step 2: Loop through each .s file
for asm_file in $asm_files; do
    # Extract the base name of the file (without extension)
    base_name=$(basename "$asm_file" .s)
    
    echo "Processing $asm_file..."

    # Assemble the .s file
    ./assemble.sh "$asm_file"
    
    # Check if the hex file exists after assembly
    if [[ -f "${base_name}.hex" ]]; then
        # Copy the hex file to program.hex
        cp "${base_name}.hex" "program.hex"
        echo "Hex file copied to program.hex."
    else
        echo "Error: ${base_name}.hex not found!"
        exit 1
    fi

    # Translate Verilog -> C++ including testbench
    verilator   -Wall --trace \
                -cc top.sv \
                --exe "${base_name}_tb.cpp" \
                -y ../../rtl/ \
                --prefix "Vdut" \
                -o Vdut \
                -LDFLAGS "-lgtest -lgtest_main -lpthread"

    # Build C++ project with automatically generated Makefile
    make -j -C obj_dir/ -f Vdut.mk
    
    # Run executable simulation file
    ./obj_dir/Vdut
    # Check the result
    if [[ $? -eq 0 ]]; then
        echo "Test for $asm_file PASSED."
    else
        echo "Test for $asm_file FAILED."
        exit 1
    fi

    echo ""
done

echo "All tests completed."
