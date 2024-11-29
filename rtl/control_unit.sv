module control_unit #(
    parameter OP_WIDTH = 7,
    parameter FUNC3_WIDTH = 3,
    parameter ALUCTRL_WIDTH = 3,
    parameter IMMSRC_WIDTH = 2 
) (
    input   logic [OP_WIDTH-1:0]        op,
    input   logic [FUNC3_WIDTH-1:0]     func3,
    input   logic [1:0]                 func7_5_0, // only need 5th and 0th bits of func 7 for single cycle
    input   logic                       zero,
    output  logic [ALUCTRL_WIDTH-1:0]   alu_control,
    output  logic [IMMSRC_WIDTH:0]      imm_src,
    output  logic                       pc_src,
    output  logic                       result_src,
    output  logic                       alu_src,
    output  logic                       mem_write,
    output  logic                       reg_write,
);

    main_decoder maindecoder(
        
    );

    alu_decoder aludecoder(

    );

endmodule
