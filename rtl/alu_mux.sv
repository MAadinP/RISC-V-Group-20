module alu_mux #(
    parameter DATA_WIDTH = 32
) (
    input  logic [DATA_WIDTH-1:0] data1_in,
    input  logic [DATA_WIDTH-1:0] data2_in,
    input  logic [DATA_WIDTH-1:0] pc_in,
    input  logic [DATA_WIDTH-1:0] imm_in,
    input  logic [1:0]            alu_mux_src,
    output logic [DATA_WIDTH-1:0] alu_op1,
    output logic [DATA_WIDTH-1:0] alu_op2
);

    always_comb begin
        alu_op1 = (alu_mux_src[0] == 1) ? pc_in : data1_in;
        alu_op2 = (alu_mux_src[1] == 1) ? imm_in : data2_in;
    end

endmodule
