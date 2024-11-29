module IF_ID #(
    parameter DATA_LENGTH = 32,
    parameter PC_WIDTH = 32
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic [DATA_LENGTH-1:0]  ins_in,
    input  logic [PC_WIDTH-1:0]     pc_in,
    input  logic [PC_WIDTH-1:0]     pc_plus4_in,
    output logic [DATA_LENGTH-1:0]  ins_out,
    output logic [PC_WIDTH-1:0]     pc_out,
    output logic [PC_WIDTH-1:0]     pc_plus4_out
);

always_ff @(posedge clk or negedge rst) begin
    ins_out <= (!rst) ? '0' : ins_in;
    pc_out <= (!rst) ? '0' : pc_in;
    pc_plus4_out <= (!rst) ? '0 : pc_plus4_in;
end

endmodule
