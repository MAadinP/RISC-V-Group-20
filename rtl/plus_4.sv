module plus_4 #(
    parameter DATA_WIDTH = 32
) (
    input   logic [DATA_WIDTH-1:0]  d_in,
    output   logic [DATA_WIDTH-1:0]  d_out
);

    assign d_out = d_in + 32'h00000004;

endmodule
