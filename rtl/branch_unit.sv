module branch_unit #(
    parameter DATA_WIDTH = 32
) (
    input   logic [DATA_WIDTH-1:0]  data_1,
    input   logic [DATA_WIDTH-1:0]  data_2,
    input   logic [2:0]             branch_sel,
    output  logic                   pc_sel
);
    logic equal;
    logic less_than_s;
    logic less_than_u;

    assign equal = (data_1 == data_2);
    assign less_than_s = $signed(data_1) < $signed(data_2);
    assign less_than_u = $unsigned(data_1) < $unsigned(data_2);

    always_comb begin
        case (branch_sel)
            3'b000: pc_sel = equal;                 // beq
            3'b001: pc_sel = ~equal;                // bne
            3'b010: pc_sel = 0;                     // no branch
            3'b011: pc_sel = 1;                     // jal/jalr/auipc     
            3'b100: pc_sel = less_than_s;           // blt
            3'b101: pc_sel = ~less_than_s;          // bge
            3'b110: pc_sel = ~less_than_u;          // bgeu            
            3'b111: pc_sel = less_than_u;           // bltu
            default: pc_sel = 0;                    // no branch default
        endcase 
    end

endmodule
