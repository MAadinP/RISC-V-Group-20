#include "base_testbench.h"
#include <iostream>

Vmain_decoder *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class MainDecoderTestbench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        top->opcode = 0;
        top->func3 = 0;
    }
};

TEST_F(MainDecoderTestbench, RTypeTest)
{
    top->opcode = 0b0110011; // R-Type
    top->func3 = 0;
    top->eval();
    EXPECT_EQ(top->op1_src, 0);
    EXPECT_EQ(top->op2_src, 0);
    EXPECT_EQ(top->wb_src, 2);
    EXPECT_EQ(top->reg_write, 1);
    EXPECT_EQ(top->mem_write, 0);
    EXPECT_EQ(top->alu_op, 2);
    EXPECT_EQ(top->imm_src, 0);
    EXPECT_EQ(top->branch_src, 2);
    std::cout << "R-Type test passed: reg_write = " << top->reg_write << ", mem_write = " << top->mem_write << "\n";
}

TEST_F(MainDecoderTestbench, ITypeLoadTest)
{
    top->opcode = 0b0000011; // I-Type (Load)
    top->func3 = 3; // Special case
    top->eval();
    EXPECT_EQ(top->op1_src, 0);
    EXPECT_EQ(top->op2_src, 1);
    EXPECT_EQ(top->wb_src, 3);
    EXPECT_EQ(top->reg_write, 1);
    EXPECT_EQ(top->mem_write, 0);
    EXPECT_EQ(top->alu_op, 0);
    EXPECT_EQ(top->imm_src, 6);
    EXPECT_EQ(top->branch_src, 2);
    std::cout << "I-Type Load test passed: imm_src = " << top->imm_src << "\n";
}

TEST_F(MainDecoderTestbench, BranchTest)
{
    top->opcode = 0b1100011; // B-Type (Branch)
    top->func3 = 4;
    top->eval();
    EXPECT_EQ(top->op1_src, 1);
    EXPECT_EQ(top->op2_src, 1);
    EXPECT_EQ(top->wb_src, 0);
    EXPECT_EQ(top->reg_write, 0);
    EXPECT_EQ(top->mem_write, 0);
    EXPECT_EQ(top->alu_op, 1);
    EXPECT_EQ(top->imm_src, 2);
    EXPECT_EQ(top->branch_src, 4);
    std::cout << "Branch test passed: branch_src = " << top->branch_src << "\n";
}

int main(int argc, char **argv)
{
    top = new Vmain_decoder;
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
