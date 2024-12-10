module top (
    input   logic               clk,
    input   logic               rst,
    input   logic               trigger,
    output  logic [31:0]        a0,
    // output  logic [31:0] pc_out_wire,
    // output  logic [31:0] pc_plus4_wire,                               
    // output  logic [31:0] alu_out_wire,          
    // output  logic [31:0] reg1_data_wire,
    // output  logic [31:0] reg2_data_wire,                             
    output  logic [31:0] instruction_wire                              
);

    // DATAPATH SIGNALS
    logic [31:0] pc_out_wire;
    logic [31:0] pc_plus4_wire;                                
    logic [31:0] alu_out_wire;           
    logic [31:0] reg1_data_wire;
    logic [31:0] reg2_data_wire;                              
    // logic [31:0] instruction_wire;                              

    // CONTROL SIGNALS
    logic        pc_src_wire;                                
    logic        data1_src_wire;                                
    logic        data2_src_wire;                                
    logic        reg_write_wire;
    logic        mem_write_wire;               
    logic [4:0]  alu_src_wire;              
    logic [1:0]  wb_src_wire;               
    logic [2:0]  imm_src_wire;               
    logic [2:0]  branch_src_wire;           

    // PROGRAM COUNTER
    program_counter pc (
        .clk(clk),
        .rst(rst),
        .trigger(trigger),
        .pc_src(pc_src_wire),
        .pc_branch(alu_out_wire),
        .pc_out(pc_out_wire),
        .pc_plus4(pc_plus4_wire)
    );

    // DATAPATH
    datapath_top datapath (
        .clk(clk),
        .pc_in(pc_out_wire),                   
        .pc_plus4_in(pc_plus4_wire),           
        .alu_src_in(alu_src_wire),                     
        .data_src1_in(data1_src_wire),         
        .data_src2_in(data2_src_wire),         
        .result_src_in(wb_src_wire),           
        .reg_write_in(reg_write_wire),         
        .imm_src_in(imm_src_wire),             
        .mem_write_in(mem_write_wire),          
        .alu_out(alu_out_wire),             
        .reg1_out(reg1_data_wire),           
        .reg2_out(reg2_data_wire),             
        .whole_instr(instruction_wire),             
        .a0_out(a0)                       
    );

    // BRANCH CONTROL
    branch_control branch_unit (
        .data_1(reg1_data_wire),               
        .data_2(reg2_data_wire),               
        .branch_src(branch_src_wire),         
        .pc_src(pc_src_wire)                   
    );

    // CONTROL UNIT
    control_unit control_unit (
        .instruction(instruction_wire),        
        .alu_src(alu_src_wire),               
        .imm_src(imm_src_wire),                
        .branch_src(branch_src_wire),         
        .mem_write(mem_write_wire),            
        .op1_src(data1_src_wire),                       
        .op2_src(data2_src_wire),                
        .wb_src(wb_src_wire),                  
        .reg_write(reg_write_wire)             
    );

endmodule
