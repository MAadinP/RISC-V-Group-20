module forwarding_mux #(
    parameter DATA_WIDTH = 32;
) (
    input  logic [1:0]              forward_a,
    input  logic [1:0]              forward_b,
    input  logic [DATA_WIDTH-1:0]   rd1,
    input  logic [DATA_WIDTH-1:0]   rd2,
    input  logic [DATA_WIDTH-1:0]   mem_out,
    input  logic [DATA_WIDTH-1:0]   wb_out,
    output logic [DATA_WIDTH-1:0]   alu_op_a,
    output logic [DATA_WIDTH-1:0]   alu_op_b
);

    always_comb begin
        case (forward_a)
            2'b00:      alu_op_a = rd1;
            2'b01:      alu_op_a = wb_out;
            2'b10:      alu_op_a = mem_out;
            default:    alu_op_a = rd1;
        endcase

        case (forward_b)
            2'b00:      alu_op_b = rd2;
            2'b01:      alu_op_b = wb_out;
            2'b10:      alu_op_b = mem_out;
            default:    alu_op_b = rd2;
        endcase
    end

endmodule
