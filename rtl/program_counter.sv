module program_counter # (
    parameter   ADDRESS_WIDTH = 32
)(
    input   logic                       clk,
    input   logic                       rst,
    input   logic                       stall,
    input   logic                       trigger,
    input   logic                       pc_branch,
    input   logic [ADDRESS_WIDTH-1:0]   pc_target,
    output  logic [ADDRESS_WIDTH-1:0]   pc
);

    logic [ADDRESS_WIDTH-1:0] pc_next;
    logic [ADDRESS_WIDTH-1:0] pc_plus4;
    initial pc = 32'hBFC00000;

    always_comb begin
        pc_plus4 = pc + 4'b0100;

        if(pc_branch)begin
            pc_next = pc_target;
        end
        else if (stall) begin
            pc_next = pc;
        end
        else begin
            pc_next = pc_plus4;
        end
    end

    always_ff @(posedge clk) begin
        if (rst || trigger)
            pc <= 32'hBFC00000;
        else
            pc <= pc_next;
    end

endmodule