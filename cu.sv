module cu #(
    parameter NUM_PES = 9, parameter NUM_CHANNELS = 16
) (
    input logic [NUM_PES - 1:0][NUM_CHANNELS-1:0] input_vectors, 
    input logic [NUM_PES - 1: 0] [7:0] weights,
    input logic mode, clk, nrst, enable //mode, enable, c_in, c_out will be stored in the control registers
    input logic [7:0] vth, 
    input logic [3:0] c_in, c_out, num_timesteps, 
    input logic [2:0] num_folds,
    output logic [NUM_PES - 1:0] output_spikes

);

state_t state, nxt_state;
logic [NUM_PES-1:0][NUM_CHANNELS - 1:0] in_vec;
logic [3:0] step_counter, next_step_counter; 
logic [NUM_PES-1:0][7:0] ap_result, vmem;
logic[NUM_PES-1:0][8:0] conv_result;

typedef enum [2:0] logic { IDLE, FOLD1, FOLD2, FOLD3, FOLD4} state_t;


always_ff @(posedge clk, negedge nrst) begin
    if(!nrst) begin
        state <= IDLE
        step_counter <= 0;
        
    end
    else begin
        state <= next_state;
        step_counter <= next_step_counter;
    end
end


always_comb begin
    in_vec = 0;
    next_state = state; 
    next_step_counter = step_counter; 
    
    case (state)
        IDLE: begin
            if(enable)
                next_state = FOLD1; 
        end 

        FOLD1: begin
            in_vec = input_vectors[NUM_PES-1:0][NUM_CHANNELS-1:0];
            if(num_folds > 1)begin
                next_state = FOLD2;
            end
            else  begin
                next_step_counter = counter + 1;
            end
            next_state = IDLE; 
        end
        FOLD2: begin
            in_vec = input_vectors[NUM_PES-1:0][NUM_CHANNELS*2-1:NUM_CHANNELS]; 
            if(num_folds > 2) begin
                next_state = FOLD3;
            end
            else  begin
                next_step_counter = counter + 1;
            end
            next_state = IDLE;
        end
        FOLD3: begin
            in_vec = input_vectors[NUM_PES-1:0][NUM_CHANNELS*3-1:NUM_CHANNELS*2];
            if(num_folds >3) begin
                next_state = FOLD4;
            end 
            else  begin
                next_step_counter = counter + 1;
            end
            next_state = IDLE;
        end
        FOLD4: begin
            in_vec = input_vectors[NUM_PES-1:0][NUM_CHANNELS*4-1:NUM_CHANNELS*3];
            next_state = IDLE;
            next_step_counter = step_counter + 1; 
            assert (num_folds > 4) $display("NUM_folds <=4");
            else   $error("NUM_folds exceeds what can be handled"); 
        end
    endcase
end


  
genvar i;
generate
    for(i = 0; i < NUM_PES; i++)begin
        //if its the first timestep then the membrane potential is 0 
        //else check if there was a spike (lsb of conve_result). 
        //if theres a spike take result - vth esle take conve_result.
        assign vem[i] = (step_counter) ? (conv_result[i][0]) ? conv_result[7:0]  - vth : conv_result[7:0] : 0; 
        
        pe A1(.clk(clk),
        .nrst(nrst), 
        .index(input_spikes[i]),
        .mode(mode),
        .accum_src(accum_src),
        .weight(weights[i]),
        .vmem(vem[i]),
        .vth(vth),
        .ap_result(ap_result[i]),
        .conv_result(conv_result[i])
        ); 
    end
endgenerate
endmodule