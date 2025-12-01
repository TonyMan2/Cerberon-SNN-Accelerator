module pe #(parameter NUM_CHANNELS = 16) (
    input logic clk, nrst, mode, accum_src,
    input logic [NUM_CHANNELS-1:0] index, 
    input logic [7:0] weight,
    input logic vmem, vth,
    output logic [7:0] ap_result,
    output logic [8:0] conv_result
);
    
    logic [NUM_CHANNELS-1:0] index1;
    logic out_spike;
    logic [7:0] weight1, selected_data, masked_weight, 
    logic [NUM_CHANNELS-1:0][7:0]nxt_masked_weight;
    logic [7:0] integrate_sig, nxt_integrate_sig; 
    logic[7:0] running_sum, sum_of_weights; 

    always_ff @( posedge clk, negedge nrst ) begin
        if(!nrst) begin
            index1 <= 0;
            weight1 <= 0;
        end
        else begin
            index1 <= index;
            weight1 <= weight; 
            masked_weight <= nxt_masked_weight;

        end
    end


    genvar j;
    generate
        for(j = 0; j < NUM_CHANNELS; j++)begin
            assign nxt_masked_weight[j] = (index1[j])? weight1: 0;
        end
    endgenerate
    
    adder_tree at(.clk(clk),
                  .nrst(nrst),
                  .weights(selected_data),
                  .output(sum_of_weights));
    //if mode ==0 conv, else pooling
    always_comb begin 
        
        for(int i = 0; i < NUM_CHANNELS; i++ )begin
            selected_data[i] = mode ? {7'b0,index1[i]} | 8'b0: nxt_masked_weight[i];
        end
        
        
        running_sum = (sum_of_weights + signal)
        //then you need to select between output of adder and vmem
        nxt_integrate_sig = accum_src ? vmem: running_sum;

        ap_result = (mode)? integrate_sig: 0;
        out_spike = (!mode)? (integrate_sig <= vth)? 1'b0: 1'b1: 1'b0; 
        conv_result = (mode) ? 0: {integrate_sig, out_spike};  

        //if accum_src is 1 then use external input else use the running sum
        

        //Notes:
        //standard convolution
        // T= 0, initial vmem = 0, 
        // input the neuron state of each channel
        // add the weight to the running sum
        // if the sum is greater than the threshold then output a spike
        // if a spike is generated then the next timesteps vmem is Vth - running sum of the 
        // previous time step
        //if no spike is generated then the initial vmem is the conv_result[8:1] of the T-1 operation
        //accum_src will be 1 at the start of each time step. for layers with high amount
        //of channels then accum_src could be 0 for multiple phases.
        

    end
endmodule