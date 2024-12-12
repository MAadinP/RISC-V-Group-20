module pipereg_if_id #(
    parameter DATA_WIDTH = 32,
    parameter PC_WIDTH = 32
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    en,
    input  logic                    clr,        // Flush
    input  logic [DATA_WIDTH-1:0]   ins_in,
    input  logic [PC_WIDTH-1:0]     pc_in,
    input  logic [PC_WIDTH-1:0]     pc_plus4_in,
    output logic [DATA_WIDTH-1:0]   ins_out,
    output logic [PC_WIDTH-1:0]     pc_out,
    output logic [PC_WIDTH-1:0]     pc_plus4_out
);

always_ff @(posedge clk) begin
    if (rst) begin
        ins_out <= '0;
        pc_out <= '0;
        pc_plus4_out <= '0;
    end else if (clr) begin
        ins_out <= '0;
        pc_out <= '0;
        pc_plus4_out <= '0;
    end else if (en) begin
        ins_out <= ins_in;
        pc_out <= pc_in;
        pc_plus4_out <= pc_plus4_in;
    end
end

endmodule
