#include "base_testbench.h"
#include <iostream>

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class Program2Testbench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        // Initialize inputs if necessary
        // For this program, no specific inputs need to be initialized
    }
};

TEST_F(Program2Testbench, TestLUI)
{
    top->eval();
    EXPECT_EQ(top->a0, /* expected value for a0 */);
}

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