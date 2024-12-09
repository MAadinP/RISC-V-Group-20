module IF_ID #(
    parameter DATA_LENGTH = 32,
    parameter PC_WIDTH = 32
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    en,
    input  logic [DATA_LENGTH-1:0]  ins_in,
    input  logic [PC_WIDTH-1:0]     pc_in,
    input  logic [PC_WIDTH-1:0]     pc_plus4_in,
    output logic [DATA_LENGTH-1:0]  ins_out,
    output logic [PC_WIDTH-1:0]     pc_out,
    output logic [PC_WIDTH-1:0]     pc_plus4_out
);

always_ff @(posedge clk) begin
    if (en) begin
        ins_out <= (!rst) ? '0' : ins_in;
        pc_out <= (!rst) ? '0' : pc_in;
        pc_plus4_out <= (!rst) ? '0 : pc_plus4_in;
    end else begin
        ins_out <= (!rst) ? '0' : ins_out;
        pc_out <= (!rst) ? '0' : pc_out;
        pc_plus4_out <= (!rst) ? '0 : pc_plus4_out;
    end
end

endmodule
