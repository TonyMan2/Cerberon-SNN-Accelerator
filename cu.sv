module cu #(
    parameter NUM_PES = 4, parameter T_STEPS = 8
) (
    input logic [NUM_PES - 1:0][T_STEPS-1:0] input_spikes, //each pe will recieve 1 bit from the input vector
    input logic [NUM_PES - 1: 0] [7:0] weights,
    input logic mode, clk, nrst, accum_src,
    input logic [7:0] vth, 
    output logic [NUM_PES - 1:0] output_spikes,



);
logic [NUM_PES-1:0][7:0] ap_result;
logic[NUM_PES-1:0][8:0] conv_result;  
genvar i;
generate
    for(i = 0; i < NUM_PES; i++)begin
        pe A1(.clk(clk),
        .nrst(nrst), 
        .index(input_spikes[i]),
        .mode(mode),
        .accum_src(accum_src),
        .weight(weights[i]),
        .vmem(),
        .vth(vth),
        .ap_result(ap_result[i]),
        .conv_result(conv_result[i])
        ); 
    end
endgenerate
endmodule