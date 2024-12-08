module alu #(
    parameter ALUSRC_WIDTH = 5,
    parameter DATA_WIDTH = 32
) (
    input   logic [ALUSRC_WIDTH-1:0]    alu_src,
    input   logic [DATA_WIDTH-1:0]      alu_op1,
    input   logic [DATA_WIDTH-1:0]      alu_op2,
    output  logic [DATA_WIDTH-1:0]      alu_out
);

    // Temporary variable to hold multiplication results
    logic [63:0] mul_result;

    always_comb begin
        
        mul_result = 64'b0;
        alu_out = {DATA_WIDTH{1'b0}};

        case (alu_src)
            5'b00000: alu_out = alu_op1 + alu_op2;                                                  // ADD
            5'b00001: alu_out = alu_op1 - alu_op2;                                                  // SUB
            5'b00010: alu_out = alu_op1 << alu_op2;                                                 // SLL
            5'b00011: alu_out = ($signed(alu_op1) < $signed(alu_op2)) ? 32'b1 : 32'b0;              // SLT
            5'b00100: alu_out = (alu_op1 < alu_op2) ? 32'b1 : 32'b0;                                // SLTU
            5'b00101: alu_out = alu_op1 ^ alu_op2;                                                  // XOR
            5'b00110: alu_out = alu_op1 >> alu_op2;                                                 // SRL
            5'b00111: alu_out = $signed(alu_op1) >>> alu_op2;                                       // SRA
            5'b01000: alu_out = alu_op1 | alu_op2;                                                  // OR
            5'b01001: alu_out = alu_op1 & alu_op2;                                                  // AND
            5'b01010: begin
                mul_result = $signed(alu_op1) * $signed(alu_op2); 
                alu_out = mul_result[31:0];                                                         // MUL
            end
            5'b01011: begin
                mul_result = $signed(alu_op1) * $signed(alu_op2);
                alu_out = mul_result[63:32];                                                        // MULH
            end
            5'b01100: begin
                mul_result = $signed(alu_op1) * alu_op2;
                alu_out = mul_result[63:32];                                                        // MULHSU
            end
            5'b01101: begin
                mul_result = alu_op1 * alu_op2;
                alu_out = mul_result[63:32];                                                        // MULHU
            end
            5'b01110: alu_out = (alu_op2 == 0) ? -1 : ($signed(alu_op1) / $signed(alu_op2));        // DIV
            5'b01111: alu_out = (alu_op2 == 0) ? -1 : (alu_op1 / alu_op2);                          // DIVU
            5'b10000: alu_out = (alu_op2 == 0) ? alu_op1 : ($signed(alu_op1) % $signed(alu_op2));   // REM
            5'b10001: alu_out = (alu_op2 == 0) ? alu_op1 : (alu_op1 % alu_op2);                     // REMU
            default: alu_out = {DATA_WIDTH{1'b0}};
        endcase
    end
    
endmodule
