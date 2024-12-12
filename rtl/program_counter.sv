module program_counter #(
    parameter PC_WIDTH = 32 //using 32 bits, 32I
) ( //external logic
    input   logic                   trigger,
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   en,
    input   logic                   pc_src,
    input   logic [PC_WIDTH-1:0]    pc_branch, //new in log
    output  logic [PC_WIDTH-1:0]    pc
);
//internal logic
    logic [PC_WIDTH-1:0] pc_next;
    logic [PC_WIDTH-1:0] pc_plus4;  //made internal //corr name

    assign pc_plus4 = pc + 4'b0100; //regular increment 
    assign pc_next = pc_src ? pc_branch : pc_plus4; //mux, sel val is scr  //corr name //doesn't need posedge 

    always_ff @ (posedge clk) //pos edge synch
        if (rst || ~trigger)
            pc <= 32'hBFC00000;  // INSTR MEM STARTS AT THIS VALUE
        else
            pc <= (en) ? pc_next : pc;

endmodule
