`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2026 17:16:13
// Design Name: 
// Module Name: ANN_ReLU
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


module ANN_ReLU(
    input logic clk, reset,
    input logic[15:0] x0, x1, x2, x3, 
    input logic[15:0] w0, w1, w2 ,w3, 
    input logic[15:0] b,
    output logic[15:0] y    
    );
    
    logic signed[15:0] x0_s, x1_s, x2_s, x3_s;
    logic signed[15:0] w0_s, w1_s, w2_s, w3_s;
    logic signed[15:0] b_s;
    
    logic signed[15:0] x0_reg, x1_reg, x2_reg, x3_reg;
    logic signed[15:0] w0_reg, w1_reg, w2_reg, w3_reg;
    logic signed[15:0] b_reg, b_reg2;
    logic signed[15:0] y_reg;
    
    logic signed[31:0] mult0, mult1, mult2, mult3;
    
    logic signed[15:0] prod0_reg, prod1_reg, prod2_reg, prod3_reg;
    
    logic signed[15:0] soma_total;
    
    assign x0_s = $signed(x0);
    assign x1_s = $signed(x1);
    assign x2_s = $signed(x2);
    assign x3_s = $signed(x3);
    
    assign w0_s = $signed(w0);
    assign w1_s = $signed(w1);
    assign w2_s = $signed(w2);
    assign w3_s = $signed(w3);
    
    assign b_s = $signed(b);
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            x0_reg <= '0;
            x1_reg <= '0;
            x2_reg <= '0;
            x3_reg <= '0;
            
            w0_reg <= '0;
            w1_reg <= '0;
            w2_reg <= '0;
            w3_reg <= '0;
            
            prod0_reg <= '0;
            prod1_reg <= '0;
            prod2_reg <= '0;
            prod3_reg <= '0;
            
            b_reg <= '0; 
            b_reg2 <= '0;
            y_reg <= '0;
            
        end else begin
            //1º CICLO
            x0_reg <= x0_s;
            x1_reg <= x1_s;
            x2_reg <= x2_s;
            x3_reg <= x3_s;
            
            w0_reg <= w0_s;
            w1_reg <= w1_s;
            w2_reg <= w2_s;
            w3_reg <= w3_s;
            
            b_reg <= b_s;
            
            //2º CICLO
            prod0_reg <= mult0[23:8];
            prod1_reg <= mult1[23:8];
            prod2_reg <= mult2[23:8];
            prod3_reg <= mult3[23:8];
            
            b_reg2 <= b_reg;
            
            //3º CICLO
            y_reg <= soma_total;
        end
    end
    
    assign mult0 = x0_reg * w0_reg;
    assign mult1 = x1_reg * w1_reg;
    assign mult2 = x2_reg * w2_reg;
    assign mult3 = x3_reg * w3_reg;
    
    assign soma_total = prod0_reg + prod1_reg + prod2_reg + prod3_reg + b_reg2;
    
    assign y = (y_reg[15] == 1'b0) ? y_reg : 16'd0;
endmodule