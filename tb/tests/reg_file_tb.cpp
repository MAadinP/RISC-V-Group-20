/*
 *  Verifies the results of the mux, exits with a 0 on success.
 */

#include "base_testbench.h"
#include <iostream>

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class RegFileTestbench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        top->clk = 1;
        top->read_addr1 = 3;
        top->read_addr2 = 4;
        top->write_addr = 10;
        top->write_en = 0;
        top->write_data = 3217031168;
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

TEST_F(RegFileTestbench, RegFile0WorksTest)
{
    top->clk = 1;
    top->read_addr1 = 0;
    top->read_addr2 = 4;
    top->write_addr = 0;
    top->write_en = 1;
    top->write_data = 3217031168;

    bool success = true;

    for (int i = 0; i < 5; i++)
    {
        runSimulation(1);
        if (top->data1 != 0)
        {
            FAIL() << "the zero register does not stay and can be written to";
            success = false;
            break;
        }
    }
    if (success)
    {

        SUCCEED();
    }    
}

TEST_F(RegFileTestbench, RegFile1WorksTest)
{
    top->clk = 1;
    top->read_addr1 = 1;
    top->read_addr2 = 4;
    top->write_addr = 1;
    top->write_en = 1;
    top->write_data = 10;

    bool success = false;

    for (int i = 0; i < 5; i++)
    {
        runSimulation(1);
        top->write_data += 1;
        if (top->data1 == 14)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "writing and / or reading from address 1 doesn't work";
    }    
}

TEST_F(RegFileTestbench, RegFile2WorksTest)
{
    top->clk = 1;
    top->read_addr1 = 1;
    top->read_addr2 = 4;
    top->write_addr = 1;
    top->write_en = 0;
    top->write_data = 10;

    bool success = false;

    for (int i = 0; i < 5; i++)
    {
        runSimulation(1);
        top->write_en = 1;
        top->write_data += 1;
        if (top->data1 == 13)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "write_en not working correctly";
    }    
}

TEST_F(RegFileTestbench, RegFile3WorksTest)
{
    top->clk = 1;
    top->read_addr1 = 1;
    top->read_addr2 = 2;
    top->write_addr = 2;
    top->write_en = 1;
    top->write_data = 10;

    bool success = false;

    for (int i = 0; i < 5; i++)
    {
        runSimulation(1);
        top->write_data += 1;
        if (top->data2 == 14)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "writing and / or reading from address line 2 doesn't work";
    }    
}

TEST_F(RegFileTestbench, RegFile4WorksTest)
{
    top->clk = 1;
    top->read_addr1 = 1;
    top->read_addr2 = 4;
    top->write_addr = 1;
    top->write_en = 1;
    top->write_data = 10;

    bool success = false;

    for (int i = 0; i < 5; i++)
    {
        runSimulation(1);
        top->write_en = 0;
        runSimulation(10);


        if (top->data1 == 10)
        {
            SUCCEED();
            success = true;
            break;
        }
    }
    if (!success)
    {
        FAIL() << "the data in the registers does not persist";
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