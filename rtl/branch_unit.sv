module branch_control #(
    parameter DATA_WIDTH = 32
) (
    input   logic [DATA_WIDTH-1:0]  data_1,        
    input   logic [DATA_WIDTH-1:0]  data_2,        
    input   logic [2:0]             branch_src,    // branch type selector
    input   logic                   branch_valid,  // control signal indicating branch eval stage
    output  logic                   pc_src         
);

    logic equal;
    logic less_than_s;
    logic less_than_u;

    assign equal = (data_1 == data_2);
    assign less_than_s = $signed(data_1) < $signed(data_2);
    assign less_than_u = $unsigned(data_1) < $unsigned(data_2);

    always_comb begin
       //default
        pc_src = 0;

        // Branching logic (only active when branch_valid is high)
        if (branch_valid) begin
            case (branch_src)
                3'b000: pc_src = equal;                 // beq
                3'b001: pc_src = ~equal;                // bne
                3'b010: pc_src = 0;                     // no branch
                3'b011: pc_src = 1;                     // jal/jalr/auipc     
                3'b100: pc_src = less_than_s;           // blt
                3'b101: pc_src = ~less_than_s;          // bge
                3'b110: pc_src = ~less_than_u;          // bgeu            
                3'b111: pc_src = less_than_u;           // bltu
                default: pc_src = 0;                    // no branch default
            endcase
        end
    end
endmodule
