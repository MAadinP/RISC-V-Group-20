/*
 *  Verifies the results of the mux, exits with a 0 on success.
 */

#include "base_testbench.h"

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class SignExtendTestbench : public BaseTestbench
{
protected:
    void initializeInputs() override
    {
        top->imm_sel = 0;
        top->instr = 2761629821;
        // output: out
    }
};

TEST_F(SignExtendTestbench, Sign_ext0WorksTest)
{
    top->imm_sel = 0;
    top->instr = 2761629821;

    top->eval();

    EXPECT_EQ(top->imm_ext, 4294965833);
}

TEST_F(SignExtendTestbench, Sign_ext1WorksTest)
{
    top->imm_sel = 1;
    top->instr = 2761629821;

    top->eval();

    EXPECT_EQ(top->imm_ext, 4294965824);
}

TEST_F(SignExtendTestbench, Sign_ext2WorksTest)
{
    top->imm_sel = 2;
    top->instr = 2761629821;

    top->eval();

    EXPECT_EQ(top->imm_ext, 4294963776);
}

TEST_F(SignExtendTestbench, Sign_ext3WorksTest)
{
    top->imm_sel = 3;
    top->instr = 2761629821;

    top->eval();

    EXPECT_EQ(top->imm_ext, 2761629696);
}

TEST_F(SignExtendTestbench, Sign_ext4WorksTest)
{
    top->imm_sel = 4;
    top->instr = 2761629821;

    top->eval();

    EXPECT_EQ(top->imm_ext, 4294650440);
}

TEST_F(SignExtendTestbench, Sign_ext5WorksTest)
{
    top->imm_sel = 5;
    top->instr = 2761629821;

    top->eval();

    EXPECT_EQ(top->imm_ext, 0);
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