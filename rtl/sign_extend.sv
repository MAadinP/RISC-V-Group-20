module sign_extend #(
    parameter DATA_WIDTH = 32,
    parameter IMMSRC_WIDTH = 3
) (
    input   logic [IMMSRC_WIDTH-1:0]    imm_src,     
    input   logic [24:0]                instr_imm,
    output  logic [DATA_WIDTH-1:0]      imm_extend
);

    always_comb begin
        case (imm_src)
            3'b000: imm_extend = {{20{instr_imm[24]}}, instr_imm[24:13]};                                       // 000 -> I (signed)
            3'b001: imm_extend = {{21{instr_imm[24]}}, instr_imm[23:18], instr_imm[4:0]};                       // 001 -> S
            3'b010: imm_extend = {{20{instr_imm[24]}}, instr_imm[0], instr_imm[23:18], instr_imm[4:1], 1'b0};   // 010 -> B
            3'b011: imm_extend = {{instr_imm[24:5]}, 12'd0};                                                    // 011 -> U 
            3'b100: imm_extend = {{12{instr_imm[24]}}, instr_imm[12:5], instr_imm[13], instr_imm[23:14], 1'b0}; // 100 -> J
            3'b101: imm_extend = {{27{instr_imm[17]}}, instr_imm[17:13]};                                       // 101 -> I (immediate val)
            3'b110: imm_extend = {20'b0, instr_imm[24:13]};                                                     // 110 -> I (unsigned)
            default: imm_extend = 32'b0;
        endcase
    end
    
endmodule
