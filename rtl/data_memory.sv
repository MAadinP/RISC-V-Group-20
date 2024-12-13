
  //sync  input   logic [DATA_WIDTH-1:0]      data_in,

module data_memory #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter BYTE_WIDTH = 8
) (
    input   logic                   clk,
// now in cache    input   logic                   write_enable,
    input   logic [2:0]             func3,
    input   logic [ADDR_WIDTH-1:0]  address,
// now in cache    input   logic [DATA_WIDTH-1:0]  write_data,
    input   logic [ADDR_WIDTH-1:0]      dirty_add,
    input   logic [DATA_WIDTH-1:0]      dirty_data,
    input   logic                       dirty_en,  
    output  logic [DATA_WIDTH-1:0]      new_data, //new to cache block
    output  logic [DATA_WIDTH-1:0]      data_out
);

    logic [BYTE_WIDTH-1:0] ram [32'h1FFFF:0];

    initial begin
        $display("Loading datamem from data.hex");
        $readmemh("data.hex", ram, 32'h00010000);
    end

    /*always_ff @(posedge clk) begin                                                  
        if(write_enable) begin
            case (func3) 
                3'h0: ram[address] <= write_data[7:0];                                  // SB                                
                3'h1: begin
                    ram[address] <= write_data[7:0];                                    // SH
                    ram[address+1] <= write_data[15:8]; 
                end
                3'h2: begin                                                             // SW
                    ram[address] <= write_data[7:0];                                     
                    ram[address+1] <= write_data[15:8];
                    ram[address+2] <= write_data[23:16];                                     
                    ram[address+3] <= write_data[31:24];
                end
                default: begin                                                             // SW default
                    ram[address] <= write_data[7:0];                                     
                    ram[address+1] <= write_data[15:8];
                    ram[address+2] <= write_data[23:16];                                     
                    ram[address+3] <= write_data[31:24];
                end
            endcase
             
        end
    end*/

    always_comb begin
        case (func3)
            3'h0: data_out = {{24{ram[address][7]}}, ram[address]};                                 // LB
            3'h1: data_out = {{16{ram[address+1][7]}}, ram[address+1], ram[address]};               // LH
            3'h2: data_out = {ram[address+3], ram[address+2], ram[address+1], ram[address]};        // LW
            3'h4: data_out = {{24{1'b0}}, ram[address]};                                            // LBU
            3'h5: data_out = {{16{1'b0}}, ram[address+1], ram[address]};                            // LHU
            default: data_out = 32'b0;
        endcase
    end

    always_comb begin
        if (dirty_en) begin
            ram[dirty_add] <= dirty_en[7:0];                                     
            ram[dirty_add+1] <= dirty_data[15:8];
            ram[dirty_add+2] <= dirty_data[23:16];                                     
            ram[dirty_add+3] <= dirty_data[31:24];
        end
    end

    assign new_data = {ram[address+3], ram[address+2], ram[address+1], ram[address]}

endmodule