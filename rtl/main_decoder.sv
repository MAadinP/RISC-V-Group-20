module main_decoder (
    input   logic [6:0] opcode,
    input   logic [2:0] func3,
    output  logic [1:0] alu_op,
    output  logic [2:0] imm_src,
    output  logic [2:0] branch_src,
    output  logic       mem_write, 
    output  logic [1:0] alu_mux_src,
    output  logic [1:0] wb_src,
    output  logic       reg_write,
    output  logic       branch_valid
);

    logic op1_src, op2_src;

    always_comb begin
        case (opcode)
            7'b0110011: begin // R-Type
                op1_src = 0;
                op2_src = 0;
                alu_mux_src = 2'b00;
                wb_src = 2'b01;
                reg_write = 1; 
                mem_write = 0; 
                alu_op = 2'b10; 
                imm_src = 3'b000;
                branch_src = 3'b010;
                branch_valid = 0;
            end
            7'b0000011: begin // I-Type (Load) - Contains Unnsigned extend
                op1_src = 0;
                op2_src = 1;
                wb_src = 2'b11;
                reg_write = 1; 
                mem_write = 0; 
                alu_op = 2'b00;
                case(func3)
                    3'h3: imm_src = 3'b110;
                    3'h5: imm_src = 3'b101;
                    3'h1: imm_src = 3'b101;
                    default: imm_src = 3'b000; 
                endcase
                branch_src = 3'b010;
                branch_valid = 0;
            end
            7'b0010011: begin // I-Type (ALU) - Contains Unnsigned extend
                op1_src = 0;
                op2_src = 1;
                wb_src = 2'b01;
                reg_write = 1; 
                mem_write = 0; 
                alu_op = 2'b10;
                imm_src = 3'b000;
                branch_src = 3'b010;
                branch_valid = 0;
            end
            7'b0100011: begin // S-Type (Store)
                op1_src = 0;
                op2_src = 1;
                wb_src = 2'b00;
                reg_write = 0; 
                mem_write = 1; 
                alu_op = 2'b00;
                imm_src = 3'b001;
                branch_src = 3'b010;
                branch_valid = 0;
            end
            7'b1100011: begin // B-Type (Branch) - Contains Unnsigned extend
                op1_src = 1;
                op2_src = 1;
                wb_src = 2'b00;
                reg_write = 0; 
                mem_write = 0; 
                alu_op = 2'b01; 
                imm_src = 3'b010;
                case (func3)
                    3'h0: branch_src = 3'b000;
                    3'h1: branch_src = 3'b001;
                    3'h4: branch_src = 3'b100;
                    3'h5: branch_src = 3'b101;
                    3'h6: branch_src = 3'b111;
                    3'h7: branch_src = 3'b110;
                    default: branch_src = 3'b010;
                endcase
                branch_valid = 1;
            end
            7'b1101111: begin // JAL
                op1_src = 1;
                op2_src = 1;
                wb_src = 2'b00;
                reg_write = 1; 
                mem_write = 0; 
                alu_op = 2'b00; 
                imm_src = 3'b100;
                branch_src = 3'b011;
                branch_valid = 0;
            end
            7'b1100111: begin // JALR
                op1_src = 0;
                op2_src = 1;
                wb_src = 2'b00;
                reg_write = 1; 
                mem_write = 0; 
                alu_op = 2'b00; 
                imm_src = 3'b100;
                branch_src = 3'b011;
                branch_valid = 0;
            end
            7'b0110111: begin // U-Type (LUI)
                op1_src = 0;
                op2_src = 0;
                wb_src = 2'b10;
                reg_write = 1; 
                mem_write = 0; 
                alu_op = 2'b00; 
                imm_src = 3'b011;
                branch_src = 3'b010;
                branch_valid = 0;
            end
            7'b0010111: begin // U-Type (AUIPC)
                op1_src = 1;
                op2_src = 1;
                wb_src = 2'b01;
                reg_write = 1; 
                mem_write = 0; 
                alu_op = 2'b00; 
                imm_src = 3'b011;
                branch_src = 3'b010;
                branch_valid = 0;
            end
            default: begin
                op1_src = 0;
                op2_src = 0;
                wb_src = 2'b00;
                reg_write = 0; 
                mem_write = 0; 
                alu_op = 2'b01; 
                imm_src = 3'b000;      
                branch_valid = 0;     
            end
        endcase

        alu_mux_src = {op1_src, op2_src};

    end
endmodule
