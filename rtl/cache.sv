module cache#(
    parameter MEMORY_WIDTH = 32, //
    parameter DATA_WIDTH   = 32, //
    parameter TAG_LENGTH   = 21, //
    parameter SET_LENGTH   = 9,
    parameter SET_WAYS     = 2, //512 SETS OF 2
    parameter CACHE_WIDTH  = 65, //{64}V + {63}D + {62}LR + {61:32}30 addy + {31:0} 32 data //61:32 = set{40:32} tag {61:41}
    parameter SET_NO       = 512
) (
    input   logic                       clk,
    input   logic                       reset,
    input   logic [2:0]                 funct3,
    input   logic [MEMORY_WIDTH-1:0]    mem_address, // 
    input   logic                       write_en,    // high when the processor writes to cache, low otherwise
    input   logic [DATA_WIDTH-1:0]      cpu_data,    // data straight from cpu for store word
    input   logic [DATA_WIDTH-1:0]      new_data,    // data from DRAM for normal misses
    output  logic                       hit, //ignore any output if hit == 0
    output  logic [DATA_WIDTH-1:0]      array_data, //output data for a hit (successful read)
    output  logic [MEMORY_WIDTH-1:0]    dirty_add,
    output  logic [DATA_WIDTH-1:0]      dirty_data,
    output  logic                       dirty_en,  //tells dram to write ddata at dadd
   // output  logic [MEMORY_WIDTH-1:0]    load_radd  //always req dram data from m_a, even if hit - reduces delay in case of miss - alt impls
);
    logic [TAG_LENGTH-1:0]      inp_tag = mem_address[MEMORY_WIDTH-1:11];
    logic [TAG_LENGTH-1:0]      w0_tag;//sab
    logic [TAG_LENGTH-1:0]      w1_tag;//from read
    logic                       v0;//comes from read, edited in load
    logic                       v1;//saa
    
    logic [SET_LENGTH:0]        array_add;
    logic [SET_LENGTH:0]        atwin_add;
    logic [SET_LENGTH-1:0]      set = mem_address[SET_LENGTH+1:2];//SET_LENGTH+(2-1):(0+2) Eliminating bottom 2 bits

    logic                       dirty_bit;
    logic [SET_LENGTH:0]        rep_add;    
    logic [SET_LENGTH:0]        rtwin_add;         
    logic [CACHE_WIDTH-1:0]     cache[SET_WAYS*SET_NO-1:0]; //V + D + LR + 30 addy + 32 data //127
    logic                       lru0 = cache[SET_WAYS*set][62];
    
    logic                       h0;
    logic                       h1;

    initial begin
        $display("Initialising cache...");
        for (int i = 0; i < SET_WAYS*SET_NO; i++) begin
            cache[i] = '0;
        end
        $display("Cache initialised");
    end
//Setup for "hit" comb logic
    assign w0_tag = cache [SET_WAYS*set][61:41]; 
    assign w1_tag = cache [1+SET_WAYS*set][61:41];
    assign v0 = cache [SET_WAYS*set][CACHE_WIDTH-1]; 
    assign v1 = cache [1+SET_WAYS*set][CACHE_WIDTH-1];
   // assign load_radd = mem_address; //FEEDS INTO A DIFFERENT PORT ON DRAM
//Hit
    always_comb begin
        if ((inp_tag == w0_tag) && (v0)) begin  //hit taken out instantly
            h0 = 1;
        end else begin
            h0 = 0;
        end
        if ((inp_tag == w1_tag) && (v1)) begin
            h1 = 1;
        end else begin
            h1 = 0;
        end
        if (h0 || h1)begin
            hit = 1;
        end else begin
            hit = 0;
        end
    end
