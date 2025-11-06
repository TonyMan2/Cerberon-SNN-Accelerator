`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "pe_tb_interface.sv"
module pe_tb();

    parameter PERIOD =  10;
    logic clk = 1, nrst = 0;
    always #(PERIOD/2) clk++;




    pe_tb_interface pe_int(.clk(clk)); 
    pe dut(.clk(pe_int.clk), 
    .nrst(pe_int.nrst), 
    .index(pe_int.index), 
    .mode(pe_int.mode), 
    .accum_src(pe_int.accum_src), 
    .weight(pe_int.weight), 
    .vmem(pe_int.vmem),
    .vth(pe_int.vth),
    .ap_result(pe_int.ap_result), 
    .conv_result(pe_int.conv_result));

    task reset; 
            begin
                @(negedge clk);
                nrst = 0;
                @(negedge clk);
                nrst = 1;
            end
    endtask

    

    initial 
    begin
        $monitor($time, ("clk = %d", clk));

    end

    initial 
    begin
        $dumpfile("pe_tb.vcd");
        $dumpvars();
    end

endmodule