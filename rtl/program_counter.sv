module program_counter #(
    parameter PC_WIDTH = 32 
) ( 
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   pc_src,
    input   logic [PC_WIDTH-1:0]    pc_branch, 
    output  logic [PC_WIDTH-1:0]    pc_out,
    output  logic [PC_WIDTH-1:0]    pc_plus4  
);
//internal logic
    logic [PC_WIDTH-1:0] pc_next;

    assign pc_plus4 = pc_out + 32'd4; 
    assign pc_next = pc_src ? pc_branch : pc_plus4; 

    always_ff @ (posedge clk) 
        if (rst)
            pc_out <= 32'hBFC00000;  
        else
            pc_out <= pc_next;

endmodule
