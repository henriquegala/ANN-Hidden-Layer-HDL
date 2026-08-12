----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.07.2026 15:20:04
-- Design Name: 
-- Module Name: Hidden_Layer - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.NN_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Hidden_Layer is
    port(
        clk, reset : in std_logic;
        x0, x1, x2, x3 : in std_logic_vector(15 downto 0);
        w0_array, w1_array, w2_array, w3_array, b_array : in array_10x16;
        y_array : out array_10x16);
end Hidden_Layer;

architecture Structural of Hidden_Layer is
begin
    hidden_layer : for i in 0 to 9 generate
    begin
        neuron_inst : entity  work.ANN_ReLU --ANN_Sigmoid
            port map(
                clk => clk,
                reset => reset,
                
                x0 => x0,
                x1 => x1,
                x2 => x2,
                x3 => x3,
                
                w0 => w0_array(i),
                w1 => w1_array(i),
                w2 => w2_array(i),
                w3 => w3_array(i),
                
                b => b_array(i),
                
                y => y_array(i));
    end generate;
end Structural;
