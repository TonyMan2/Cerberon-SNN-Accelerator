module address_gen (
    input logic clk, nrst, count_cout, count_cin, count_fold, count_u, count_v, first_load, 
    //the count singnals are enable signals for each of the counters
    input logic [5:0] c_in, c_out, 
    input logic [2:0] num_folds, k_dim, //kdim is the kernel dimension
    input logic [4:0] stride_offset,
    input logic [4:0] channels_handled, 
    
    output logic [12:0] address,

);


logic [2:0] u
logic [3:0] v; 
logic [4:0] fold_channel_counter;
logic [5:0] total_channel_counter;  
logic [2:0] k_temp;
logic [7:0] fold_weight_counter; //counts how many weights have been fetched within a fold
logic [9:0] total_weight_counter; 

logic [9:0] channel_offset; 
assign k_temp = k_dim -1; 
always_ff @(posedge clk, negedge nrst)begin
    if(!nrst)begin
        u <= 0;
        v <=0;
        channel_offset <= 0; 
        fold_channel_counter <=0;
        total_channel_counter <=0;
        fold_weight_counter <=0;
        total_weight_counter <=0;
    end
    else begin
        if(first_load)
            channel_offset <= channels_handled 
        if(count_u) begin
            if(u == k_temp)begin
                u <= 0; 
                if(v == stride_offset - {1'b0,k_dim}) begin
                    v <= 0;
                    fold_channel_counter <= fold_channel_counter+1; //everytime v rollsover that means that all the weights for that channel were fetched
                    total_channel_counter <= total_channel_counter + 1; //same as fold_channel_counter but this time it will rollover when all the weights of every channel has been fetched

                end
                else
                    v <= v + {1'b0,k_dim}; 
            end
            else begin
                u <= c+1; 
                fold_weight_counter <= fold_weight_counter+1;
                total_weight_counter <= total_weight_counter + 1; 

            end
        end
        if(fold_channel_counter == channel_offset) begin 
            fold_channel_counter <= 0; 
            fold_weight_counter <= 0; 
        end
        if(total_channel_counter == c_in) begin
            total_channel_counter <= 0;
            total_weight_counter <= 0;
        end


        end
    end

assign address = {2'b0, total_weight_counter} + {4'b0, fold_weight_counter} + {8'b0,v} + {9'b0,u};
endmodule