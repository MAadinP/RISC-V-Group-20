module EXECUTE #(
    parameter DATA_WIDTH = 32,
    parameter PC_WIDTH = 32,
    parameter REG_WIDTH = 5
) (
    //ID/EX Input Signals
    input  logic [DATA_WIDTH-1:0]   read_data1_out,
    input  logic [DATA_WIDTH-1:0]   read_data2_out,
    input  logic [DATA_WIDTH-1:0]   imm_extend,
    input  logic [PC_WIDTH-1:0]     pc_out,
    input  logic [PC_WIDTH-1:0]     pc_plus4_out,
    input  logic [REG_WIDTH-1:0]    rd1_out,
    input  logic [REG_WIDTH-1:0]    rd2_out,
    input  logic [REG_WIDTH-1:0]    rd_out,
    input  logic [2:0]              branch_src_out,
    input  logic [4:0]              alu_control_out,
    input  logic [1:0]              result_src_out,
    input  logic [1:0]              alu_src_out,
    input  logic                    mem_write_out,
    input  logic                    reg_write_out,
    input  logic                    branch_valid,

    // Hazard Unit Input Signals
    input  logic [1:0]              forward_a,
    input  logic [1:0]              forward_b,

    // Memory Input Signal
    input  logic [DATA_WIDTH-1:0]   mem_out,

    // Writeback Input Signal
    input  logic [DATA_WIDTH-1:0]   wb_out,

    output logic                    pc_src,

    // ALU Related Output Signals
    output logic [DATA_WIDTH-1:0]   alu_in,
    output logic [DATA_WIDTH-1:0]   w_data_in,

    // Direct Output Signals
    output logic [PC_WIDTH-1:0]     pc_plus4_in,
    output logic [REG_WIDTH-1:0]    rd_in,
    output logic [1:0]              result_src_in,
    output logic                    mem_write_in,
    output logic                    reg_write_in,
    output logic [REG_WIDTH-1:0]    rd1_in,
    output logic [REG_WIDTH-1:0]    rd2_in
    
);
    // Direct Output Signals
    assign pc_plus4_in = pc_plus4_out;
    assign rd_in = rd_out;
    assign mem_write_in = mem_write_out;
    assign result_src_in = result_src_out;
    assign rd1_in = rd1_out;
    assign rd2_in = rd2_out;

    assign w_data_in = alu_op_b;

    // Forwarding MUX Outputs
    logic [DATA_WIDTH-1:0]  alu_op_a;
    logic [DATA_WIDTH-1:0]  alu_op_b;

    // ALU MUX Outputs
    logic [DATA_WIDTH-1:0]  alu_input_1;
    logic [DATA_WIDTH-1:0]  alu_input_2;

    FORWARDING_MUX forwarding_mux (
        .forward_a(forward_a),
        .forward_b(forward_b),
        .rd1(read_data1_out),
        .rd2(read_data2_out),
        .mem_out(mem_out),
        .wb_out(wb_out),
        .alu_op_a(alu_op_a),
        .alu_op_b(alu_op_b)
    );

    ALU_MUX alu_mux (
        .data1_in(alu_op_a),
        .data2_in(alu_op_b),
        .pc_in(pc_out),
        .imm_in(imm_extend),
        .alu_mux_src(alu_src_out),
        .alu_op1(alu_input_1),
        .alu_op2(alu_input_2)
    );

    alu alu (
        .alu_ctr(alu_control_out),
        .alu_op1(alu_input_1),
        .alu_op2(alu_input_2),
        .alu_out(alu_in)
    );

    branch_control branch_unit (
        .data1(alu_input_1),
        .data2(alu_input_2),
        .branch_src(branch_src_out),
        .branch_valid(branch_valid),
        .pc_src(pc_src)
    );

endmodule
