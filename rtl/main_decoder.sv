module main_decoder (
    input  logic [6:0] opcode,              // Opcode from instruction
    output logic [2:0] imm_sel,             // Immediate selection
    output logic       op1sel,              // Operand 1 source
    output logic       op2sel,              // Operand 2 source
    output logic [3:0] read_write,          // Memory operation
    output logic [2:0] branch_jump,         // Branch or jump control
    output logic       reg_write_en         // Register write enable
);

    always_comb begin
        // Default control signals
        imm_sel = 3'b000;
        op1sel = 0;
        op2sel = 0;
        read_write = 4'b0000;
        branch_jump = 3'b000;
        reg_write_en = 0;

        // Opcode-based control signal generation
        case (opcode)
            7'b0110011: begin // R-Type
                reg_write_en = 1; // Enable write-back
                op1sel = 0;       // Use register as source for op1
                op2sel = 0;       // Use register as source for op2
            end
            7'b0000011: begin // I-Type (Load)
                reg_write_en = 1;
                imm_sel = 3'b000; // Immediate for load
                op1sel = 0;       // Use register for op1
                op2sel = 1;       // Use immediate for op2
                read_write = 4'b0001; // Memory read
            end
            7'b0010011: begin // I-Type (ALU)
                reg_write_en = 1;
                imm_sel = 3'b000; // Immediate for ALU
                op1sel = 0;       // Use register for op1
                op2sel = 1;       // Use immediate for op2
            end
            7'b0100011: begin // S-Type (Store)
                imm_sel = 3'b001; // Immediate for store
                op1sel = 0;       // Use register for op1
                op2sel = 1;       // Use immediate for op2
                read_write = 4'b0010; // Memory write
            end
            7'b1100011: begin // B-Type (Branch)
                imm_sel = 3'b010; // Immediate for branch
                branch_jump = 3'b001; // Enable branch
            end
            7'b1101111: begin // J-Type (Jump)
                reg_write_en = 1;
                imm_sel = 3'b011; // Immediate for jump
                branch_jump = 3'b010; // Enable jump
            end
        endcase
    end
endmodule
