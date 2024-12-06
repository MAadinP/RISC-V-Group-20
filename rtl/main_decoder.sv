module main_decoder (
    input  logic [6:0] opcode,              
    output logic [2:0] imm_sel,             
    output logic       op1sel,              
    output logic       op2sel,              
    output logic [3:0] read_write,          
    output logic [2:0] branch_jump,         
    output logic       reg_write_en         
);

    always_comb begin
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
                op1sel = 0;       
                op2sel = 0;       
            end
            7'b0000011: begin // I-Type (Load)
                reg_write_en = 1;
                imm_sel = 3'b000; 
                op1sel = 0;       
                op2sel = 1;
                read_write = 4'b0001; 
            end
            7'b0010011: begin // I-Type (ALU)
                reg_write_en = 1;
                imm_sel = 3'b000;
                op1sel = 0;       
                op2sel = 1;       
            end
            7'b0100011: begin // S-Type (Store)
                imm_sel = 3'b001; 
                op1sel = 0;       
                op2sel = 1;       
                read_write = 4'b0010; 
            end
            7'b1100011: begin // B-Type (Branch)
                imm_sel = 3'b010; 
                branch_jump = 3'b001; 
            end
            7'b1101111: begin // J-Type (Jump)
                reg_write_en = 1;
                imm_sel = 3'b011; 
                branch_jump = 3'b010; 
            end
        endcase
    end
endmodule
