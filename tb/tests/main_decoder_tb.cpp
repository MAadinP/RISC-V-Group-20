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
    }
};

TEST_F(MainDecoderTestbench, RTypeTest)
{
    top->opcode = 0b0110011; // R-Type
    top->eval();
    EXPECT_EQ(top->imm_sel, 0);
    EXPECT_EQ(top->op1sel, 0);
    EXPECT_EQ(top->op2sel, 0);
    EXPECT_EQ(top->read_write, 0);
    EXPECT_EQ(top->branch_jump, 0);
    EXPECT_EQ(top->reg_write_en, 1);
    std::cout << "R-Type test passed: reg_write_en = " << top->reg_write_en << "\n";
}

TEST_F(MainDecoderTestbench, ITypeLoadTest)
{
    top->opcode = 0b0000011; // I-Type (Load)
    top->eval();
    EXPECT_EQ(top->imm_sel, 0);
    EXPECT_EQ(top->op1sel, 0);
    EXPECT_EQ(top->op2sel, 1);
    EXPECT_EQ(top->read_write, 1);
    EXPECT_EQ(top->branch_jump, 0);
    EXPECT_EQ(top->reg_write_en, 1);
    std::cout << "I-Type Load test passed: imm_sel = " << top->imm_sel << "\n";
}

TEST_F(MainDecoderTestbench, STypeStoreTest)
{
    top->opcode = 0b0100011; // S-Type (Store)
    top->eval();
    EXPECT_EQ(top->imm_sel, 1);
    EXPECT_EQ(top->op1sel, 0);
    EXPECT_EQ(top->op2sel, 1);
    EXPECT_EQ(top->read_write, 2);
    EXPECT_EQ(top->branch_jump, 0);
    EXPECT_EQ(top->reg_write_en, 0);
    std::cout << "S-Type Store test passed: read_write = " << top->read_write << "\n";
}

TEST_F(MainDecoderTestbench, BTypeBranchTest)
{
    top->opcode = 0b1100011; // B-Type (Branch)
    top->eval();
    EXPECT_EQ(top->imm_sel, 2);
    EXPECT_EQ(top->op1sel, 0);
    EXPECT_EQ(top->op2sel, 0);
    EXPECT_EQ(top->read_write, 0);
    EXPECT_EQ(top->branch_jump, 1);
    EXPECT_EQ(top->reg_write_en, 0);
    std::cout << "B-Type Branch test passed: branch_jump = " << top->branch_jump << "\n";
}

TEST_F(MainDecoderTestbench, JTypeJumpTest)
{
    top->opcode = 0b1101111; // J-Type (Jump)
    top->eval();
    EXPECT_EQ(top->imm_sel, 3);
    EXPECT_EQ(top->op1sel, 0);
    EXPECT_EQ(top->op2sel, 0);
    EXPECT_EQ(top->read_write, 0);
    EXPECT_EQ(top->branch_jump, 2);
    EXPECT_EQ(top->reg_write_en, 1);
    std::cout << "J-Type Jump test passed: imm_sel = " << top->imm_sel << "\n";
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
