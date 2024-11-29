module ID_EX #(
    parameter DATA_LENGTH = 32,
    parameter PC_WIDTH = 32
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic [DATA_LENGTH-1:0]  rd1_in,
    input  logic [DATA_LENGTH-1:0]  rd2_in,
    input  logic [PC_WIDTH-1:0]     pc_in,
    input  logic [4:0]              rd_in,
    input  logic [DATA_LENGTH-1:0]  imm_ext_in,
    input  logic [PC_WIDTH-1:0]     pc_plus4_in,
    output logic [DATA_LENGTH-1:0]  rd1_out,
    output logic [DATA_LENGTH-1:0]  rd2_out,
    output logic [PC_WIDTH-1:0]     pc_out,
    output logic [4:0]              rd_out,
    output logic [PC_WIDTH-1:0]     pc_plus4_out
);

always_ff @(posedge clk or negedge rst) begin
    rd1_out_out <= (!rst) ? '0 : rd1_in;
    rd2_out <= (!rst) ? '0 : rd2_in;
    pc_out <= (!rst) ? '0 : pc_in;
    rd_out <= (!rst) ? '0 : rd_in;
    pc_plus4_out <= (!rst) ? '0 : pc_plus4_in;
end

endmodule
