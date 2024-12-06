module register_file #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5
) (
    input logic                     clk,
    input logic [ADDR_WIDTH-1:0]    address1,
    input logic [ADDR_WIDTH-1:0]    address2,
    input logic [ADDR_WIDTH-1:0]    address3,
    input logic                     write_enable3,
    input logic [DATA_WIDTH-1:0]    write_data3,
    output logic [DATA_WIDTH-1:0]   read_data1,
    output logic [DATA_WIDTH-1:0]   read_data2,
);

    logic [DATA_WIDTH-1:0] registers [2**ADDR_WIDTH-1:0];

    always_ff @(posedge clk) begin  // WRITING ON THE POSEDGE FOR SINGLE CYCLE
        if(write_enable3) registers[address3] <= write_data3; 
    end

    always_comb begin
        read_data1 = registers[address1];
        read_data2 = registers[address2];
    end

endmodule
