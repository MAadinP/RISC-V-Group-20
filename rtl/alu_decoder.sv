module alu_decoder (
    input  logic [1:0] ALU_op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [3:0] ALU_Ctrl
);

    always_comb begin
        // Default ALUCtrl
        ALU_ctrl = 4'b0000;

        case (ALU_op)
            3'b000: ALU_ctrl = 4'b0010; // ADD
            3'b001: ALU_ctrl = 4'b0110; // SUB
            3'b010: begin
                case (funct3)
                    3'b000: ALU_ctrl = (funct7 == 7'b0100000) ? 4'b0110 : 4'b0010; // SUB/ADD
                    3'b111: ALU_ctrl = 4'b0000; // AND
                    3'b110: ALU_ctrl = 4'b0001; // OR
                    3'b100: ALU_ctrl = 4'b0011; // XOR
                    3'b010: ALU_ctrl = 4'b0111; // SLT
                    3'b001: ALU_ctrl = 4'b1000; // SLL
                    3'b101: ALU_ctrl = (funct7 == 7'b0100000) ? 4'b1010 : 4'b1001; // SRA/SRL
                endcase
            end
        endcase
    end
endmodule
