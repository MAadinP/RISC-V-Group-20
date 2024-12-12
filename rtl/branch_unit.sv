module branch_unit #(
    parameter DATA_WIDTH = 32
) (
    input   logic [DATA_WIDTH-1:0]  rs1,
    input   logic [DATA_WIDTH-1:0]  rs2,
    input   logic [2:0]             branch_sel,
    output  logic                   branch_taken
);

    always_comb begin
        case(branch_sel)
            3'b000: branch_taken = 1'b0; //no jump
            3'b001: branch_taken = 1'b1; //jump
            3'b010: branch_taken = (rs1 == rs2); //BEQ
            3'b011: branch_taken = (rs1 != rs2); //BNEQ
            3'b100: branch_taken = ($signed(rs1) < $signed(rs2)); //BLT
            3'b101: branch_taken = ($signed(rs1) >= $signed(rs2)); //BGE
            3'b110: branch_taken = (rs1 < rs2); //BLTU
            3'b111: branch_taken = (rs1 >= rs2); //BGEU
            default: branch_taken = 1'b0;
        endcase
    end
endmodule
