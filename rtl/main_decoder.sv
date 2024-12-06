module main_decoder #(
    input  logic [6:0] opcode,
    output logic       reg_write,  
    output logic       mem_write,  
    output logic       branch,     
    output logic [1:0] alu_op,     
    output logic [1:0] pc_src,     
    output logic [2:0] imm_src     
);

    always_comb begin
        // Default control signals (inactive state)
        reg_write = 0; 
        mem_write = 0; 
        branch = 0;
        alu_op = 2'b00; 
        pc_src = 2'b00; 
        imm_src = 3'b000;

        case (opcode)
            7'b0110011: begin // R-Type
                reg_write = 1; 
                alu_op = 2'b10; // ALU performs register-register operations
            end
            7'b0000011: begin // I-Type (Load)
                reg_write = 1; 
                alu_op = 2'b00; 
                imm_src = 3'b000;
            end
            7'b0010011: begin // I-Type (Immediate ALU)
                reg_write = 1;
                alu_op = 2'b10; 
                imm_src = 3'b000;
            end
            7'b0100011: begin // S-Type (Store)
                mem_write = 1; 
                alu_op = 2'b00; 
                imm_src = 3'b001;
            end
            7'b1100011: begin // B-Type (Branch)
                branch = 1; 
                alu_op = 2'b01; 
                pc_src = 2'b01; 
                imm_src = 3'b010;
            end
            7'b1101111: begin // J-Type (Jump)
                reg_write = 1; 
                pc_src = 2'b10; 
                imm_src = 3'b011;
                mem_write = 0;  
                branch = 0;     
            end
        endcase
    end
endmodule
