interface pe_tb_interface(input clk);

logic nrst;

logic index, mode, accum_src;
logic [7:0] weight, vmem, vth;
logic [7:0] ap_result;
logic [8:0] conv_result;
    
endinterface //pe_tb_interface()

