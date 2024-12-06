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

    // Stalls (for LW)
    input  logic [1:0]              result_src,
    output logic                    stall_f,
    output logic                    stall_d,
    output logic                    flush_e

);

always_comb begin
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


    
end


endmodule