module reg_file # (
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 5
)(
    input   logic                       clk,
    input   logic [ADDRESS_WIDTH-1:0]   read_addr1,
    input   logic [ADDRESS_WIDTH-1:0]   read_addr2,
    input   logic [ADDRESS_WIDTH-1:0]   write_addr,
    input   logic                       write_en,
    input   logic [DATA_WIDTH-1:0]      write_data,
    output  logic [DATA_WIDTH-1:0]      data1,
    output  logic [DATA_WIDTH-1:0]      data2,
    output  logic [DATA_WIDTH-1:0]      a0

);
    logic [DATA_WIDTH-1:0] register_array [2**ADDRESS_WIDTH-1:0];

    //assign register_array[0] = '0;
    //used during testing
    initial register_array[0] = '0;

    always_comb begin
        data1 = register_array[read_addr1];
        data2 = register_array[read_addr2];
        a0 = register_array[10];
    end

    always_ff @(negedge clk) begin
        if(write_en && write_addr != '0)
            register_array[write_addr] <= write_data;
    end

endmodule
