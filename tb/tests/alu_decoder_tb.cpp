#include "Valu_decoder.h" // verilator model
#include "testbench.h"    // custom base testbench
#include "gtest/gtest.h"
#include <iostream>

Valu_decoder *top;          // alu_decoder module
VerilatedVcdC *tfp;         // vcd trace
unsigned int ticks = 0;

class ALUDecoderTestbench : public Testbench
{
protected:
    void initializeInputs() override
    {
        top->func3 = 0;
        top->alu_op = 0;
        top->func7_5_0 = 0;
        // default inputs set for sim start
    }
};

TEST_F(ALUDecoderTestbench, BasicOperationTest)
{
    // test basic alu_ops w/ fixed func3 + func7_5_0
    int alu_ops[] = {0b00, 0b01, 0b10};
    int expected_ctrl[] = {0b00000, 0b00001, 0b00000}; // expected results for alu_op cases

    for (int i = 0; i < 3; i++) // iterate alu_op cases
    {
        top->alu_op = alu_ops[i];
        top->func3 = 0b000; // func3 = ADD (irrelevant for alu_op = 0/1)
        top->func7_5_0 = 0b00;
        top->eval();
        EXPECT_EQ(top->alu_ctrl, expected_ctrl[i]);
    }
}

TEST_F(ALUDecoderTestbench, Func3VariationsTest)
{
    // test all func3 values w/ alu_op = 2'b10
    top->alu_op = 0b10;

    for (int func3 = 0; func3 < 8; func3++) // test all 3-bit func3 values
    {
        top->func3 = func3;
        top->func7_5_0 = 0b00; // default func7_5_0

        top->eval();

        // simple checks for func3-specific ctrl codes
        if (func3 == 0b000) // ADD
            EXPECT_EQ(top->alu_ctrl, 0b00000);
        else if (func3 == 0b001) // SLL
            EXPECT_EQ(top->alu_ctrl, 0b00010);
        // add other cases as needed
    }
}

TEST_F(ALUDecoderTestbench, MultiplicationCheck)
{
    // test func7_5_0 multiplier flag
    top->alu_op = 0b10; // only alu_op = 10 checks func3/func7

    int func7_cases[] = {0b00, 0b01}; // ADD / MUL
    int expected_ctrl[] = {0b00000, 0b01010}; // ctrl for ADD / MUL

    for (int i = 0; i < 2; i++)
    {
        top->func3 = 0b000; // func3 = ADD/MUL
        top->func7_5_0 = func7_cases[i];
        top->eval();
        EXPECT_EQ(top->alu_ctrl, expected_ctrl[i]);
    }
}

int main(int argc, char **argv)
{
    top = new Valu_decoder;
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
