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

        // Debugging with $display
        $display("Time: %0t | pc_plus4: %h | pc_src: %b | pc_branch: %h | pc_next: %h",
                 $time, pc_plus4, pc_src, pc_branch, pc_next);
    end

    always_ff @(posedge clk) begin
        if (rst || ~trigger) begin
            pc_out <= 32'hBFC00000;
            $display("Time: %0t | Reset triggered. pc_out set to: %h", $time, pc_out);
        end else begin
            pc_out <= pc_next;
            $display("Time: %0t | PC updated. pc_out: %h", $time, pc_out);
        end
    end

endmodule
