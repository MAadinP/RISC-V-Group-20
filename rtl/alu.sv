module alu #(
    parameter DATA_WIDTH = 32
) (
    input   logic [DATA_WIDTH-1:0]  alu_op1,
    input   logic [DATA_WIDTH-1:0]  alu_op2,
    input   logic [4:0]             alu_src,
    output  logic [DATA_WIDTH-1:0]  alu_out
);

    // Temporary variable to hold multiplication results
    logic [63:0] mul_result;
    
    always_comb begin
        case(alu_src)
            5'b00000: alu_out = alu_op1 + alu_op2;                                                      // ADD
            5'b00001: alu_out = alu_op1 - alu_op2;                                                      // SUB
            5'b00010: alu_out = alu_op1 << alu_op2[4:0];                                                // SLL
            5'b00011: alu_out = ($signed(alu_op1) < $signed(alu_op2)) ? 32'd1 : 32'd0;                    // SLT
            5'b00100: alu_out = (alu_op1 < alu_op2) ? 32'd1 : 32'd0;                                      // SLTU
            5'b00101: alu_out = alu_op1 ^ alu_op2;                                                      // XOR
            5'b00110: alu_out = alu_op1 >> alu_op2[4:0];                                                // SRL
            5'b00111: alu_out = $signed(alu_op1) >>> alu_op2[4:0];                                      // SRA
            5'b01000: alu_out = alu_op1 | alu_op2;                                                      // OR
            5'b01001: alu_out = alu_op1 & alu_op2;                                                      // AND
            // 5'b01010: alu_out = ($signed(alu_op1) * $signed(alu_op2))[31:0];                            // MUL
            // 5'b01011: alu_out = ($signed(alu_op1) * $signed(alu_op2))[63:32];                           // MULH
            // 5'b01100: alu_out = ($signed(alu_op1) * $signed({1'b0,alu_op2}))[63:32];                    // MULHSU
            // //MULHSU needs to be tested to make sure it doesn't just perform unsigned multiplication
            // 5'b01101: alu_out = (alu_op1 * alu_op2)[63:32];                                             // MULHU
            5'b01010: begin
                mul_result = $signed(alu_op1) * $signed(alu_op2); 
                alu_out = mul_result[31:0];                                                         // MUL
            end
            5'b01011: begin
                mul_result = $signed(alu_op1) * $signed(alu_op2);
                alu_out = mul_result[63:32];                                                        // MULH
            end
            5'b01100: begin
                mul_result = $signed(alu_op1) * $unsigned(alu_op2);
                alu_out = mul_result[63:32];                                                        // MULHSU
            end
            5'b01101: begin
                mul_result = alu_op1 * alu_op2;
                alu_out = mul_result[63:32];                                                        // MULHU
            end
            5'b01110: begin                                                                             // DIV
                if(alu_op2 == 0) begin
                    alu_out = 32'hFFFFFFFF;
                end
                else if ((alu_op2 == 32'hFFFFFFFF) && (alu_op1 == 32'h10000000))begin
                    alu_out = alu_op1;
                end
                else begin
                    alu_out = $signed(alu_op1) / $signed(alu_op2);   
                end
            end                            
            5'b01111: alu_out = (alu_op2 == 0) ? 32'hFFFFFFFF : (alu_op1 / alu_op2);                    // DIVU
            5'b10000: begin                                                                             // REM
                if(alu_op2 == 0) begin
                    alu_out = alu_op1;
                end
                else if ((alu_op2 == 32'hFFFFFFFF) && (alu_op1 == 32'h10000000))begin
                    alu_out = '0;
                end
                else begin
                    alu_out = $signed(alu_op1) % $signed(alu_op2);   
                end
            end 
            5'b10001: alu_out = (alu_op2 == 0) ? alu_op1 : (alu_op1 % alu_op2);                          // REMU
            default: alu_out = {DATA_WIDTH{1'b0}};
        endcase
    end
endmodule
