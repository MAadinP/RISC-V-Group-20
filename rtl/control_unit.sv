module control_unit (
    input  logic [31:0] instruction,
    output logic       Reg_write, Mem_read, Mem_write, Branch,
    output logic [3:0] ALU_ctrl,
    output logic [1:0] PCSrc,
    output logic [2:0] ImmSrc
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [1:0] ALU_op;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    main_decoder u_main_decoder (
        .opcode(opcode),
        .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .Branch(Branch), .ALUOp(ALUOp), .PCSrc(PCSrc), .ImmSrc(ImmSrc)
    );

    alu_decoder u_alu_decoder (
        .ALUOp(ALUOp), .funct3(funct3), .funct7(funct7),
        .ALUCtrl(ALUCtrl)
    );

endmodule
