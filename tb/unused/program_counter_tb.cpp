/*
 *  Verifies the results of the mux, exits with a 0 on success.
 */

#include "base_testbench.h"
#include <iostream>

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class PCTestBench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        top->clk = 1;
        top->rst = 0;
        top->pc_sel = 0;
        top->pc_target = 3217031168;
        // output: out
    }

    void runSimulation(int cycles = 1)
    {
        for (int i = 0; i < cycles; i++)
        {
            for (int clk = 0; clk < 2; clk++)
            {
                top->eval();
#ifndef __APPLE__
                tfp->dump(2 * ticks + clk);
#endif
                top->clk = !top->clk;
            }
            ticks++;

            if (Verilated::gotFinish())
            {
                exit(0);
            }
        }
    }

};

TEST_F(PCTestBench, PC0WorksTest)
{
    top->clk = 1;
    top->rst = 0;
    top->pc_sel = 0;
    top->pc_target = 3217031168;
    runSimulation(1);

    bool success = false;


    for (int i = 0; i < 5; i++)
    {
        runSimulation(1);
        std::cout<<"HERE: "<<top->pc<<std::endl;
        if (top->pc == 3217031180)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "pc_src = 0 / pc + 4 not working";
    }    
}

TEST_F(PCTestBench, PC1WorksTest)
{
    top->clk = 1;
    top->rst = 0;
    top->pc_sel = 0;
    top->pc_target = 100;

    bool success = false;

    for (int i = 0; i < 10; i++)
    {
        if(i == 8) top->pc_sel = 1; 
        runSimulation(1);
        std::cout<<"HERE: "<<top->pc<<" "<<i<<std::endl;
        if (top->pc == 100)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "pc_src = 1 / pc_target not working";
    }    
}

TEST_F(PCTestBench, PC2WorksTest)
{
    top->clk = 1;
    top->rst = 0;
    top->pc_sel = 0;
    top->pc_target = 100;

    bool success = false;

    for (int i = 0; i < 10; i++)
    {
        if(i == 8) top->rst = 1; 
        runSimulation(1);
        std::cout<<"HERE: "<<top->pc<<" "<<i<<std::endl;
        if (top->pc == 3217031168)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "pc reset not working";
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