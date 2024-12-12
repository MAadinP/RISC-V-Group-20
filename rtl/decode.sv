module decode #(
    parameter DATA_WIDTH = 32,
    parameter PC_WIDTH = 32,
    parameter REG_WIDTH = 5
) (
    // IF/ID Input Signals
    input  logic [PC_WIDTH-1:0]     pc_out,     // PC is coming OUT of pipeline register
    input  logic [PC_WIDTH-1:0]     pc_plus4_in,
    input  logic [DATA_WIDTH-1:0]   ins_out,    // Instruction is coming OUT of pipeline register

    // Writeback Input Signals
    input  logic [DATA_WIDTH-1:0]   write_data,
    input  logic [REG_WIDTH-1:0]    write_addr,
    input  logic                    write_enable,

    // ID/EX Output Signals
    output logic [DATA_WIDTH-1:0]   read_data1,     // Register File
    output logic [DATA_WIDTH-1:0]   read_data2,     //
    output logic [DATA_WIDTH-1:0]   imm_extend,     // Sign Extenstion
    output logic [PC_WIDTH-1:0]     pc_in,          // Direct Connection
    output logic [PC_WIDTH-1:0]     pc_plus4_in,    //
    output logic [REG_WIDTH-1:0]    rd1_in,         //
    output logic [REG_WIDTH-1:0]    rd2_in,         //
    output logic [REG_WIDTH-1:0]    rd_in,          //
    output logic [2:0]              func3_in,       //
    output logic [2:0]              branch_src_in,  // Control Unit
    output logic [4:0]              alu_control_in, //
    output logic [1:0]              alu_mux_src_in, //
    output logic [1:0]              result_src_in,  //
    output logic                    mem_write_in,   //
    output logic                    reg_write_in,   //
    output logic                    branch_valid,   //

    output logic [DATA_WIDTH-1:0]   a0              // Testing



);

    // Direct Connection
    assign pc_in = pc_out;
    assign pc_plus4_in = pc_plus4_out;
    assign rd1_in = ins_out[19:15];
    assign rd2_in = ins_out[24:20];
    assign rd_in = ins_out[11:7];
    assign func3_in = ins_out[14:12];

    logic [2:0] imm_src,

    control_unit control_unit (
        .instruction(ins_out),
        .alu_src(alu_control_in),
        .imm_src(imm_src),
        .branch_src(branch_src_in),
        .mem_write(mem_write_in),
        .alu_mux_src(alu_mux_src_in),
        .wb_src(result_src_in),
        .reg_write(reg_write_in),
        .branch_valid(branch_valid)
    );

    sign_extend sign_extend (
        .imm_src(imm_src),
        .instr_imm(ins_out[31:7]),
        .imm_extend(imm_extend)
    );

    reg_file reg_file (
        .clk(clk),
        .read_addr1(rd1_in),
        .read_addr2(rd2_in),
        .write_addr(write_addr),
        .write_en(write_enable),
        .write_data(write_data),
        .data1(read_data1),
        .data1(read_data2)
    );

endmodule
