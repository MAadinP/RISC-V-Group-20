module pip_reg4 #(
    parameter IMMEDIATE_WIDTH = 32
) (
    input   logic                           clk,
    input   logic [4:0]                     rd_in,
    input   logic [IMMEDIATE_WIDTH-1:0]     pc_in,
    input   logic [IMMEDIATE_WIDTH-1:0]     alu_res_in,
    input   logic [IMMEDIATE_WIDTH-1:0]     sign_immediate_in,
    input   logic [IMMEDIATE_WIDTH-1:0]     data_mem_res_in,
    input   logic                           reg_write_en_in,
    input   logic [1:0]                     write_back_mux_in,

    output   logic [4:0]                     rd_out,
    output   logic [IMMEDIATE_WIDTH-1:0]     pc_out,
    output   logic [IMMEDIATE_WIDTH-1:0]     alu_res_out,
    output   logic [IMMEDIATE_WIDTH-1:0]     sign_immediate_out,
    output   logic [IMMEDIATE_WIDTH-1:0]     data_mem_res_out,
    output   logic                           reg_write_en_out,
    output   logic [1:0]                     write_back_mux_out
);

    always_ff @(posedge clk) begin
        rd_out <= rd_in;
        pc_out <= pc_in;
        alu_res_out <= alu_res_in;
        sign_immediate_out <= sign_immediate_in;
        data_mem_res_out <= data_mem_res_in;
        reg_write_en_out <= reg_write_en_in;
        write_back_mux_out <= write_back_mux_in;
    end 
    
endmodule