//Set up read, hit write
//Always/Constantly asynch reads - can be discarded outside cache
    always_comb begin
        if(hit)begin
            array_add = SET_WAYS*set + !h0;
            atwin_add = SET_WAYS*set + h0;
            case(funct3)
                3'b000: begin
                    case(mem_address[1:0])
                        2'b00: array_data = {24{cache[array_add][7]},cache [array_add][7:0]};
                        2'b01: array_data = {24{cache[array_add][15]},cache [array_add][15:8]};
                        2'b10: array_data = {24{cache[array_add][23]},cache [array_add][23:16]};
                        2'b11: array_data = {24{cache[array_add][31]},cache [array_add][31:24]};
                        default: array_data = {24{cache[array_add][7]},cache [array_add][7:0]};
                    endcase
                end
                3'b001: begin
                    case(mem_address[1:0])
                        2'b00: array_data = {16{cache[array_add][15]},cache [array_add][15:0]};
                        2'b10: array_data = {16{cache[array_add][31]},cache [array_add][31:16]};
                        default: array_data = {16{cache[array_add][15]},cache [array_add][15:0]};
                    endcase
                end
                3'b100: begin
                    case(mem_address[1:0])
                        2'b00: array_data = {24{1'b0},cache [array_add][7:0]};
                        2'b01: array_data = {24{1'b0},cache [array_add][15:8]};
                        2'b10: array_data = {24{1'b0},cache [array_add][23:16]};
                        2'b11: array_data = {24{1'b0},cache [array_add][31:24]};
                        default: array_data = {24{1'b0},cache [array_add][7:0]};
                    endcase
                end
                3'b101: begin
                    case(mem_address[1:0])
                        2'b00: array_data = {16{1'b0},cache [array_add][15:0]};
                        2'b10: array_data = {16{1'b0},cache [array_add][31:16]};
                        default: array_data = {16{1'b0},cache [array_add][15:0]};
                    endcase
                end
                default: array_data = cache [array_add][DATA_WIDTH-1:0];
            endcase
        end
    end
//Set up replacing block, evacuate dirty data
    always_comb begin
        rep_add = SET_WAYS*set + lru0;//both are 0 at init, so top in set will be default
        rtwin_add = SET_WAYS*set + !lru0;
        dirty_bit = cache[rep_add][63];
        if(dirty_bit && !hit) begin //hit w is same mem Y, hit !w is read Y, !hit w is write other data X, !hit !w is load X
            dirty_add = {cache[rep_add][61:32],2'b00};
            dirty_data = cache[rep_add][31:0];
            dirty_en = 1;
        end else begin
            dirty_en = 0;
        end
    end
//  write with hit
    always_ff@(posedge clk) begin
        if (hit && write_en) begin
            case(funct3)
                3'b000: begin
                    case(mem_address[1:0])
                        2'b00: cache [array_add][7:0]   <= cpu_data [7:0];
                        2'b01: cache [array_add][15:8]  <= cpu_data [7:0];
                        2'b10: cache [array_add][23:16] <= cpu_data [7:0];
                        2'b11: cache [array_add][31:24] <= cpu_data [7:0];
                        default: cache [array_add][7:0] <= cpu_data [7:0];
                    endcase
                end
                3'b001: begin
                    case(mem_address[1:0])
                        2'b00: cache [array_add][15:0]   <= cpu_data [15:0];
                        2'b10: cache [array_add][31:16]  <= cpu_data [15:0];
                        default: cache [array_add][15:0] <= cpu_data [15:0];
                    endcase
                end
                default: cache [array_add][31:0] <= cpu_data;
            endcase
            cache [array_add][63] <= 1; // dirty
        end else if (!hit && write_en) begin 
            case(funct3)
                3'b000: begin
                    case(mem_address[1:0])
                        2'b00: cache [rep_add][7:0]   <= cpu_data [7:0];
                        2'b01: cache [rep_add][15:8]  <= cpu_data [7:0];
                        2'b10: cache [rep_add][23:16] <= cpu_data [7:0];
                        2'b11: cache [rep_add][31:24] <= cpu_data [7:0];
                        default: cache [rep_add][7:0] <= cpu_data [7:0];
                    endcase
                end
                3'b001: begin
                    case(mem_address[1:0])
                        2'b00: cache [rep_add][15:0]  <= cpu_data [15:0];
                        2'b10: cache [rep_add][31:16] <= cpu_data [15:0];
                        default: cache [rep_add][15:0]  <= cpu_data [15:0];
                    endcase
                end
                default: cache [rep_add][31:0] <= cpu_data;
            endcase
            cache [rep_add][63] <= 1; //dirty
        end
    end
//read, hit write lru
    always_ff@(posedge clk) begin
        if(hit) begin  
            cache [atwin_add][62] <= 0; //lru
            cache [array_add][62] <= 1; //lru
        end
    end
//load || miss write: replacing block made valid, lru, address updated   
    always_ff@(posedge clk) begin
        if(!hit)begin
            cache [rep_add][CACHE_WIDTH-1] <= 1;//valid
            cache [rtwin_add][62] <= 0;//lru
            cache [rep_add][62] <= 1; //lru
            cache [rep_add][61:32] <= mem_address[31:2];
        end
    end
//load from dram
    always_ff@(posedge clk) begin
        if (!hit && !write_en) begin
            cache [rep_add][63] <= 0;//undirtied
            cache [rep_add][31:0] <= new_data;
        end
    end
//reset makes all valid bits 0
    if (reset) begin
        for (int b = 0; b < SET_WAYS*SET_NO; b++) begin
            cache[b][64] = 1'b0;
        end
    end
endmodule
