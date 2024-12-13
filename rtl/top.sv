module top #(
    parameter DATA_WIDTH = 32
) (
    input   logic clk,
    input   logic rst,
    input   logic trigger,//look here
    output  logic [DATA_WIDTH-1:0] a0    
);

    logic           stall_wire;
    logic           jump_en_wire;
    logic [31:0]    alu_res_wire;
    logic [31:0]    pc_to_im_wire;
    logic [31:0]    instr_to_reg_wire;
    logic [31:0]    pc_reg1_to_reg2_wire;
    logic [31:0]    instr_reg1_wire;
    logic [4:0]     rd_exec_wire;
    logic [4:0]     rd_mem_wire;
    logic           lw_exec_wire;
    logic [2:0]     sign_extend_sel_wire;
    logic [4:0]     rd_hazard_wire;
    logic           lw_hazard_wire;
    logic           lui_hazard_wire;
    logic [1:0]     alu_mux1_hazard_wire;
    logic [1:0]     alu_mux2_hazard_wire;
    logic [1:0]     branch_mux1_hazard_wire;
    logic [1:0]     branch_mux2_hazard_wire;
    logic           mem_mux_hazard_wire;
    logic           exec_mux_hazard_wire;
    logic [4:0]     rd_reg4_wire;
    logic           write_en_reg4_wire;
    logic [31:0]    write_back_mux_wire;
    logic [31:0]    rs1_reg_file_wire;
    logic [31:0]    rs2_reg_file_wire;
    logic [31:0]    imm_sign_extend_wire;
    logic [2:0]     bsel_c_unit_wire;
    logic [1:0]     wb_mux_c_unit_wire;
    logic           r_write_en_c_unit_wire;
    logic [4:0]     alu_sel_c_unit_wire;
    logic [2:0]     d_write_en_c_unit_wire;
    logic [31:0]    pc_reg2_wire;
    logic           lui_reg2_wire;
    logic [1:0]     alu_mux1_reg2_wire;
    logic [1:0]     alu_mux2_reg2_wire;
    logic [1:0]     b_mux1_reg2_wire;
    logic [1:0]     b_mux2_reg2_wire;
    logic           exec_mux_reg2_wire;
    logic           mem_mux_reg2_wire;
    logic [31:0]    rs1_reg2_wire;
    logic [31:0]    rs2_reg2_wire;
    logic [31:0]    imm_reg2_wire;
    logic [4:0]     alu_sel_reg2_wire;
    logic [2:0]     b_sel_reg2_wire;
    logic [2:0]     d_write_en_reg2_wire;
    logic           r_write_en_reg2_wire;
    logic [1:0]     wb_mux_reg2_wire;
    logic [31:0]    pc_plus4_wire;
    logic [31:0]    m_mux2_res_wire;
    logic [31:0]    alu_mux1_res_wire;
    logic [31:0]    alu_mux2_res_wire;
    logic [31:0]    exec_mux_res_wire;
    logic [31:0]    b_mux1_res_wire;
    logic [31:0]    b_mux2_res_wire;
    logic           mem_mux2_wire;
    logic [31:0]    pc_reg3_wire;
    logic [31:0]    alu_res_reg3_wire;
    logic [31:0]    imm_reg3_wire;
    logic [31:0]    d_mem_d_reg3_wire;
    logic           mem_mux_reg3_wire;
    logic [2:0]     d_write_en_reg3_wire;
    logic           r_write_en_reg3_wire;
    logic [1:0]     wb_mux_reg3_wire;
    logic [31:0]    d_mem_d_in_wire;
    logic [31:0]    d_mem_res_wire;
    logic [31:0]    pc_reg4_wire;
    logic [31:0]    alu_res_reg4_wire;
    logic [31:0]    imm_reg4_wire;
    logic [31:0]    d_mem_res_reg4_wire;
    logic [1:0]     wb_mux_reg4_wire;
    logic [2:0]     func3_3get2;
    logic [2:0]     func3_cacheget3;
    logic [31:0]    dirty_address;
    logic [31:0]    dirty_datab;
    logic           dirty_enable;
    logic [31:0]    dram_cached;
    logic           hitmux_sel;
    logic [31:0]    array_mux;
    logic [31:0]    dram_mux;


    program_counter program_counter (
        .clk(clk),
        .rst(rst),
        .trigger(trigger),//Look here
        .stall(stall_wire),
        .pc_branch(jump_en_wire),
        .pc_target(alu_res_wire),
        .pc(pc_to_im_wire)
    );

    // Code for word addressable instruction memory
    // instruction_memory instruction_memory (
    //     .pc(pc_to_im_wire),
    //     .instr(instr_to_reg_wire)
    // );

    instruction_memory_v1 instruction_memory (
        .pc(pc_to_im_wire),
        .instr(instr_to_reg_wire)
    );

    pip_reg1 pipeline_reg1 (
       .clk(clk),
       .stall(stall_wire),
       .trigger(trigger),
       .rst(jump_en_wire),
       .pc_in(pc_to_im_wire),
       .instr_in(instr_to_reg_wire),
       .pc_out(pc_reg1_to_reg2_wire),
       .instr_out(instr_reg1_wire) 
    );

    hazard_unit hazard_unit (
        .rs1(instr_reg1_wire[19:15]),
        .rs2(instr_reg1_wire[24:20]),
        .rd_in(instr_reg1_wire[11:7]),
        .exec_rd(rd_exec_wire),
        .mem_rd(rd_mem_wire),
        .exec_lw(lw_exec_wire),
        .sign_extend_sel(sign_extend_sel_wire),
        .opcode(instr_reg1_wire[6:0]),
        .rd_out(rd_hazard_wire),
        .lw(lw_hazard_wire),
        .mem_mux2(lui_hazard_wire),
        .stall(stall_wire),
        .alu_mux1_sel(alu_mux1_hazard_wire),
        .alu_mux2_sel(alu_mux2_hazard_wire),
        .branch_mux1_sel(branch_mux1_hazard_wire),
        .branch_mux2_sel(branch_mux2_hazard_wire),
        .mem_mux(mem_mux_hazard_wire),
        .exec_mux(exec_mux_hazard_wire)
    );

    reg_file register_file (
        .clk(clk),
        .read_addr1(instr_reg1_wire[19:15]),
        .read_addr2(instr_reg1_wire[24:20]),
        .write_addr(rd_reg4_wire),
        .write_en(write_en_reg4_wire),
        .write_data(write_back_mux_wire),
        .data1(rs1_reg_file_wire),
        .data2(rs2_reg_file_wire),
        .a0(a0)
    );

    sign_extend sign_extend (
        .instr(instr_reg1_wire),
        .imm_sel(sign_extend_sel_wire),
        .imm_ext(imm_sign_extend_wire)
    );

    control_unit control_unit (
        .func_3(instr_reg1_wire[14:12]),
        .func_7(instr_reg1_wire[31:25]),
        .opcode(instr_reg1_wire[6:0]),
        .sign_extend_sel(sign_extend_sel_wire),
        .branch_sel(bsel_c_unit_wire),
        .write_back_mux(wb_mux_c_unit_wire),
        .reg_write_en(r_write_en_c_unit_wire),
        .alu_sel(alu_sel_c_unit_wire),
        .data_mem_write_en(d_write_en_c_unit_wire)
    );

    pip_reg2 pipeline_reg2 (
        .clk(clk),
        .rst(jump_en_wire),
        .stall(stall_wire),
        .pc_in(pc_reg1_to_reg2_wire),
        .lw_in(lw_hazard_wire),
        .lui_in(lui_hazard_wire),
        .rd_in(rd_hazard_wire),
        .alu_mux1_sel_in(alu_mux1_hazard_wire),
        .alu_mux2_sel_in(alu_mux2_hazard_wire),
        .branch_mux1_sel_in(branch_mux1_hazard_wire),
        .branch_mux2_sel_in(branch_mux2_hazard_wire),
        .exec_mux_in(exec_mux_hazard_wire),
        .mem_mux_in(mem_mux_hazard_wire),
        .rs1_in(rs1_reg_file_wire),
        .rs2_in(rs2_reg_file_wire),
        .immediate_in(imm_sign_extend_wire),
        .alu_sel_in(alu_sel_c_unit_wire),
        .branch_sel_in(bsel_c_unit_wire),
        .data_mem_write_en_in(d_write_en_c_unit_wire),
        .reg_write_en_in(r_write_en_c_unit_wire),
        .write_back_mux_in(wb_mux_c_unit_wire),
        .func_3(instr_reg1_wire[14:12]),

        .pc_out(pc_reg2_wire),
        .lw_out(lw_exec_wire),
        .lui_out(lui_reg2_wire),
        .rd_out(rd_exec_wire),
        .alu_mux1_sel_out(alu_mux1_reg2_wire),
        .alu_mux2_sel_out(alu_mux2_reg2_wire),
        .branch_mux1_sel_out(b_mux1_reg2_wire),
        .branch_mux2_sel_out(b_mux2_reg2_wire),
        .exec_mux_out(exec_mux_reg2_wire),
        .mem_mux_out(mem_mux_reg2_wire),
        .rs1_out(rs1_reg2_wire),
        .rs2_out(rs2_reg2_wire),
        .immediate_out(imm_reg2_wire),
        .alu_sel_out(alu_sel_reg2_wire),
        .branch_sel_out(b_sel_reg2_wire),
        .data_mem_write_en_out(d_write_en_reg2_wire),
        .reg_write_en_out(r_write_en_reg2_wire),
        .write_back_mux_out(wb_mux_reg2_wire),
        .func_3_out(func3_3get2)
    );

    plus_4 plus_4 (
        .d_in(pc_reg2_wire),
        .d_out(pc_plus4_wire)
    );

    mux_4 alu_mux1 (
        .mux_sel(alu_mux1_reg2_wire),
        .in_0(rs1_reg2_wire),
        .in_1(pc_reg2_wire),
        .in_2(m_mux2_res_wire),
        .in_3(write_back_mux_wire),
        .d_out(alu_mux1_res_wire)
    );

    mux_4 alu_mux2 (
        .mux_sel(alu_mux2_reg2_wire),
        .in_0(rs2_reg2_wire),
        .in_1(imm_reg2_wire),
        .in_2(m_mux2_res_wire),
        .in_3(write_back_mux_wire),
        .d_out(alu_mux2_res_wire)
    );

    alu alu (
        .alu_op1(alu_mux1_res_wire),
        .alu_op2(alu_mux2_res_wire),
        .alu_sel(alu_sel_reg2_wire),
        .alu_out(alu_res_wire)
    );

    mux_2 exec_mux (
        .mux_sel(exec_mux_reg2_wire),
        .in_0(rs2_reg2_wire),
        .in_1(write_back_mux_wire),
        .d_out(exec_mux_res_wire)
    );

    mux_3 branch_mux1 (
        .mux_sel(b_mux1_reg2_wire),
        .in_0(rs1_reg2_wire),
        .in_1(m_mux2_res_wire),
        .in_2(write_back_mux_wire),
        .d_out(b_mux1_res_wire)
    );

    mux_3 branch_mux2 (
        .mux_sel(b_mux2_reg2_wire),
        .in_0(rs2_reg2_wire),
        .in_1(m_mux2_res_wire),
        .in_2(write_back_mux_wire),
        .d_out(b_mux2_res_wire)
    );

    branch_unit branch_unit (
        .rs1(b_mux1_res_wire),
        .rs2(b_mux2_res_wire),
        .branch_sel(b_sel_reg2_wire),
        .branch_taken(jump_en_wire)
    );

    pip_reg3 pipeline_reg3 (
        .clk(clk),
        .lui_in(lui_reg2_wire),
        .pc_in(pc_plus4_wire),
        .rd_in(rd_exec_wire),
        .alu_res_in(alu_res_wire),
        .sign_immediate_in(imm_reg2_wire),
        .data_mem_d_in(exec_mux_res_wire),
        .mem_mux_in(mem_mux_reg2_wire),
        .data_mem_write_en_in(d_write_en_reg2_wire),
        .reg_write_en_in(r_write_en_reg2_wire),
        .write_back_mux_in(wb_mux_reg2_wire),
        .func_3_in(func3_3get2),
        
        .lui_out(mem_mux2_wire),
        .pc_out(pc_reg3_wire),
        .rd_out(rd_mem_wire),
        .alu_res_out(alu_res_reg3_wire),
        .sign_immediate_out(imm_reg3_wire),
        .data_mem_d_out(d_mem_d_reg3_wire),
        .mem_mux_out(mem_mux_reg3_wire),
        .data_mem_write_en_out(d_write_en_reg3_wire),
        .reg_write_en_out(r_write_en_reg3_wire),
        .write_back_mux_out(wb_mux_reg3_wire),
        .func_3_cache(func3_cacheget3)
    );

    mux_2 mem_mux2 (
        .mux_sel(mem_mux2_wire),
        .in_0(alu_res_reg3_wire),
        .in_1(imm_reg3_wire),
        .d_out(m_mux2_res_wire)
    );

    mux_2 mem_mux (
        .mux_sel(mem_mux_reg3_wire),
        .in_0(d_mem_d_reg3_wire),
        .in_1(write_back_mux_wire),
        .d_out(d_mem_d_in_wire)
    );

    data_memory data_memory (
        .clk(clk),
        .func3(func3_cacheget3),
        .address(alu_res_reg3_wire),
        .dirty_add(dirty_address),
        .dirty_data(dirty_datab),
        .dirty_en(dirty_enable),

        .new_data(dram_cached),
        .data_out(dram_mux)
    );
    cache cache_unit (
        .clk(clk),
        .reset(rst),
        .funct3(func3_cacheget3),
        .mem_address(alu_res_reg3_wire), /////////addd muxxxxx
        .write_en(d_write_en_reg3_wire),
        .cpu_data(d_mem_d_in_wire), //.data_in(d_mem_d_in_wire),
        .new_data(dram_cached),

        .hit(hitmux_sel),
        .array_data(array_mux),
        .dirty_add(dirty_address),
        .dirty_data(dirty_datab),
        .dirty_en(dirty_enable)
    );

    mux_2 hitmux(
        .mux_sel(hitmux_sel),
        .in_0(dram_mux),
        .in_1(array_mux),
        .d_out(d_mem_res_wire)
    );

    pip_reg4 pipeline_reg4 (
        .clk(clk),
        .rd_in(rd_mem_wire),
        .pc_in(pc_reg3_wire),
        .alu_res_in(alu_res_reg3_wire),
        .sign_immediate_in(imm_reg3_wire),
        .data_mem_res_in(d_mem_res_wire),
        .reg_write_en_in(r_write_en_reg3_wire),
        .write_back_mux_in(wb_mux_reg3_wire),

        .rd_out(rd_reg4_wire),
        .pc_out(pc_reg4_wire),
        .alu_res_out(alu_res_reg4_wire),
        .sign_immediate_out(imm_reg4_wire),
        .data_mem_res_out(d_mem_res_reg4_wire),
        .reg_write_en_out(write_en_reg4_wire),
        .write_back_mux_out(wb_mux_reg4_wire)
    );

    mux_4 write_back_mux (
        .mux_sel(wb_mux_reg4_wire),
        .in_0(pc_reg4_wire),
        .in_1(alu_res_reg4_wire),
        .in_2(imm_reg4_wire),
        .in_3(d_mem_res_reg4_wire),
        .d_out(write_back_mux_wire)
    );

endmodule
