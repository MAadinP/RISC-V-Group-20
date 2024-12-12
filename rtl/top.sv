module top #(
    parameter DATA_WIDTH = 32,
    parameter PC_WIDTH = 32,
    parameter REG_WIDTH = 5
) (
    input  logic                    clk,
    input  logic                    rst,
    output logic [DATA_WIDTH-1:0]   a0, // Testing
);
    // FETCH Input Wires
    logic [PC_WIDTH-1:0]    pc_branch;      // ALU_OUT in decode stage

    // FETCH Output Wires (To IF/ID)
    logic [PC_WIDTH-1:0]    pc_in_f;
    logic [PC_WIDTH-1:0]    pc_plus4_in_f;
    logic [DATA_WIDTH-1:0]  ins_in_f;

    // IF/ID Output Wires (To DECODE)
    logic [DATA_WIDTH-1:0]  ins_out_ifid;
    logic [PC_WIDTH-1:0]    pc_out_ifid;
    logic [PC_WIDTH-1:0]    pc_plus4_out_ifid;

    // DECODE Output Wires (To ID/EX)
    logic [DATA_WIDTH-1:0]  data1_d;
    logic [DATA_WIDTH-1:0]  data2_d;
    logic [DATA_WIDTH-1:0]  imm_ext_d;
    logic [PC_WIDTH-1:0]    pc_in_d;
    logic [PC_WIDTH-1:0]    pc_plus4_in_d;
    logic [REG_WIDTH-1:0]   rd1_in_d;
    logic [REG_WIDTH-1:0]   rd2_in_d;
    logic [REG_WIDTH-1:0]   rd_in_d;
    logic [2:0]             func3_in_d;
    logic [2:0]             branch_src_in_d;
    logic [4:0]             alu_control_in_d;
    logic [1:0]             alu_mux_src_in_d;
    logic [1:0]             result_src_in_d;
    logic                   mem_write_in_d;
    logic                   reg_write_in_d;
    logic                   branch_valid_d;

    // ID/EX Output Wires (To EXE)
    logic [REG_WIDTH-1:0]   rd1_out_idex;
    logic [REG_WIDTH-1:0]   rd2_out_idex;
    logic [PC_WIDTH-1:0]    pc_out_idex;
    logic [REG_WIDTH-1:0]   rd_out_idex;
    logic [PC_WIDTH-1:0]    pc_plus4_out_idex;
    logic [DATA_WIDTH-1:0]  imm_ext_idex;
    logic [DATA_WIDTH-1:0]  read_data1_out_idex;
    logic [DATA_WIDTH-1:0]  read_data2_out_idex;
    logic [2:0]             func3_out_idex;

    logic                   reg_write_out_idex;
    logic [1:0]             result_src_out_idex;
    logic                   mem_write_out_idex;
    logic [4:0]             alu_ctrl_out_idex;
    logic [2:0]             branch_jump_out_idex;
    logic                   alu_src_out_idex;
    logic                   branch_valid_idex;


    // EXE Output Wires (To EX/MEM)
    logic                   pc_src_exe;
    logic [DATA_WIDTH-1:0]  alu_in_exe;
    logic [DATA_WIDTH-1:0]  w_data_in_exe;
    logic [PC_WIDTH-1:0]    pc_plus4_in_exe;
    logic [REG_WIDTH-1:0]   rd_in_exe;
    logic [1:0]             result_src_in_exe;
    logic                   mem_write_in_exe;
    logic                   reg_write_in_exe;
    logic [REG_WIDTH-1:0]   rd1_in_exe;
    logic [REG_WIDTH-1:0]   rd2_in_exe;

    // EX/MEM Output Wires (To MEMORY)
    logic [DATA_WIDTH-1:0]  alu_res_out_exmem;
    logic [DATA_WIDTH-1:0]  w_data_out_exmem;
    logic [PC_WIDTH-1:0]    pc_plus4_out_exmem;
    logic [REG_WIDTH-1:0]   rd_out_exmem;
    logic [1:0]             result_src_out_exmem;
    logic                   reg_write_out_exmem;
    logic                   mem_write_out_exmem;
    logic [2:0]             func3_out_exmem;

    //Data Memory Output Wire (To MEM/WB)
    logic [DATA_WIDTH-1:0]  data_out_mem;

    // MEM/WB Output Wires (To MUX3)
    logic [DATA_WIDTH-1:0]  alu_res_out_memwb;
    logic [DATA_WIDTH-1:0]  data_out_memwb;
    logic [REG_WIDTH-1:0]   rd_out_memwb;
    logic [PC_WIDTH-1:0]    pc_plus4_out_memwb;
    logic                   reg_write_out_memwb;
    logic [1:0]             result_src_out_memwb;

    // MUX3 Output Wire
    logic [DATA_WIDTH-1:0]  wb_data_out;

    // Hazard Unit Outputs (Forwarding)
    logic [1:0]             forward_a;
    logic [1:0]             forward_b;

    // Hazard Unit Wires (Stalls)
    logic                   stall_f;                  
    logic                   stall_d;                   
    logic                   flush_e;
    logic                   flush_d;

    FETCH fetch (
        .clk(clk),
        .rst(rst),
        .en(~stall_f),
        .pc_src(pc_src_exe),
        .pc_branch(pc_branch),

        .pc_in(pc_in_f),
        .pc_plus4_in(pc_plus4_in_f),
        .ins_in(ins_in_f)
    );

    IF_ID pipereg_if_id (
        .clk(clk),
        .rst(rst),
        .en(~stall_d),
        .clr(flush_d),
        .ins_in(ins_in_f),
        .pc_in(pc_in_f),
        .pc_plus4_in(pc_plus4_in_f),

        .ins_out(ins_out_ifid),
        .pc_out(pc_out_ifid),
        .pc_plus4_out(pc_plus4_out_ifid)
    );

    DECODE decode (
        .pc_out(pc_out_ifid),
        .pc_plus4_in(pc_plus4_out_ifid),
        .ins_out(ins_out_ifid),
        .write_data(wb_data_out),
        .write_addr(rd_out_memwb),
        .write_enable(reg_write_out_memwb),

        .read_data1(data1_d),
        .read_data2(data2_d),
        .imm_extend(imm_ext_d),
        .pc_in(pc_in_d),
        .pc_plus4_in(pc_plus4_in_d),
        .rd1_in(rd1_in_d),
        .rd2_in(rd2_in_d),
        .rd_in(rd_in_d),
        .func3_in(func3_in_d),
        .branch_src_in(branch_src_in_d),
        .alu_control_in(alu_control_in_d),
        .alu_mux_src_in(alu_mux_src_in_d),
        .result_src_in(result_src_in_d),
        .mem_write_in(mem_write_in_d),
        .reg_write_in(reg_write_in_d),
        .branch_valid(branch_valid_d)
    );

    ID_EX pipereg_id_ex (
        .clk(clk),
        .rst(rst),
        .clr(flush_e)
        .rd1_in(rd1_in_d),
        .rd2_in(rd2_in_d),
        .pc_in(pc_in_d),
        .pc_in(pc_in_d),
        .imm_ext_in(imm_ext_d),
        .pc_plus4_in(pc_plus4_in_d),
        .read_data1_in(data1_d),
        .read_data2_in(data2_d),
        .func3_in(func3_in_d),

        .rd1_out(rd1_out_idex),
        .rd2_out(rd2_out_idex),
        .pc_out(pc_out_idex),
        .rd_out(rd_out_idex),
        .pc_plus4_out(pc_plus4_out_idex),
        .imm_ext_out(imm_ext_idex),
        .read_data1_out(read_data1_out_idex),
        .read_data2_out(read_data2_out_idex),
        .func3_out(func3_out_idex),

        .reg_write_in(reg_write_in_d),
        .result_src_in(result_src_in_d),
        .mem_write_in(mem_write_in_d),
        .alu_ctrl_in(alu_control_in_d),
        .branch_jump_in(branch_src_in_d),
        .alu_src_in(alu_mux_src_in_d),
        .branch_valid_in(branch_valid_d),

        .reg_write_out(reg_write_out_idex),
        .result_src_out(result_src_out_idex),
        .mem_write_out(mem_write_out_idex),
        .alu_ctrl_out(alu_ctrl_out_idex),
        .branch_jump_out(branch_jump_out_idex),
        .alu_src_out(alu_src_out_idex),
        .branch_valid_out(branch_valid_idex)
    );

    EXECUTE execute (
        .rd1_out(read_data1_out_idex),
        .rd2_out(read_data2_out_idex),
        .imm_extend(imm_ext_idex),
        .pc_out(pc_out_idex),
        .pc_plus4_out(pc_plus4_out_idex),
        .rd1_out(rd1_out_idex),
        .rd2_out(rd2_out_idex),
        .rd_out(rd_out_idex),
        .branch_src_out(branch_jump_out_idex),
        .alu_control_out(alu_ctrl_out_idex),
        .result_src_out(result_src_out_idex),
        .alu_src_out(alu_src_out_idex),
        .mem_write_out(mem_write_out_idex),
        .reg_write_out(reg_write_out_idex),
        .branch_valid(branch_valid_idex),

        .forward_a(forward_a),
        .forward_b(forward_b),

        .mem_out(alu_res_out_exmem),
        .wb_out(wb_data_out),

        .pc_src(pc_src_exe),
        .alu_in(alu_in_exe),
        .w_data_in(w_data_in_exe),
        .pc_plus4_in(pc_plus4_in_exe),
        .rd_in(rd_in_exe),
        .result_src_in(result_src_in_exe),
        .mem_write_in(mem_write_in_exe),
        .reg_write_in(reg_write_in_exe),
        .rd1_in(rd1_in_exe),
        .rd2_in(rd2_in_exe)
    );

    EX_MEM pipereg_ex_mem (
        .clk(clk),
        .rst(rst),
        .alu_res_in(alu_in_exe),
        .w_data_in(w_data_in_exe),
        .rd_in(rd_in_exe),
        .pc_plus4_in(pc_plus4_in_exe),
        .func3_in(func3_out_idex),

        .alu_res_out(alu_res_out_exmem),
        .w_data_out(w_data_out_exmem),
        .rd_out(rd_out_exmem),
        .pc_plus4_out(pc_plus4_out_exmem),
        .func3_out(func3_out_exmem),

        .reg_write_in(reg_write_in_exe),
        .result_src_in(result_src_in_exe),
        .mem_write_in(mem_write_in_exe),

        .reg_write_out(reg_write_out_exmem),
        .result_src_out(result_src_out_exmem),
        .mem_write_out(mem_write_out_exmem)
    );

    data_memory data_memory (
        .clk(clk),
        .write_enable(mem_write_out_exmem),
        .func3(func3_out_exmem),
        .address(alu_res_out_exmem),
        .write_data(w_data_out_exmem),

        .data_out(data_out_mem)
    );

    MEM_WB pipereg_mem_wb (
        .clk(clk),
        .rst(rst),
        .alu_res_in(alu_res_out_exmem),
        .data_in(data_out_mem),
        .rd_in(rd_out_exmem),
        .pc_plus4_in(pc_plus4_out_exmem),

        .alu_res_out(alu_res_out_memwb),
        .data_out(data_out_memwb),
        .rd_out(rd_out_memwb),
        .pc_plus4_out(pc_plus4_out_memwb),

        .reg_write_in(reg_write_out_exmem),
        .result_src_in(result_src_out_exmem),

        .reg_write_out(reg_write_out_memwb),
        .result_src_out(result_src_out_memwb)
    );

    MUX3 mux3 (
        .in0(alu_res_out_memwb),
        .in1(data_out_memwb),
        .in2(pc_plus4_out_memwb),
        .sel(result_src_out_memwb),
        .out(wb_data_out)
    );

    hazard_unit hazard_unit (
            .rs1_e(rd1_out_idex),
            .rs2_e(rd2_out_idex),
            .rd_w(rd_out_idex),
            .reg_write_w(reg_write_out_memwb),
            .rd_m(rd_out_exmem),
            .reg_write_m(reg_write_out_exmem),

            .forward_a(forward_a),
            .forward_b(forward_b),

            .result_src_e(result_src_out_idex),
            .rs1_d(rd1_in_d),
            .rs2_d(rd2_in_d),
            .rd_e(rd1_out_idex),
            .pc_src(pc_src_exe),

            .stall_f(stall_f),
            .stall_d(stall_d),
            .flush_e(flush_e),
            .flush_d(flush_d)
        );

endmodule
