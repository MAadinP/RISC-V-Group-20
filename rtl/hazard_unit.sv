module hazard_unit #(
    parameter ADDRESS_WIDTH = 5
    //didn't use but feel free to implement
) (
    //going to let the branch/jump unit do the flushing instead of hazard unit
    input   logic [5:0]     rs1,
    input   logic [5:0]     rs2,
    input   logic [5:0]     rd_in,
    input   logic [5:0]     exec_rd,
    input   logic [5:0]     mem_rd,
    input   logic           exec_lw,//the lw from the execute stage
    input   logic [2:0]     sign_extend_sel, //comes from control unit
    input   logic [6:0]     opcode,
    
    output  logic [5:0]     rd_out,
    output  logic           lw,//the lw going to the execute stage
    output  logic           mem_mux2,//this is the mux that decides whether the alu result or the lui result is used in forwarding
    output  logic           stall,//remember to connect to reset of execute reg
    output  logic [1:0]     alu_mux1_sel,
    output  logic [1:0]     alu_mux2_sel,
    output  logic [1:0]     branch_mux1_sel,
    output  logic [1:0]     branch_mux2_sel,
    output  logic           mem_mux, //1 will be forwarding
    output  logic           exec_mux //1 will be forwarding
);
    //not written concisely, feel free to change, was just made for testing purposes
    always_comb begin
        if(opcode == 7'b0000011)begin
            lw = 1'b1;
        end
        else begin
            lw = 1'b0;
        end
        
        if(opcode == 7'b0110111)begin
            mem_mux2 = 1'b1;
        end
        else begin
            mem_mux2 = 1'b0;
        end
        
        case(sign_extend_sel)
            3'b000: begin // I-type
                rd_out = rd_in;
                alu_mux2_sel = 2'b01;
                branch_mux1_sel = 2'b00;
                branch_mux2_sel = 2'b00;
                mem_mux = 1'b0;
                exec_mux = 1'b0;

                if(exec_lw && (rs1 != '0) && (rs1 == exec_rd))begin
                    stall = 1'b1;
                end
                else begin
                    stall = 1'b0;
                end

                if ((rs1 != '0) && (exec_rd == rs1))begin
                    alu_mux1_sel = 2'b10;
                end
                else if ((rs1 != '0) && (mem_rd == rs1))begin
                    alu_mux1_sel = 2'b11;
                end
                else begin
                    alu_mux1_sel = 2'b00;
                end
            end
            3'b001: begin // S-type
                //please for the love of god remember to get the wiring right for the mux, look at your notepad
                rd_out = '0;
                branch_mux1_sel = 2'b00;
                branch_mux2_sel = 2'b00;
                alu_mux2_sel = 2'b01;

                if (exec_lw && (rs1 != '0) && (exec_rd == rs1))begin
                    stall = 1'b1;
                end
                else begin
                    stall = 1'b0;
                end

                if((rs1 != '0) && (exec_rd == rs1)) begin
                    alu_mux1_sel = 2'b10;
                end
                else if ((rs1 != '0) && (mem_rd == rs1))begin
                    alu_mux1_sel = 2'b11;
                end
                else begin
                    alu_mux1_sel = 2'b00;
                end 

                if((rs2 != '0) && (exec_rd == rs2)) begin
                    mem_mux = 1'b1;
                    exec_mux = 1'b0;
                end
                else if((rs2 != '0) && (mem_rd == rs2)) begin
                    mem_mux = 1'b0;
                    exec_mux = 1'b1;
                end
                else begin
                    mem_mux = 1'b0;
                    exec_mux = 1'b0;
                end
            end
            3'b010: begin // B-type
                rd_out = '0;
                alu_mux1_sel = 2'b01;
                alu_mux2_sel = 2'b01;
                mem_mux = 1'b0;
                exec_mux = 1'b0;
                
                if (exec_lw && (rs1 != '0) && (rs1 == exec_rd))begin
                    stall = 1'b1;
                end
                else if (exec_lw && (rs2 != '0) && (rs2 == exec_rd)) begin
                    stall = 1'b1;
                end
                else begin
                    stall = 1'b0;
                end

                if ((rs1 != '0) && (rs1 == exec_rd))begin
                    branch_mux1_sel = 2'b01;
                end
                else if ((rs1 != '0) && (rs1 == mem_rd))begin
                    branch_mux1_sel = 2'b10;
                end
                else begin
                    branch_mux1_sel = 2'b00;
                end

                if ((rs2 != '0) && (rs2 == exec_rd))begin
                    branch_mux2_sel = 2'b01;
                end
                else if ((rs2 != '0) && (rs2 == mem_rd))begin
                    branch_mux2_sel = 2'b10;
                end
                else begin
                    branch_mux2_sel = 2'b00;
                end
            end
            3'b011: begin// U-type
                rd_out = rd_in;
                branch_mux1_sel = 2'b00;
                branch_mux2_sel = 2'b00;
                alu_mux1_sel = 2'b01;
                alu_mux2_sel = 2'b01;
                exec_mux = 1'b0;
                mem_mux = 1'b0;
                stall = 1'b0;
                //the alu is set to perform the aluipc instruction but for lui, just use the value
                //from the sign extend unit during write back
            end
            3'b100: begin // J-type
                rd_out = rd_in;
                alu_mux1_sel = 2'b01;
                alu_mux2_sel = 2'b01;
                branch_mux1_sel = 2'b00;
                branch_mux2_sel = 2'b00;
                //the control unit should pass a signal to the branch unit that a jump must happen
                exec_mux = 1'b0;
                mem_mux = 1'b0;
                stall = 1'b0;
            end
            3'b101: begin //R-type
                rd_out = rd_in;
                branch_mux1_sel = 2'b00;
                branch_mux2_sel = 2'b00;
                exec_mux = 1'b0;
                mem_mux = 1'b0;

                if (exec_lw && (rs1 != '0) && (rs1 == exec_rd))begin
                    stall = 1'b1;
                end
                else if (exec_lw && (rs2 != '0) && (rs2 == exec_rd)) begin
                    stall = 1'b1;
                end
                else begin
                    stall = 1'b0;
                end

                if ((rs1 != '0) && (rs1 == exec_rd))begin
                    alu_mux1_sel = 2'b10;
                end
                else if ((rs1 != '0) && (rs1 == mem_rd)) begin
                    alu_mux1_sel = 2'b11;
                end
                else begin
                    alu_mux1_sel = 2'b00;
                end

                if ((rs2 != '0) && (rs2 == exec_rd))begin
                    alu_mux2_sel = 2'b10;
                end
                else if ((rs2 != '0) && (rs2 == mem_rd)) begin
                    alu_mux2_sel = 2'b11;
                end
                else begin
                    alu_mux2_sel = 2'b00;
                end
            end
            default: begin
                rd_out = '0;
                branch_mux1_sel = 2'b00;
                branch_mux2_sel = 2'b00;
                alu_mux1_sel = 2'b00;
                alu_mux2_sel = 2'b01;
                exec_mux = 1'b0;
                mem_mux = 1'b0;
                stall = 1'b0;
                //default set to noop
            end
        endcase
    end
            
endmodule