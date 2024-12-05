module main_decoder #(
    input   logic [6:0]  opcode,
    output  logic [1:0]  alu_op,
    output  logic [2:0]  imm_src,
    output  logic        mem_read, 
    output  logic        mem_write, 
    output  logic        branch_ctr,
    output  logic        op1_src,
    output  logic        op2_src,
    output  logic        wb_sel,
    output  logic        reg_write
);

    always_comb begin
        
        alu_op
imm_src
mem_read
mem_write
branch_ctr
op1_src
op2_src
wb_sel
reg_write

        case (opcode)
            7'b0110011: begin // R-Type
                reg_write = 1; 
                alu_op = 2'b10; // Multiplication support included here
            end
            7'b0000011: begin // I-Type (Load)
                reg_write = 1; 
                mem_read = 1; 
                alu_op = 2'b00; 
                imm_src = 3'b000;
            end
            7'b0010011: begin // I-Type (ALU)
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
                branch_ctr = 1; 
                alu_op = 2'b01; 
                PCSrc = 2'b01;
                imm_src = 3'b010;
            end
            7'b1101111: begin // J-Type (Jump)
                reg_write = 1; 
                PCSrc = 2'b10; 
                imm_src = 3'b011;
            end
            default: begin
                reg_write = 0; 
                mem_read = 0; 
                mem_write = 0; 
                branch_ctr = 0;
                alu_op = 2'b00; 
                imm_src = 3'b000;                
            end
        endcase
    end
endmodule
