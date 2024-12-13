/*
 *  Verifies the results of the mux, exits with a 0 on success.
 */

#include "base_testbench.h"
#include <iostream>

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class TopTestbench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        top->clk = 1;
        top->rst = 0;
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

TEST_F(TopTestbench, Top0WorksTest) //ADDI a0, x0, 5
{
    top->clk = 1;
    top->rst = 0;

    bool success = false;

    for (int i = 0; i < 100; i++)
    {
        runSimulation(1);
        std::cout<<"HERE: "<<top->a0<<std::endl;
        if (top->a0 == 5)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "top cannot addi";
    }    
}



TEST_F(TopTestbench, Top1WorksTest)
{
    top->clk = 1;
    top->rst = 0;

    bool success = false;

    for (int i = 0; i < 100; i++)
    {
        runSimulation(1);
        std::cout<<"HERE: "<<top->a0<<std::endl;
        if (top->a0 == 10)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "store/load/add doesn't work";
    }    
}

TEST_F(TopTestbench, Top2WorksTest)
{
    top->clk = 1;
    top->rst = 0;

    bool success = false;

    for (int i = 0; i < 100; i++)
    {
        runSimulation(1);
        std::cout<<"HERE: "<<top->a0<<std::endl;
        if (top->a0 == 13)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "stall and forwarding doesn't work";
    }    
}

TEST_F(TopTestbench, Top3WorksTest)
{
    top->clk = 1;
    top->rst = 0;

    bool success = false;

    for (int i = 0; i < 100; i++)
    {
        runSimulation(1);
        std::cout<<"HERE: "<<top->a0<<std::endl;
        if (top->a0 == 3)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "branch doesn't work";
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