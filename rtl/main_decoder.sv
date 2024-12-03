module main_decoder #(
    input  logic [6:0] opcode,
    output logic       Reg_write, Mem_read, Mem_write, Branch,
    output logic [1:0] ALU_Op,
    output logic [1:0] PCSrc,
    output logic [2:0] ImmSrc
);

    always_comb begin
        Reg_write = 0; 
        Mem_read = 0; 
        Mem_write = 0; 
        Branch = 0;
        ALU_Op = 2'b00; 
        PCSrc = 2'b00; 
        ImmSrc = 3'b000;

        case (opcode)
            7'b0110011: begin // R-Type
                Reg_write = 1; 
                ALU_Op = 2'b10; // Multiplication support included here
            end
            7'b0000011: begin // I-Type (Load)
                Reg_write = 1; 
                Mem_read = 1; 
                ALU_Op = 2'b00; 
                ImmSrc = 3'b000;
            end
            7'b0010011: begin // I-Type (ALU)
                Reg_write = 1;
                ALU_Op = 2'b10; 
                ImmSrc = 3'b000;
            end
            7'b0100011: begin // S-Type (Store)
                Mem_write = 1; 
                ALU_Op = 2'b00; 
                ImmSrc = 3'b001;
            end
            7'b1100011: begin // B-Type (Branch)
                Branch = 1; 
                ALU_Op = 2'b01; 
                PCSrc = 2'b01;
                ImmSrc = 3'b010;
            end
            7'b1101111: begin // J-Type (Jump)
                Reg_write = 1; 
                PCSrc = 2'b10; 
                ImmSrc = 3'b011;
            end
        endcase
    end
endmodule
