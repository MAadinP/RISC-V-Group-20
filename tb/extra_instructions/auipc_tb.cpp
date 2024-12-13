#include "base_testbench.h"
#include <iostream>

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class Program1Testbench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        top->rst = 0;
        top->trigger = 1;
        // For this program, no specific inputs need to be initialized
    }
};

TEST_F(Program1Testbench, TestAUIPC)
{
    top->eval();
    bool success = false;

    for (int i = 0; i < 10000; i++)
    {
        top->trigger = 1;
        top->rst = 0;

        // Print the value of a0 for debugging
        std::cout << "top->a0 = " << std::hex << top->a0 << std::endl;

        if (top->a0 == 0x2000)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "Fail top->a0 is: " << top->a0 << std::endl;
    }
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
