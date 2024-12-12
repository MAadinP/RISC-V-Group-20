module pip_reg1 #(
    parameter PC_WIDTH = 32,
    parameter INSTRUCTION_WIDTH = 32
) (
    input   logic                           clk,
    input   logic                           stall,
    input   logic                           rst,
    input   logic                           trigger,
    input   logic [PC_WIDTH-1:0]            pc_in,
    input   logic [INSTRUCTION_WIDTH-1:0]   instr_in,
    output  logic [PC_WIDTH-1:0]            pc_out,
    output  logic [INSTRUCTION_WIDTH-1:0]   instr_out
);
    logic [PC_WIDTH-1:0]            pc_next;
    logic [INSTRUCTION_WIDTH-1:0]   instr_next;

    always_comb begin
        if(stall) begin
            pc_next = pc_out;
            instr_next = instr_out;
        end
        else begin
            pc_next = pc_in;
            instr_next = instr_in;
        end
    end

    always_ff @(posedge clk) begin
        if(rst || trigger) begin
            pc_out <= 32'hBFC00000;
            instr_out <= 32'h00000013;
        end
        else begin
            pc_out <= pc_next;
            instr_out <= instr_next;
        end
    end
 
endmodule
