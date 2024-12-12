#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "vbuddy.cpp" // include vbuddy code

#define MAX_SIM_CYC 1000000

int main(int argc, char **argv, char **env)
{
    int simcyc;     // SIMULATION CLOCK
    int tick;       // TWO TICKS FOR ONE CLOCK CYCLE

    Verilated::commandArgs(argc, argv);
    Vtop *top = new Vtop;
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;

    top->trace(tfp, 99);
    tfp->open("PDF.vcd");

    if (vbdOpen() != 1) return (-1);
    vbdHeader("PDF Test");
    vbdSetMode(0);

    // INITIALISATIONS
    top->clk = 1;
    top->rst = 0;
    top->trigger = 0;

    // MAIN CLOCK CYCLES
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // DUMP LOOP
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk; // Toggle clock
            top->eval();         // Evaluate design
        }
        
        // Display bar graph (optional)
        if(top->a0 != 0) {
            vbdCycle(simcyc);
            vbdPlot(top->a0, 0, 255);
        }
        
        // Exit condition
        if (Verilated::gotFinish() || (vbdGetkey() == 'q')) break;
    }

    // Cleanup
    vbdClose();
    tfp->close();
    delete top;
    exit(0);
}
