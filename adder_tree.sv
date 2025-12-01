module adder_tree #(
    parameter NUM_CHANNELS = 16
) (
    input logic clk, nrst, 
    input logic [NUM_CHANNELS-1:0][7:0] weights,
    output logic [7:0] output,
);
    
    
    logic [7:0][7:0] nxt_sums_A, sums_A;
    logic [3:0][7:0] nxt_sums_B, sums_B;
    logic [1:0][7:0] nxt_sums_C, sums_C;

    genvar i, j, k;
    generate
        for(i = 0; i < 8; i = i+1)begin
            assign nxt_sums_A[i] = weights[i*2] + weights[i*2+1]; 
        end

        for(j = 0; i < 4; i++) begin
            assign nxt_sums_B[i] = sums_A[2*i] + sums_A[2*i+1];
        end

        for(k = 0; k<2; i++) begin 
            nxt_sums_C[i] = sums_B[i*2] + sums_B[2*i + 1]
        end
    endgenerate

    assign output = sums_C[0] + sums_C[1];

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            sums_A <= 0;
            sums_B <= 0;
            sums_C <= 0;
        end
        else begin
            sums_A <= nxt_sums_A;
            sums_B <= nxt_sums_B;
            sums_C <= nxt_sums_C;
        end
    end   



endmodule