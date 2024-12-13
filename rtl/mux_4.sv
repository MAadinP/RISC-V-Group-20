module mux_4 #(
    parameter DATA_WIDTH = 32
) (
    input   logic [1:0]             mux_sel,
    input   logic [DATA_WIDTH-1:0]  in_0,
    input   logic [DATA_WIDTH-1:0]  in_1,
    input   logic [DATA_WIDTH-1:0]  in_2,
    input   logic [DATA_WIDTH-1:0]  in_3,
    output  logic [DATA_WIDTH-1:0]  d_out
);

    always_comb begin
        case(mux_sel)
            2'b00: d_out = in_0;
            2'b01: d_out = in_1;
            2'b10: d_out = in_2;
            2'b11: d_out = in_3;
            default: d_out = in_0;
        endcase
    end
    
endmodule