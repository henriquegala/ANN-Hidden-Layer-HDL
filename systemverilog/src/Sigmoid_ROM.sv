`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2026 22:27:35
// Design Name: 
// Module Name: Sigmoid_ROM
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


module Sigmoid_ROM(
    input logic clk,
    input logic[7:0] addr,
    output logic[15:0] rom_data
    );
    
    logic[15:0] rom [0:255];
    
    initial begin
        $readmemh("sigmoid_values.mem", rom);
    end
    
    always_ff @(posedge clk) begin
        rom_data <= rom[addr];
    end
endmodule
