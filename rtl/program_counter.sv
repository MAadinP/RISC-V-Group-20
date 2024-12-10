module program_counter #(
    parameter PC_WIDTH = 32 
) ( 
    input   logic                   trigger,
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   pc_src,
    input   logic [PC_WIDTH-1:0]    pc_branch, 
    output  logic [PC_WIDTH-1:0]    pc_out,
    output  logic [PC_WIDTH-1:0]    pc_plus4  
);
    // Internal logic
    logic [PC_WIDTH-1:0] pc_next;

    always_comb begin
        pc_plus4 = pc_out + 32'd4; 
        pc_next = pc_src ? pc_branch : pc_plus4;
    end

    always_ff @(posedge clk) begin
        if (rst || ~trigger) pc_out <= 32'hBFC00000;
        else pc_out <= pc_next;
    end

endmodule
