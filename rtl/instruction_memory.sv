module instruction_memory #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    /* verilator lint_off UNUSED */
    input   logic [ADDRESS_WIDTH-1:0]   pc,
    output  logic [DATA_WIDTH-1:0]      instr
);

logic [DATA_WIDTH-1:0] instruction_array [1023:0];//memory goes for 0xBFC00000 to 0xBFC00FFF, this is my way of cheating it
logic [9:0] addr;//made it word addressable instead of byte adressable as program.mem has to be reversed

initial begin
    $display("Loading rom.");
    $readmemh("program.mem", instruction_array);
end

assign addr = pc[11:2];
assign instr = instruction_array[addr];

endmodule
