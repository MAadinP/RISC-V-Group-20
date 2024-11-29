module program_counter #(
    parameter PC_WIDTH = 32
) (
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   pc_src,
    input   logic [PC_WIDTH-1:0]    pc_plusfour,
    input   logic [PC_WIDTH-1:0]    pc_target,
    output  logic [PC_WIDTH-1:0]    pc
);

    logic [PC_WIDTH-1:0] pc_next;

    always_ff @ (posedge clk)//pos edge synch
        pc_next = pc_src ? pc_target : pc_plusfour; //mux sel val is scr
        if (rst)
            pc = 32'hBFC00000;  // INSTR MEM STARTS AT THIS VALUE
        else
            pc = pc_next;

endmodule
