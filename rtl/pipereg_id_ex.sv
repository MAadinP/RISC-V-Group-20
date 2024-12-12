module id_ex #(
    parameter DATA_WIDTH = 32,
    parameter PC_WIDTH = 32,
    parameter REG_WIDTH = 5
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    clr,            // Flush
    input  logic [REG_WIDTH-1:0]    rd1_in,
    input  logic [REG_WIDTH-1:0]    rd2_in,
    input  logic [PC_WIDTH-1:0]     pc_in,
    input  logic [REG_WIDTH-1:0]    rd_in,
    input  logic [DATA_WIDTH-1:0]   imm_ext_in,
    input  logic [PC_WIDTH-1:0]     pc_plus4_in,
    input  logic [DATA_WIDTH-1:0]   read_data1_in,
    input  logic [DATA_WIDTH-1:0]   read_data2_in,
    input  logic [2:0]              func3_in,

    output logic [REG_WIDTH-1:0]    rd1_out,
    output logic [REG_WIDTH-1:0]    rd2_out,
    output logic [PC_WIDTH-1:0]     pc_out,
    output logic [REG_WIDTH:0]      rd_out,
    output logic [PC_WIDTH-1:0]     pc_plus4_out,
    output logic [DATA_WIDTH-1:0]   imm_ext_out
    output logic [DATA_WIDTH-1:0]   read_data1_out,
    output logic [DATA_WIDTH-1:0]   read_data2_out,
    output logic [2:0]              func3_out,

    // Control Unit Signals
    input  logic                    reg_write_in,
    input  logic [1:0]              result_src_in,
    input  logic                    mem_write_in,
    input  logic [4:0]              alu_ctrl_in,
    input  logic [2:0]              branch_jump_in,
    input  logic [1:0]              alu_src_in,
    input  logic                    branch_valid_in,

    output logic                    reg_write_out,
    output logic [1:0]              result_src_out,
    output logic                    mem_write_out,
    output logic [4:0]              alu_ctrl_out,
    output logic [2:0]              branch_jump_out,
    output logic [1:0]              alu_src_out,
    output logic                    branch_valid_out
);

always_ff @(posedge clk) begin
    rd1_out <= (!rst) ? '0 : rd1_in;
    rd2_out <= (!rst) ? '0 : rd2_in;
    pc_out <= (!rst) ? '0 : pc_in;
    rd_out <= (!rst) ? '0 : rd_in;
    pc_plus4_out <= (!rst) ? '0 : pc_plus4_in;

    // Control Unit Signals
    reg_write_out <= (!rst || clr) ? '0 : reg_write_in;
    result_src_out <= (!rst || clr) ? '0 : result_src_in;
    mem_write_out <= (!rst || clr) ? '0 : mem_write_in;
    jump_out <= (!rst || clr) ? '0 : jump_in;
    branch_out <= (!rst || clr) ? '0 : branch_in;
    alu_ctrl_out <= (!rst || clr) ? '0 : alu_ctrl_in;
    alu_src_out <= (!rst || clr) ? '0 : alu_src_in;
    branch_valid_out <= (!rst || clr) ? '0 : branch_valid_in;
end

endmodule
