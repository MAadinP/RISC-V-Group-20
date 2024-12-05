module top #(
    
) (
    input   logic               clk,
    input   logic               rst,
    input   logic               trigger,
    output  logic               a0
);

    wire pc_wire;
    wire pc_plus4_wire;
    wire alu_src_wire;
    wire branch_src_wire;
    wire branch_src_wire;
    wire branch_src_wire;
    wire data_src1_wire;
    wire data_src1_wire;
    wire data_src1_wire;
    wire data_src2_wire;
    wire result_src_wire;
    wire reg_write_wire;
    wire imm_src_wire;
    wire mem_write_wire;
    wire alu_out_wire;

    // pc 
    program_counter PC(
        .clk(clk),
        .rst(rst),
        .pc_src(),
        .pc_branch(alu),
        .pc_out(pc_wire),
        .pc_plus4(pc_plus4_wire)
    );

    // datapath
    datapath_top datapath(
        .pc_in(pc_wire),
        .pc_plus4_in(pc_plus4_wire),
        .alu_src_in(alu_src_wire),
        .branch_src_in(),
        .clk(),
        .rst(),
        .data_src1_in(),
        .data_src2_in(),
        .result_src_in(),
        .reg_write_in(),
        .imm_src_in(),
        .mem_write_in(),
        .alu_out()
        .reg1_out(),
        .reg2_out()
    );

    // branch control
    branch_control branch_unit(
        .data_1(),
        .data_2(),
        .branch_sel(),
        .pc_selThis()
    );
    
    // control unit
    control_unit control_unit(

    );
    
endmodule
