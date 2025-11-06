module pe (
    input logic clk, nrst, index, mode, accum_src,
    input logic [7:0] weight, vmem, vth,
    output logic [7:0] ap_result,
    output logic [8:0] conv_result
);
    
    logic index1, out_spike;
    logic [7:0] weight1, selected_data, masked_weight, nxt_masked_weight,
    integrate_sig, nxt_integrate_sig; 
    

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

    assign nxt_masked_weight = (index1)? weight: 0;
    
    //if mode ==0 conv, else pooling
    always_comb begin 
        
        selected_data = mode ? {7'b0,index1} | 8'b0: nxt_masked_weight;

        //if accum_src is 1 then use external input else use the running sum
        nxt_integrate_sig = accum_src ? vmem: integrate_sig;

        ap_result = (mode)? integrate_sig: 0;
        out_spike = (integrate_sig <= vth)? 1'b0: 1'b1; 
        conv_result = (mode) ? 0: {integrate_sig, out_spike};

        
    end
endmodule