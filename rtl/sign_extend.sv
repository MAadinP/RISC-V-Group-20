module sign_extend # (
    parameter DATA_WIDTH = 32
)(
    input   logic [DATA_WIDTH-1:0]  instr,
    input   logic [2:0]             imm_sel,
    output  logic [DATA_WIDTH-1:0]  imm_ext   
);

    always_comb begin
        case (imm_sel)
            3'b000: imm_ext = {{21{instr[31]}}, instr[30:20]}; // I-type
            3'b001: imm_ext = {{21{instr[31]}}, instr[30:25], instr[11:7]}; // S-type
            3'b010: imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            3'b011: imm_ext = {instr[31:12], 12'h000}; // U-type
            3'b100: imm_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0}; // J-type
            default: imm_ext = '0; // Default case to zero
        endcase 
    end

endmodule
