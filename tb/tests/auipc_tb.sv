module tb_auipc;

  // Clock and reset signals
  reg clk;
  reg reset;

  // Instantiate the DUT (Device Under Test)
  riscv_cpu dut (
    .clk(clk),
    .reset(reset)
  );

  initial begin
    // Initialize clock and reset
    clk = 0;
    reset = 1;
    #10 reset = 0;  // Release reset after some time

    // Load the instruction memory with auipc.s binary
    $readmemb("auipc.mem", dut.instruction_memory);

    // Wait for the program to execute
    #1000;

    // Check the results
    $display("t0 = %h", dut.register_file[5]); // t0 register
    $display("t1 = %h", dut.register_file[6]); // t1 register
    $display("t2 = %h", dut.register_file[7]); // t2 register

    // End the simulation
    $finish;
  end

  // Clock generation
  always #5 clk = ~clk;

endmodule
