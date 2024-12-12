module control_unit #(
    parameter FUNC7_WIDTH = 7,
    parameter FUNC3_WIDTH = 3,
    parameter OPCODE_WIDTH = 7
) (
    input   logic [FUNC3_WIDTH-1:0]     func_3,
    input   logic [FUNC7_WIDTH-1:0]     func_7,
    input   logic [OPCODE_WIDTH-1:0]    opcode,

    output  logic [2:0]                 sign_extend_sel,//also used for hazard unit
    output  logic [2:0]                 branch_sel,
    output  logic [1:0]                 write_back_mux,
    output  logic                       reg_write_en,
    output  logic [4:0]                 alu_sel,
    output  logic [2:0]                 data_mem_write_en //the size will be changed later for load/store half and byte
);

    always_comb begin
        case(opcode)
            7'b0110111: begin //LUI
                sign_extend_sel = 3'b011;
                branch_sel = 3'b000;
                write_back_mux = 2'b10;
                reg_write_en =  1'b1;
                alu_sel = 5'b00000; //doesn't matter so will default to add in code
                data_mem_write_en = 3'b010;
            end
            7'b0010111: begin //ALUIPC
                sign_extend_sel = 3'b011;
                branch_sel = 3'b000;
                write_back_mux = 2'b01;
                alu_sel = 5'b00000;
                reg_write_en =  1'b1;
                data_mem_write_en = 3'b010;
            end
            7'b1101111: begin //JAL
                sign_extend_sel = 3'b100;
                branch_sel = 3'b001;
                write_back_mux = 2'b00;
                alu_sel = 5'b00000;
                reg_write_en =  1'b1;
                data_mem_write_en = 3'b010;
            end
            7'b1100111: begin //JALR
                if(func_3 == 3'b000) begin
                    sign_extend_sel = 3'b000;
                    branch_sel = 3'b001;
                    write_back_mux = 2'b00;
                    alu_sel = 5'b00000;
                    reg_write_en =  1'b1;
                    data_mem_write_en = 3'b010;
                end
                else begin
                    sign_extend_sel = 3'b111; //Sets sign extend result to 0
                    branch_sel = 3'b000;
                    write_back_mux = 2'b01;
                    alu_sel = 5'b00000;
                    reg_write_en =  1'b0;
                    data_mem_write_en = 3'b010;
                end
            end
            7'b1100011: begin //Branch
                sign_extend_sel = 3'b010;
                write_back_mux = 2'b00;
                alu_sel = 5'b00000;
                reg_write_en =  1'b0;
                data_mem_write_en = 3'b010;
                case(func_3)
                    3'b000: branch_sel = 3'b010; //BEQ
                    3'b001: branch_sel = 3'b011; //BNE
                    3'b100: branch_sel = 3'b100; //BLT
                    3'b101: branch_sel = 3'b101; //BGE
                    3'b110: branch_sel = 3'b110; //BLTU
                    3'b111: branch_sel = 3'b111; //BGEU
                    default: branch_sel = 3'b000;
                endcase
            end
            7'b0000011:begin//Load
                branch_sel = 3'b000;
                alu_sel = 5'b00000;
                case(func_3)
                    3'b000:begin //LB
                        write_back_mux = 2'b11;
                        sign_extend_sel = 3'b000;
                        reg_write_en =  1'b1;
                        data_mem_write_en = 3'b000;
                    end
                    3'b001:begin //LH
                        write_back_mux = 2'b11;
                        sign_extend_sel = 3'b000;
                        reg_write_en =  1'b1;
                        data_mem_write_en = 3'b001;
                    end
                    3'b010:begin //LW
                        write_back_mux = 2'b11;
                        sign_extend_sel = 3'b000;
                        reg_write_en =  1'b1;
                        data_mem_write_en = 3'b010;
                    end
                    3'b100:begin //LBU
                        write_back_mux = 2'b11;
                        sign_extend_sel = 3'b000;
                        reg_write_en =  1'b1;
                        data_mem_write_en = 3'b011;
                    end
                    3'b101:begin //LHU
                        write_back_mux = 2'b11;
                        sign_extend_sel = 3'b000;
                        reg_write_en =  1'b1;
                        data_mem_write_en = 3'b100;
                        end
                    default:begin
                        write_back_mux = 2'b10;
                        sign_extend_sel = 3'b111;
                        reg_write_en =  1'b0;
                        data_mem_write_en = 3'b010;
                    end
                endcase
            end
            7'b0100011: begin //Store
                branch_sel = 3'b000;
                write_back_mux = 2'b10;
                alu_sel = 5'b00000;
                reg_write_en =  1'b0;
                case(func_3)
                    3'b000: begin //SB
                        sign_extend_sel = 3'b001;
                        data_mem_write_en = 3'b101;
                    end
                    3'b001: begin //SH
                        sign_extend_sel = 3'b001;
                        data_mem_write_en = 3'b110;
                    end
                    3'b010: begin //SW
                        sign_extend_sel = 3'b001;
                        data_mem_write_en = 3'b111;
                    end
                    default: begin
                        sign_extend_sel = 3'b111;
                        data_mem_write_en = 3'b010;
                    end
                endcase
            end
            7'b0010011: begin //I-type alu operations
                sign_extend_sel = 3'b000;
                branch_sel = 3'b000;
                write_back_mux = 2'b01;
                data_mem_write_en = 3'b010;
                case(func_3)
                    3'b000: begin //ADDI
                        alu_sel = 5'b00000;
                        reg_write_en = 1'b1;
                    end
                    3'b001: begin //SLLI
                        if(func_7 == 7'b0000000)begin
                            alu_sel = 5'b00010;
                            reg_write_en = 1'b1;
                        end
                        else begin
                            alu_sel = 5'b00000;
                            reg_write_en = 1'b0;
                        end
                    end
                    3'b010: begin //SLTI
                        alu_sel = 5'b00011;
                        reg_write_en = 1'b1;
                    end
                    3'b011: begin //SLTIU
                        alu_sel = 5'b00100;
                        reg_write_en = 1'b1;
                    end
                    3'b100: begin //XORI
                        alu_sel = 5'b00101;
                        reg_write_en = 1'b1;
                    end
                    3'b101: begin
                        if (func_7 == 7'b0000000)begin //SRLI
                            alu_sel = 5'b00110;
                            reg_write_en = 1'b1;
                        end
                        else if (func_7 == 7'b0100000)begin //SRAI
                            alu_sel = 5'b00111;
                            reg_write_en = 1'b1;
                        end
                        else begin
                            alu_sel = 5'b00000;
                            reg_write_en = 1'b0;
                        end
                    end
                    3'b110: begin //ORI
                        alu_sel = 5'b01000;
                        reg_write_en = 1'b1;
                    end
                    3'b111: begin //ANDI
                        alu_sel = 5'b01001;
                        reg_write_en = 1'b1;
                    end
                    default: begin 
                        alu_sel = 5'b0000;
                        reg_write_en = 1'b0;
                    end
                endcase
            end
            7'b0110011: begin //R-type alu instructions
                sign_extend_sel = 3'b101;
                branch_sel = 3'b000;
                write_back_mux = 2'b01;
                data_mem_write_en = 3'b010;

                if(func_7 == 7'b0000001)begin //multiply and divide extension
                    reg_write_en = 1'b1;
                    case(func_3)
                        3'b000: alu_sel = 5'b01010; //MUL
                        3'b001: alu_sel = 5'b01011; //MUH
                        3'b010: alu_sel = 5'b01100; //MULHSU
                        3'b011: alu_sel = 5'b01101; //MULHU
                        3'b100: alu_sel = 5'b01110; //DIV
                        3'b101: alu_sel = 5'b01111; //DIVU
                        3'b110: alu_sel = 5'b10000; //REM
                        3'b111: alu_sel = 5'b10001; //REMU
                        default: alu_sel = 5'b00000;
                    endcase
                end
                else begin //R-type alu instructions that aren't multiply
                    case(func_3)
                        3'b000: begin
                            if(func_7 == 7'b0000000)begin //ADD
                                reg_write_en = 1'b1;
                                alu_sel = 5'b00000;
                            end
                            else if (func_7 == 7'b0100000)begin //SUB
                                reg_write_en = 1'b1;
                                alu_sel = 5'b00001;
                            end
                            else begin
                                reg_write_en = 1'b0;
                                alu_sel = 5'b00000;
                            end
                        end
                        3'b001: begin
                            if(func_7 == 7'b0000000)begin //SLL
                                reg_write_en = 1'b1;
                                alu_sel = 5'b00010;
                            end
                            else begin
                                reg_write_en = 1'b0;
                                alu_sel = 5'b00000;
                            end
                        end
                        3'b010: begin
                            if(func_7 == 7'b0000000)begin //SLT
                                reg_write_en = 1'b1;
                                alu_sel = 5'b00011;
                            end
                            else begin
                                reg_write_en = 1'b0;
                                alu_sel = 5'b00000;
                            end
                        end
                        3'b011: begin
                            if(func_7 == 7'b0000000)begin //SLTU
                                reg_write_en = 1'b1;
                                alu_sel = 5'b00100;
                            end
                            else begin
                                reg_write_en = 1'b0;
                                alu_sel = 5'b00000;
                            end
                        end
                        3'b100: begin
                            if(func_7 == 7'b0000000)begin //XOR
                                reg_write_en = 1'b1;
                                alu_sel = 5'b00101;
                            end
                            else begin
                                reg_write_en = 1'b0;
                                alu_sel = 5'b00000;
                            end
                        end
                        3'b101: begin
                            if(func_7 == 7'b0000000)begin //SRL
                                reg_write_en = 1'b1;
                                alu_sel = 5'b00110;
                            end
                            else if (func_7 == 7'b0100000)begin //SRA
                                reg_write_en = 1'b1;
                                alu_sel = 5'b00111;
                            end
                            else begin
                                reg_write_en = 1'b0;
                                alu_sel = 5'b00000;
                            end
                        end
                        3'b110: begin
                            if(func_7 == 7'b0000000)begin //OR
                                reg_write_en = 1'b1;
                                alu_sel = 5'b01000;
                            end
                            else begin
                                reg_write_en = 1'b0;
                                alu_sel = 5'b00000;
                            end
                        end
                        3'b111: begin
                            if(func_7 == 7'b0000000)begin //AND
                                reg_write_en = 1'b1;
                                alu_sel = 5'b01001;
                            end
                            else begin
                                reg_write_en = 1'b0;
                                alu_sel = 5'b00000;
                            end
                        end
                        default: begin
                            reg_write_en = 1'b0;
                            alu_sel = 5'b00000;
                        end
                    endcase
                end
            end
            default:begin //nothing
                sign_extend_sel = 3'b101;
                branch_sel = 3'b000;
                write_back_mux = 2'b00;
                alu_sel = 5'b00000;
                reg_write_en =  1'b0;
                data_mem_write_en = 3'b010;
            end
        endcase 
    end

endmodule
