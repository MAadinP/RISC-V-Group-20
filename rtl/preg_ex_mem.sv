module EX_MEM #(
    parameter DATA_LENGTH = 32,
    parameter PC_WIDTH = 32
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic [DATA_LENGTH-1:0]  alu_res_in,
    input  logic [DATA_LENGTH-1:0]  w_data_in,
    input  logic [4:0]              rd_in,
    input  logic [PC_WIDTH-1:0]     pc_plus4_in,
    output logic [DATA_LENGTH-1:0]  alu_res_out,
    output logic [DATA_LENGTH-1:0]  w_data_out,
    output logic [4:0]              rd_out,
    output logic [PC_WIDTH-1:0]     pc_plus4_out
);

always_ff @(posedge clk or negedge rst) begin
    alu_res_out_out <= (!rst) ? '0 : alu_res_in;
    w_data_out <= (!rst) ? '0 : w_data_in;
    rd_out <= (!rst) ? '0 : rd_in;
    pc_plus4_out <= (!rst) ? '0 : pc_plus4_in;
end

endmodule
