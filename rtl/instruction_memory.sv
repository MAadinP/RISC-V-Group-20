module instruction_memory #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 8
) (
    /* verilator lint_off UNUSED */
    input   logic [ADDRESS_WIDTH-1:0]   pc,
    output  logic [31:0]      instr
);

logic [DATA_WIDTH-1:0] instruction_array [2047:0];//memory goes for 0xBFC00000 to 0xBFC00FFF, this is my way of cheating it

initial begin
    $display("Loading rom.");
    $readmemh("program.hex", instruction_array);
end

// assign addr = pc[11:0];
assign instr = {instruction_array[pc+3], instruction_array[pc+2], instruction_array[pc+1], instruction_array[pc]};

endmodule
