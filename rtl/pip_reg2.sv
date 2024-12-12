module pip_reg2 #(
    parameter R_ADRESS_WIDTH = 5,
    parameter IMMEDIATE_WIDTH = 32
) (
    input   logic                           clk,
    input   logic                           rst,
    input   logic                           stall,
    input   logic   [IMMEDIATE_WIDTH-1:0]   pc_in,
    input   logic                           lw_in,
    input   logic                           lui_in,
    input   logic   [R_ADRESS_WIDTH-1:0]    rd_in,
    input   logic   [1:0]                   alu_mux1_sel_in,
    input   logic   [1:0]                   alu_mux2_sel_in,
    input   logic   [1:0]                   branch_mux1_sel_in,
    input   logic   [1:0]                   branch_mux2_sel_in,
    input   logic                           exec_mux_in,
    input   logic                           mem_mux_in,
    input   logic   [IMMEDIATE_WIDTH-1:0]   rs1_in,
    input   logic   [IMMEDIATE_WIDTH-1:0]   rs2_in,
    input   logic   [IMMEDIATE_WIDTH-1:0]   immediate_in,
    input   logic   [4:0]                   alu_sel_in,
    input   logic   [2:0]                   branch_sel_in,
    input   logic   [2:0]                   data_mem_write_en_in,
    input   logic                           reg_write_en_in,
    input   logic   [1:0]                   write_back_mux_in,

    output  logic   [IMMEDIATE_WIDTH-1:0]   pc_out,
    output  logic                           lw_out,
    output  logic                           lui_out,
    output  logic   [R_ADRESS_WIDTH-1:0]    rd_out,
    output  logic   [1:0]                   alu_mux1_sel_out,
    output  logic   [1:0]                   alu_mux2_sel_out,
    output  logic   [1:0]                   branch_mux1_sel_out,
    output  logic   [1:0]                   branch_mux2_sel_out,
    output  logic                           exec_mux_out,
    output  logic                           mem_mux_out,
    output  logic   [IMMEDIATE_WIDTH-1:0]   rs1_out,
    output  logic   [IMMEDIATE_WIDTH-1:0]   rs2_out,
    output  logic   [IMMEDIATE_WIDTH-1:0]   immediate_out,
    output  logic   [4:0]                   alu_sel_out,
    output  logic   [2:0]                   branch_sel_out,
    output  logic   [2:0]                   data_mem_write_en_out,
    output  logic                           reg_write_en_out,
    output  logic   [1:0]                   write_back_mux_out
);

    always_ff @(posedge clk) begin
        if(rst || stall) begin
            pc_out <= 32'hBFC00000;
            lw_out <= 1'b0;
            lui_out <= '0;
            rd_out <= 5'b00000;
            alu_mux1_sel_out <= 2'b00;
            alu_mux2_sel_out <= 2'b01;
            branch_mux1_sel_out <= 2'b00;
            branch_mux2_sel_out <= 2'b00;
            exec_mux_out <= 1'b0;
            mem_mux_out <= 1'b0;
            rs1_out <= '0;
            rs2_out <= '0;
            immediate_out <= '0;
            alu_sel_out <= 5'b00000;
            branch_sel_out <= 3'b000;
            data_mem_write_en_out <= 3'b000;
            reg_write_en_out <= 1'b0;
            write_back_mux_out <= 2'b01;
        end
        else begin
            pc_out <= pc_in;
            lw_out <= lw_in;
            lui_out <= lui_in;
            rd_out <= rd_in;
            alu_mux1_sel_out <= alu_mux1_sel_in;
            alu_mux2_sel_out <= alu_mux2_sel_in;
            branch_mux1_sel_out <= branch_mux1_sel_in;
            branch_mux2_sel_out <= branch_mux2_sel_in;
            exec_mux_out <= exec_mux_in;
            mem_mux_out <= mem_mux_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            immediate_out <= immediate_in;
            alu_sel_out <= alu_sel_in;
            branch_sel_out <= branch_sel_in;
            data_mem_write_en_out <= data_mem_write_en_in;
            reg_write_en_out <= reg_write_en_in;
            write_back_mux_out <= write_back_mux_in;
        end
    end

endmodule
