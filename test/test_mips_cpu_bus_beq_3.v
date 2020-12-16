//This is a generic test_case format that uses the RAM memory block, and only checks the final output of register v0
module mips_cpu_bus_tb;
    timeunit 1ns / 10ps;

    parameter TIMEOUT_CYCLES = 10000;
    parameter TESTCASE_ID = "beq_3";
    parameter INSTRUCTION = "beq";
    parameter RAM_INIT_FILE = "../test/1-hex/test_mips_cpu_bus_beq_3.hex.txt";
    //Use https://www.eg.bucknell.edu/~csci320/mips_web/ to convert assembly to hex
    /*
    Assembly:
    lui v1 0xbfc0
    lw t1 0x28(v1)
    lw t2 0x2c(v1)
    beq t2 t1 0x10
    nop (sll zero zero 0x0)
    lw v0 0x30(v1)
    jr zero
    nop

    0x50: lw v0 0x34(v1)
          jr zero

    */

    logic clk;
    logic reset;
    logic active;
    logic[31:0] register_v0;

    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    mips_cpu_bus cpuInst(clk, reset, active, register_v0, address, write, read, waitrequest, writedata, byteenable, readdata);

    RAM_32x4096 #(RAM_INIT_FILE) ramInst(clk, address, write, read, waitrequest, writedata, byteenable, readdata);

    initial begin
        clk=0;

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(2, "%s %s Fail Simulation did not finish within %d cycles.", TESTCASE_ID, INSTRUCTION, TIMEOUT_CYCLES);
    end


    initial begin
        reset <= 0;

        @(posedge clk);
        reset <= 1;

        @(posedge clk); //fetch
        reset <= 0;

        while (active) begin
          @(posedge clk);
        end

        assert(register_v0==32'h8ab09db9) else $fatal(1, "%s %s Fail Incorrect value %d stored in v0.", TESTCASE_ID, INSTRUCTION, register_v0);

        $display("%s %s Pass #Compares 2 random values", TESTCASE_ID, INSTRUCTION);
        $finish;
    end

endmodule