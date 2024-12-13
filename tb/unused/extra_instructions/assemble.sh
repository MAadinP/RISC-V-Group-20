#!/bin/bash

# Usage: ./assemble.sh <file.s>

# Default vars
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Handle terminal arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: ./assemble.sh <file.s>"
    exit 1
fi

input_file=$1
basename=$(basename "$input_file" | sed 's/\.[^.]*$//')
file_extension="${input_file##*.}"

# Output program.hex file in the current directory (where the script is called from)
output_file="./${basename}.hex"  # Output in the current directory

# Assemble the .s file
riscv64-unknown-elf-as -R -march=rv32im -mabi=ilp32 \
                        -o "${basename}.out" "$input_file"

# Link the object file
riscv64-unknown-elf-ld -melf32lriscv \
                        -e 0xBFC00000 \
                        -Ttext 0xBFC00000 \
                        -o "${basename}.out.reloc" "${basename}.out"

# Extract the binary section
riscv64-unknown-elf-objcopy -O binary \
                            -j .text "${basename}.out.reloc" "${basename}.bin"

# Generate a disassembly file
riscv64-unknown-elf-objdump -f -d --source -m riscv \
                            "${basename}.out.reloc" > "${basename}.dis"

# Format the binary into a hex file in the current directory
od -v -An -t x1 "${basename}.bin" | tr -s '\n' | awk '{$1=$1};1' > "$output_file"

# Cleanup temporary files
rm "${basename}.out" "${basename}.out.reloc" "${basename}.bin"

echo "Assembled $input_file -> $output_file"
