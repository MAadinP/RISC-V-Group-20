module alu_decoder #(
    parameter FUNC3_WIDTH = 3,
    parameter ALUOP_WIDTH = 2,
    parameter ALUCTR_WIDTH = 5
) (
    input   logic [FUNC3_WIDTH-1:0]     func3,
    input   logic [ALUOP_WIDTH-1:0]     alu_op,
    input   logic [1:0]                 func7_5_0,  // 5th and 0th bits of funct7
    output  logic [ALUCTR_WIDTH-1:0]    alu_src
);

    logic is_multiplication;
    assign is_multiplication = (func7_5_0 == 2'b01);

    always_comb begin

        case (alu_op)
            2'b00: alu_src = 5'b00000;                                     // LW SW B-TYPE (ADD)
            2'b01: alu_src = 5'b00001;                                     
            2'b10: begin
                case (func3)
                    3'b000: begin
                        if (func7_5_0 == 2'b00) begin                       // ADD
                            alu_src = 5'b00000;
                        end else if (func7_5_0 == 2'b1x) begin              // SUB
                            alu_src = 5'b00001;
                        end else if (is_multiplication) begin               // MUL
                            alu_src = 5'b01010;
                        end else begin
                            alu_src = 5'b00000;                                    // DEFAULT
                        end
                    end
                    3'b001: alu_src = (is_multiplication) ? 5'b01011 : 5'b00010;   // MULH | SLL 
                    3'b010: alu_src = (is_multiplication) ? 5'b01100 : 5'b00011;   // MULHSU | SLT                                      
                    3'b011: alu_src = (is_multiplication) ? 5'b01101 : 5'b00100;   // MULHU | SLTU
                    3'b100: alu_src = (is_multiplication) ? 5'b01110 : 5'b00101;   // DIV | XOR
                    3'b101: begin
                        if (func7_5_0 == 2'b00) begin                               // SRL
                            alu_src = 5'b00110;
                        end else if (func7_5_0 == 2'b1x) begin                      // SRA
                            alu_src = 5'b00111;    
                        end else if (is_multiplication) begin                       // DIVU
                            alu_src = 5'b01111;
                        end else begin
                            alu_src = 5'b00110;                                    // DEFAULT
                        end
                    end
                    3'b110: alu_src = (is_multiplication) ? 5'b10000 : 5'b01000;   // REM | OR
                    3'b111: alu_src = (is_multiplication) ? 5'b10001 : 5'b01001;   // REMU | AND
                    default: alu_src = 5'b00000;                             
                endcase
            end
            2'b11: begin
                case(func3)
                    3'b000: alu_src = 5'b00000; // ADDI
                    3'b100: alu_src = 5'b00101; // XORI
                    3'b110: alu_src = 5'b01000; // ORI
                    3'b111: alu_src = 5'b01001; // ANDI
                    3'b001: alu_src = 5'b00010; // SLLI
                    3'b101: begin                                                   
                        case(func7_5_0)
                            2'b00: alu_src =  5'b00110;     // SRLI
                            2'b10: alu_src = 5'b00111;      // SRAI
                            default: alu_src =  5'b00110;   // DEFAULT = SRLI
                        endcase
                    end
                    3'b010: alu_src = 5'b00011;         // SLTI
                    3'b011: alu_src = 5'b00100;         // SLTIU
                endcase
            end
            default: alu_src = 5'b00000;                                     
        endcase
    end

endmodule