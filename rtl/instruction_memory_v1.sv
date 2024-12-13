module instruction_memory_v1 # (
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input   logic [ADDRESS_WIDTH-1:0]   pc,
    output  logic [DATA_WIDTH-1:0]      instr
);

logic [7:0] instruction_array [4095:0];
logic [11:0] addr;//changed to be byte addressable


initial begin
    $display("Loading rom.");
    $readmemh("program.hex", instruction_array);
end

assign addr = pc[11:0];
assign instr = {instruction_array[addr + 3], instruction_array[addr + 2], instruction_array[addr + 1], instruction_array[addr]};


endmodule
