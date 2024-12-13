module mux_2 #(
    parameter DATA_WIDTH = 32
) (
    input   logic                   mux_sel,
    input   logic [DATA_WIDTH-1:0]  in_0,
    input   logic [DATA_WIDTH-1:0]  in_1,
    output  logic [DATA_WIDTH-1:0]  d_out
);

    always_comb begin
        case(mux_sel)
            1'b0: d_out = in_0;
            1'b1: d_out = in_1;
            default: d_out = in_0;
        endcase
    end
    
endmodule
