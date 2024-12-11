module FETCH #(
    parameter DATA_WIDTH = 32,
    parameter PC_WIDTH = 32
) (
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   en,
    input   logic                   pc_src,
    input   logic [PC_WIDTH-1:0]    pc_branch,
    output  logic [PC_WIDTH-1:0]    pc_in,          // PC is going IN pipeline register
    output  logic [PC_WIDTH-1:0]    pc_plus4_in,    // PC + 4 is going IN pipeline register
    output  logic [DATA_WIDTH-1:0]  ins_in          // Instruction is going IN pipeline register
);

    assign pc_plus4_in = pc_in + 4;

    program_counter pc (
        .clk(clk),
        .rst(rst),
        .en(en),
        .pc_src(pc_src),
        .pc_branch(pc_branch),
        .pc(pc_in) 
    );

    instruction_memory ins_mem (
        .pc(pc_in),
        .instr(ins_in)
    );

endmodule
