#include "base_testbench.h"
#include <iostream>

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class InstructionMemoryTestbench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        top->pc = 0;
        // output: out
    }
};

TEST_F(InstructionMemoryTestbench, IM0WorksTest)
{
    top->pc = 0;
    top->eval();
    std::cout<<"HERE:"<<top->instr<<std::endl;
    EXPECT_EQ(top->instr, 1313556549);
    
}

TEST_F(InstructionMemoryTestbench, IM1WorksTest)
{
    top->pc = 5;
    top->eval();
    std::cout<<"HERE:"<<top->instr<<std::endl;
    EXPECT_EQ(top->instr, 567354312);
    
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