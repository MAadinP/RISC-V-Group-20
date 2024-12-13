# 1. create a list of all .s files
# 2. assemble the individual s files potnetially a for loop
# 3. in each loop in the for loop, assemble the file to create program.hex and then verilator it with a gtest testbench
#!/bin/bash

# Step 1: List all .s files in the current directory
asm_files=$(ls *.s)

# Step 2: Loop through each .s file
for asm_file in $asm_files; do
    # Extract the base name of the file (without extension)
    base_name=$(basename "$asm_file" .s)
    
    echo "Processing $asm_file..."

    ../assemble.sh $basename

    # Translate Verilog -> C++ including testbench
    verilator   -Wall --trace \
                -cc top.sv \
                --exe ${$asm_file + "_tb.cpp"} \
                -y ../../rtl/ \
                --prefix "Vdut" \
                -o Vdut \
                -LDFLAGS "-lgtest -lgtest_main -lpthread" \

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
