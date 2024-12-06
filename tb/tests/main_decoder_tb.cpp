#include "base_testbench.h"
#include <iostream>

Vdut *top;                 
VerilatedVcdC *tfp;        
unsigned int ticks = 0;    

class MainDecoderTestbench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        top->opcode = 0;   // Set the initial opcode input to 0
    }
};

// Test case for R-Type 
TEST_F(MainDecoderTestbench, RTypeInstruction)
{
    top->opcode = 0b0110011;   // Set opcode to R-Type (0x33 in hexadecimal)
    top->eval();               
    std::cout << "Opcode: R-Type" << std::endl;
    std::cout << "reg_write: " << top->reg_write << std::endl;

    EXPECT_EQ(top->reg_write, 1);     
    EXPECT_EQ(top->mem_write, 0);      
    EXPECT_EQ(top->alu_op, 2);         
};


// Test case for I-Type
TEST_F(MainDecoderTestbench, ITypeLoadInstruction)
{
    top->opcode = 0b0000011;   
    top->eval();                
    std::cout << "Opcode: I-Type (Load)" << std::endl;
    std::cout << "imm_src: " << top->imm_src << std::endl;

    EXPECT_EQ(top->reg_write, 1);      // reg_write should be 1
    EXPECT_EQ(top->mem_write, 0);      // mem_write should be 0
    EXPECT_EQ(top->imm_src, 0);        // imm_src should be 0
}

// Test case for S-Type 
TEST_F(MainDecoderTestbench, STypeStoreInstruction)
{
    top->opcode = 0b0100011;   
    top->eval();               
    std::cout << "Opcode: S-Type (Store)" << std::endl;

    EXPECT_EQ(top->reg_write, 0);      
    EXPECT_EQ(top->mem_write, 1);     
    EXPECT_EQ(top->imm_src, 1);        
}

// Test case for B-Type 
TEST_F(MainDecoderTestbench, BTypeBranchInstruction)
{
    top->opcode = 0b1100011;   
    top->eval();               
    std::cout << "Opcode: B-Type" << std::endl;

    EXPECT_EQ(top->branch, 1);        
    EXPECT_EQ(top->pc_src, 1);        
    EXPECT_EQ(top->alu_op, 1);        
}

// Main function to run all test cases
int main(int argc, char **argv)
{
    top = new Vdut;               
    tfp = new VerilatedVcdC;      

    Verilated::traceEverOn(true); 
    top->trace(tfp, 99);          
    tfp->open("waveform.vcd");    

    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();   

    top->final();                 
    tfp->close();                 

    delete top;                   
    delete tfp;                   

    return res;                   
}
