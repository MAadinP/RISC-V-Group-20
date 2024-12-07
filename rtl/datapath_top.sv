module datapath_top #(
    parameter DATA_WIDTH = 32,
    parameter INSTR_WIDTH = 32,
    parameter ALUSRC_WIDTH = 5,
    parameter BRACHSRC_WIDTH = 3
) (
    input   logic [DATA_WIDTH-1:0]      pc_in,
    input   logic [DATA_WIDTH-1:0]      pc_plus4_in,
    input   logic [ALUSRC_WIDTH-1:0]    alu_src_in,
    input   logic [BRACHSRC_WIDTH-1:0]  branch_src_in,
    input   logic                       clk,
    input   logic                       rst,
    input   logic                       data_src1_in,
    input   logic                       data_src2_in,
    input   logic                       result_src_in,
    input   logic                       reg_write_in,
    input   logic                       imm_src_in,
    input   logic                       mem_write_in,                       
    output  logic [DATA_WIDTH-1:0]      alu_out,
    output  logic [DATA_WIDTH-1:0]      reg1_out,
    output  logic [DATA_WIDTH-1:0]      reg2_out,
    output  logic [DATA_WIDTH-1:0]      a0_out
);

    wire whole_instr;
    wire write_back;
    wire alu_in1;
    wire alu_in2;
    wire imm_out;
    wire mem_out;


    instruction_memory instruction_memory_unit(
        .pc(pc_in),
        .instr(whole_instr)
    );

    sign_extend sign_extend_unit(
        .instr_imm(whole_instr[31:7]),
        .imm_src(imm_src_in),
        .imm_extend(imm_out)
    );

    reg_file register_file_unit(
        .clk(clk),
        .read_addr1(whole_instr[19:15]),
        .read_addr2(whole_instr[24:20]),
        .write_addr(whole_instr[11:7]),
        .write_en(reg_write_in),
        .write_data(write_back),
        .data1(reg1_out),
        .data1(reg2_out),
        .a0(a0_out)
    );

    mux data_mux1(
        .in0(reg1_out),
        .in1(pc_in),
        .sel(data_src1_in),
        .out(alu_in1)
    );

    mux data_mux2(
        .in0(reg2_out),
        .in1(imm_out),
        .sel(data_src2_in),
        .out(alu_in2)
    );

    alu alu_unit(
      .alu_src(alu_src_in),  
      .alu_op1(alu_in1),  
      .alu_op2(alu_in2),  
      .alu_out(alu_out)  
    );

    data_memory data_memory_unit(
        .clk(clk),
        .write_enable(mem_write_in),
        .func3(whole_instr[14:12]),
        .address(alu_out),
        .write_data(reg2_out),
        .data_out(mem_out)
    );

    mux4 data_out_mux(
        .in0(pc_plus4_in),
        .in1(alu_out),
        .in2(imm_out),
        .in3(imm_out),
        .sel(result_src_in),
        .out(write_back)
    );

endmodule
