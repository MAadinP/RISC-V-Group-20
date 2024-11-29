module program_counter #( //Model 2
    parameter PC_WIDTH = 32 //using 32 bits, 32I
) ( //external logic
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   pc_src,
    input   logic [PC_WIDTH-1:0]    ImmExt, //new in log
    output  logic [PC_WIDTH-1:0]    pc
);
//internal logic
    logic [PC_WIDTH-1:0] pc_next;
    logic [PC_WIDTH-1:0] pc_target, //made internal
    logic [PC_WIDTH-1:0] pc_plus4,  //made internal //corr name

    assign pc_target = pc + ImmExt; //jmp or brch
    assign pc_plus4 = pc + 4'b0100; //regular increment 
    assign pc_next = pc_src ? pc_target : pc_plus4; //mux, sel val is scr  //corr name //doesn't meed posedge

    always_ff @ (posedge clk) //pos edge synch
        if (rst)
            pc = 32'hBFC00000;  // INSTR MEM STARTS AT THIS VALUE
        else
            pc = pc_next;

endmodule