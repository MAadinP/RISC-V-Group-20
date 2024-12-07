module sign_extend #(
    parameter DATA_WIDTH = 32,
    parameter INSTR_WIDTH = 32,
    parameter IMMSRC_WIDTH = 3
) (
    input   logic [IMMSRC_WIDTH-1:0]    imm_src,     
    input   logic [INSTR_WIDTH-1:7]     instr_imm,
    output  logic [DATA_WIDTH-1:0]      imm_extend
);

    always_comb begin
        case (imm_src)
            2'b000: imm_extend = {{20{instr_imm[31]}}, instr_imm[31:20]};                                           // 000 -> I (signed)
            2'b001: imm_extend = {{20{instr_imm[31]}}, instr_imm[31:25], instr_imm[11:7]};                          // 001 -> S
            2'b010: imm_extend = {{20{instr_imm[31]}}, instr_imm[7], instr_imm[30:25], instr_imm[11:8], 1'b0};      // 010 -> B
            2'b011: imm_extend = {{instr_imm[31:12]}, 12'd0};                                                       // 011 -> U 
            2'b100: imm_extend = {{12{instr_imm[31]}}, instr_imm[19:12], instr_imm[20], instr_imm[30:21], 1'b0};    // 100 -> J
            2'b101: imm_extend = {27{instr_imm[24]}, instr_imm[24:20]};                                             // 101 -> I (immediate val)
            2'b110: imm_extend = {12'b0, instr_imm[31:20]};                                                         // 110 -> I (unsigned)
            default: imm_extend = 32'b0;
        endcase
    end
    
endmodule
