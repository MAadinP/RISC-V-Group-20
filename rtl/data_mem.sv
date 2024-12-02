module data_memory #(
    parameter ADDR_WIDTH = 10, // Address width 
    parameter DATA_WIDTH = 32  // Data width
) (
    input logic                           clk, // Clock 
    input logic                           rst, // Reset 
    input logic                      mem_read, // Read 
    input logic                     mem_write, // Write 
    input logic [ADDR_WIDTH-1:0]         addr, // Memory address
    input logic [DATA_WIDTH-1:0]   write_data, // Data to be written
    output logic [DATA_WIDTH-1:0]   read_data  // Data read from memory
);
    // Memory array
    logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];

    // Reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            int i;
            for (i = 0; i < (1 << ADDR_WIDTH); i = i + 1) begin
                memory[i] <= '0;
            end
        end
    end

    // Read
    always_ff @(posedge clk) begin
        if (mem_read) begin
            read_data <= memory[addr];
        end
    end

    // Write
    always_ff @(posedge clk) begin
        if (mem_write) begin
            memory[addr] <= write_data;
        end
    end
endmodule
