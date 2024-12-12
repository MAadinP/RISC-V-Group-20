module pip_reg3 #(
    parameter IMMEDIATE_WIDTH = 32,
    parameter ADDRESS_WIDTH = 32,
    parameter R_ADRESS_WIDTH = 5
) (
    input   logic                           clk,
    input   logic                           lui_in,
    input   logic [IMMEDIATE_WIDTH-1:0]     pc_in,
    input   logic [R_ADRESS_WIDTH-1:0]      rd_in,
    input   logic [IMMEDIATE_WIDTH-1:0]     alu_res_in,
    input   logic [IMMEDIATE_WIDTH-1:0]     sign_immediate_in,
    input   logic [IMMEDIATE_WIDTH-1:0]     data_mem_d_in,
    input   logic                           mem_mux_in,
    input   logic [2:0]                     data_mem_write_en_in,
    input   logic                           reg_write_en_in,
    input   logic [1:0]                     write_back_mux_in,

    output   logic                           lui_out,
    output   logic [IMMEDIATE_WIDTH-1:0]     pc_out,
    output   logic [R_ADRESS_WIDTH-1:0]      rd_out,
    output   logic [IMMEDIATE_WIDTH-1:0]     alu_res_out,
    output   logic [IMMEDIATE_WIDTH-1:0]     sign_immediate_out,
    output   logic [IMMEDIATE_WIDTH-1:0]     data_mem_d_out,
    output   logic                           mem_mux_out,
    output   logic [2:0]                     data_mem_write_en_out,
    output   logic                           reg_write_en_out,
    output   logic [1:0]                     write_back_mux_out
);

    always_ff @(posedge clk) begin
        lui_out <= lui_in;
        pc_out <= pc_in;
        rd_out <= rd_in;
        alu_res_out <= alu_res_in;
        sign_immediate_out <= sign_immediate_in;
        data_mem_d_out <= data_mem_d_in;
        mem_mux_out <= mem_mux_in;
        data_mem_write_en_out <= data_mem_write_en_in;
        reg_write_en_out <= reg_write_en_in;
        write_back_mux_out <= write_back_mux_in;
    end
    
endmodule
