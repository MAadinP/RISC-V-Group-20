module data_memory #(
    parameter  ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH =32
) (
    input   logic                       clk,
    input   logic [ADDRESS_WIDTH-1:0]   address,
    input   logic [DATA_WIDTH-1:0]      data_in,
    input   logic [2:0]                 write_en,
    output  logic [DATA_WIDTH-1:0]      data_out
);
    
    logic [7:0] ram [17'h1FFFF:0];
    //may need to look at truncating address to 17 bits to match memory size

    initial begin
        $readmemh("data.hex", ram, 17'h10000);
    end

    always_ff @(posedge clk) begin
        case(write_en)
            3'b101:begin //SB
                ram[address] <= data_in[7:0];
            end
            3'b110:begin //SH
                ram[address] <= data_in[7:0];
                ram[address + 1] <= data_in[15:8]; 
            end
            3'b111:begin //SW
                ram[address] <= data_in[7:0];
                ram[address + 1] <= data_in[15:8];
                ram[address + 2] <= data_in[23:16];
                ram[address + 3] <= data_in[31:24];
            end
            default: begin end
        endcase
    end

    always_comb begin
        case(write_en)
            3'b000: data_out = {{24{ram[address][7]}}, ram[address]};//LB
            3'b001: data_out = {{16{ram[address + 1][7]}}, ram[address + 1], ram[address]};//LH
            3'b010: data_out = {ram[address + 3], ram[address + 2], ram[address + 1], ram[address]};//LW
            3'b011: data_out = {24'b0, ram[address]};//LBU
            3'b100: data_out = {16'b0, ram[address + 1], ram[address]};//LHU
            default: data_out = '0;
        endcase
    end

endmodule