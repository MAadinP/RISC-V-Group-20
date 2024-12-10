#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "vbuddy.cpp" // include vbuddy code
#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env)
{
    int simcyc;     // SIMULATION CLOCK
    int tick;       // TWO TICKS FOR ONE CLOCK CYCLE

    Verilated::commandArgs(argc, argv);
    Vtop *top = new Vtop;
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;

    top->trace(tfp, 99);
    tfp->open("f1.vcd");

    if (vbdOpen() != 1) return (-1);
    vbdHeader("F1 Program");
    vbdSetMode(0);

    // INITIALISATIONS
    top->clk = 1;
    top->rst = 0;
    top->trigger = 1;
    
    // MAIN CLOCK CYCLES
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // DUMP LOOP
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        top->trigger = vbdFlag();
        vbdBar(top->a0 & 0xFF);

        if (Verilated::gotFinish() || (vbdGetkey() == 'q')) exit(0);
    }

    vbdClose();
    tfp->close();
    exit(0);
}
