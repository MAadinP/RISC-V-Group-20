module hazard_unit #(
    parameter REG_WIDTH = 5
) (
    // Forwarding
    input  logic [REG_WIDTH-1:0]   rs1_e,
    input  logic [REG_WIDTH-1:0]   rs2_e,
    input  logic [REG_WIDTH-1:0]   rd_w,           // From Writeback Stage
    input  logic                   reg_write_w,
    input  logic [REG_WIDTH-1:0]   rd_m,           // From Memory Access Stage
    input  logic                   reg_write_m,
    output logic [1:0]             forward_a,      // Multiplexer Control Signals
    output logic [1:0]             forward_b,

    // Stalls
    input  logic [1:0]              result_src_e,
    input  logic [REG_WIDTH-1:0]    rs1_d,
    input  logic [REG_WIDTH-1:0]    rs2_d,
    input  logic [REG_WIDTH-1:0]    rd_e,
    input  logic                    pc_src,
    output logic                    stall_f,
    output logic                    stall_d,
    output logic                    flush_e,
    output logic                    flush_d

);

    logic lw_stall;
    logic branch_stall;
    logic stall;

always_comb begin
    // Forwarding
    if (((rs1_e == rd_m) & reg_write_m) & (rs1_e != 0)) begin             // Forward From Memory Access Stage (RS1)
        forward_a = 2'b10;
    end else if (((rs1_e == rd_w) & reg_write_w) & (rs1_e != 0)) begin    // Forward From Writeback Stage (RS1)
        forward_a = 2'b01;
    end else begin
        forward_a = 2'b00;                                          // No Forwarding Required (RS1)
    end

    if (((rs2_e == rd_m) & reg_write_m) & (rs2_e != 0)) begin             // Forward From Memory Access Stage (RS2)
        forward_b = 2'b10;
    end else if (((rs2_e == rd_w) & reg_write_w) & (rs2_e != 0)) begin    // Forward From Writeback Stage (RS2)
        forward_b = 2'b01;
    end else begin
        forward_b = 2'b00;                                          // No Forwarding Required (RS2)
    end

    // Stalling
    lw_stall = ((result_src_e == '0) & ((rs1_d == rd_e) || (rs2_d == rd_e)));
    
    stall_f = lw_stall;
    stall_d = lw_stall;
    flush_e = lw_stall;

    branch_stall = (pc_src == '1);

    stall = branch_stall || lw_stall;
    
    stall_f = stall;
    stall_d = stall;
    flush_e = stall;

    flush_d = (branch_stall);

end

endmodule
