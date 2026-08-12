`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2026 16:39:55
// Design Name: 
// Module Name: Hidden_Layer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import NN_types::*;

module Hidden_Layer(
    input logic clk, reset,
    input logic[15:0] x0, x1, x2, x3,
    input array_10x16 w0_array, w1_array, w2_array,w3_array, b_array,
    output array_10x16 y_array
    );
    
    generate
        genvar gv;
        for (gv=0; gv<10; gv++) begin
            ANN_Sigmoid neuron_inst ( //ANN_Sigmoid
                .clk(clk),
                .reset(reset),
                
                .x0(x0),
                .x1(x1),
                .x2(x2),
                .x3(x3),
               
                .w0(w0_array[gv]),
                .w1(w1_array[gv]),
                .w2(w2_array[gv]),
                .w3(w3_array[gv]),
                
                .b(b_array[gv]),
                
                .y(y_array[gv])
            );
        end    
    endgenerate
endmodule
