module PC_STALL_REG #(
    parameter PC_WIDTH = 32
) (
    input  logic                clk,
    input  logic                en,
    input  logic [PC_WIDTH-1:0] pc_in,
    output logic [PC_WIDTH-1:0] pc_out
);

always_ff @(posedge clk) begin
    pc_out <= en ? pc_in : pc_out;
end

endmodule
