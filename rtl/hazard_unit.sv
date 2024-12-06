module hazard_unit #(
    parameter DATA_LENGTH = 32,
    parameter REG_LENGTH = 5
) (
    // Forwarding
    input  logic [REG_LENGTH-1:0]   rs1,
    input  logic [REG_LENGTH-1:0]   rs2,
    input  logic [REG_LENGTH-1:0]   rd_w,           // From Writeback Stage
    input  logic                    reg_write_w,
    input  logic [REG_LENGTH-1:0]   rd_m,           // From Memory Access Stage
    input  logic                    reg_write_m,
    output logic [1:0]              forward_a,      // Multiplexer Control Signals
    output logic [1:0]              forward_b,

    // Stalls
    input  logic [1:0]              result_src,
    input  logic [4:0]              rd_out_id_ex,
    input  logic [2:0]              branch_jump,
    output logic                    stall_f,
    output logic                    stall_d,
    output logic                    flush_e

);

    logic lw_stall;
    logic branch_stall;
    logic stall;

always_comb begin
    // Forwarding
    if ((rs1 == rd_m) & reg_write_m) & (rs1 != 0) begin             // Forward From Memory Access Stage (RS1)
        forward_a = 2'b10;
    end else if ((rs1 == rd_w) & reg_write_w) & (rs1 != 0) begin    // Forward From Writeback Stage (RS1)
        forward_a = 2'b01;
    end else begin
        forward_a = 2'b00;                                          // No Forwarding Required (RS1)
    end

    if ((rs2 == rd_m) & reg_write_m) & (rs2 != 0) begin             // Forward From Memory Access Stage (RS2)
        forward_b = 2'b10;
    end else if ((rs2 == rd_w) & reg_write_w) & (rs2 != 0) begin    // Forward From Writeback Stage (RS2)
        forward_b = 2'b01;
    end else begin
        forward_b = 2'b00;                                          // No Forwarding Required (RS2)
    end

    // Stalling
    lw_stall = (result_src == '0) & ((rs1 == rd_out_id_ex) || (rs2 == rd_out_id_ex));
    stall_f = stall_d = flush_e = lw_stall;

    branch_stall = ~(branch_jump == 3'b010);

    stall = branch_stall || lw_stall;

    stall_f = stall_d = flush_e = stall;

end

endmodule
