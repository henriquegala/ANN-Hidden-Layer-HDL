`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2026 10:30:35
// Design Name: 
// Module Name: ANN_Sigmoid
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


module ANN_Sigmoid(
    input logic clk, reset,
    input logic[15:0] x0, x1, x2, x3,
    input logic[15:0] w0, w1, w2, w3,
    input logic[15:0] b,
    output logic[15:0] y
    );
    
    logic signed[15:0] x0_s, x1_s, x2_s, x3_s;
    logic signed[15:0] w0_s, w1_s, w2_s, w3_s;
    logic signed[15:0] b_s;
    
    logic signed[15:0] x0_reg, x1_reg, x2_reg, x3_reg;
    logic signed[15:0] w0_reg, w1_reg, w2_reg, w3_reg;
    logic signed[15:0] b_reg, b_reg2;
    
    logic signed[31:0] mult0, mult1, mult2, mult3;
    
    logic signed[15:0] prod0_reg, prod1_reg, prod2_reg, prod3_reg;
    
    logic signed[15:0] soma_total;
    
    logic[7:0] addr_calc;
    
    logic[7:0] addr_reg;
    
    logic sat_low;
    logic sat_high;
    
    logic sat_low_reg;
    logic sat_high_reg;
    
    logic sat_low_reg2;
    logic sat_high_reg2;
    
    logic[15:0] rom_data;
    
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
            
            addr_reg <= '0;
            
            sat_low_reg <= '0;
            sat_high_reg <= '0;
            
            sat_low_reg2 <= '0;
            sat_high_reg2 <= '0;
            
        end else begin
            //1ºCICLO
            x0_reg <= x0_s;
            x1_reg <= x1_s;
            x2_reg <= x2_s;
            x3_reg <= x3_s;
            
            w0_reg <= w0_s;
            w1_reg <= w1_s;
            w2_reg <= w2_s;
            w3_reg <= w3_s;
            
            b_reg <= b_s;
            
            //2ºCICLO
            prod0_reg <= mult0[23:8];
            prod1_reg <= mult1[23:8];
            prod2_reg <= mult2[23:8];
            prod3_reg <= mult3[23:8];
            
            b_reg2 <= b_reg;
            
            //3ºCICLO
            addr_reg <= addr_calc;
            
            sat_low_reg <= sat_low;
            sat_high_reg <= sat_high;
            
            //4ºCICLO
            sat_low_reg2  <= sat_low_reg;
            sat_high_reg2 <= sat_high_reg;
        end
    end
             
    assign mult0 = x0_reg * w0_reg;
    assign mult1 = x1_reg * w1_reg;
    assign mult2 = x2_reg * w2_reg;
    assign mult3 = x3_reg * w3_reg;
    
    assign soma_total = prod0_reg + prod1_reg + prod2_reg + prod3_reg + b_reg2;
    
    assign addr_calc = (soma_total + 1024) >> 3;
    
    assign sat_low = soma_total <= -16'sd1024;
    assign sat_high = soma_total >= 16'sd1024;
    
    Sigmoid_ROM rom_inst (
        .clk(clk),
        .addr(addr_reg),
        .rom_data(rom_data)
        );
    
    assign y = (sat_low_reg2 == 1'b1) ? 16'd0 : (sat_high_reg2 == 1'b1 ? 16'h0100 : rom_data);
            
endmodule
