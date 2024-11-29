module control_unit (
    input  logic [31:0] instruction,
    output logic       Reg_write, Mem_read, Mem_write, Branch,
    output logic [4:0] ALU_ctrl,  // Adjusted for 5-bit ALU control
    output logic [1:0] PCSrc,
    output logic [2:0] ImmSrc
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [1:0] ALU_Op;
    logic [1:0] funct7_5_0; // New signal for the 5th and 0th bits of funct7

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign funct7_5_0 = {funct7[5], funct7[0]}; // Extract the required bits

    main_decoder u_main_decoder (
        .opcode(opcode),
        .Reg_write(Reg_write), .Mem_read(Mem_read), .Mem_write(Mem_write),
        .Branch(Branch), .ALU_Op(ALU_Op), .PCSrc(PCSrc), .ImmSrc(ImmSrc)
    );

    alu_decoder #(
        .FUNC3_WIDTH(3),
        .ALUOP_WIDTH(2),
        .ALUCTR_WIDTH(5)
    ) u_alu_decoder (
        .func3(funct3),
        .alu_op(ALU_Op),
        .func7_5_0(funct7_5_0),
        .alu_ctrl(ALU_ctrl)
    );

endmodule
