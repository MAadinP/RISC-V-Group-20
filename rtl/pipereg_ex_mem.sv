module EX_MEM #(
    parameter DATA_WIDTH = 32,
    parameter PC_WIDTH = 32,
    parameter REG_WIDTH = 5
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic [DATA_WIDTH-1:0]   alu_res_in,
    input  logic [DATA_WIDTH-1:0]   w_data_in,
    input  logic [REG_WIDTH-1:0]    rd_in,
    input  logic [PC_WIDTH-1:0]     pc_plus4_in,
    output logic [DATA_WIDTH-1:0]   alu_res_out,
    output logic [DATA_WIDTH-1:0]   w_data_out,
    output logic [REG_WIDTH-1:0]    rd_out,
    output logic [PC_WIDTH-1:0]     pc_plus4_out

    // Control Unit Signals
    input  logic                    reg_write_in,
    input  logic [1:0]              result_src_in,
    input  logic                    mem_write_in,

    output logic                    reg_write_out,
    output logic [1:0]              result_src_out,
    output logic                    mem_write_out,
);

always_ff @(posedge clk) begin
    alu_res_out_out <= (!rst) ? '0 : alu_res_in;
    w_data_out <= (!rst) ? '0 : w_data_in;
    rd_out <= (!rst) ? '0 : rd_in;
    pc_plus4_out <= (!rst) ? '0 : pc_plus4_in;

    // Control Unit Signals
    reg_write_out <= (!rst) ? '0 : reg_write_in;
    result_src_out <= (!rst) ? '0 : result_src_in;
    mem_write_out <= (!rst) ? '0 : mem_write_in;
end

endmodule
