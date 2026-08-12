----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.07.2026 02:47:05
-- Design Name: 
-- Module Name: ANN_ReLU - Behavioral
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
use IEEE.NUMERIC_STD.ALL ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ANN_ReLU is
    port (
    clk, reset : in std_logic;
    x0, x1, x2, x3 : in std_logic_vector(15 downto 0);
    w0, w1, w2, w3 : in std_logic_vector(15 downto 0);
    b : in std_logic_vector(15 downto 0);
    y : out std_logic_vector(15 downto 0));
end ANN_ReLU;

architecture Behavioral of ANN_ReLU is
    signal x0_s, x1_s, x2_s, x3_s : signed(15 downto 0);
    signal w0_s, w1_s, w2_s, w3_s : signed(15 downto 0);
    signal b_s : signed(15 downto 0);
    
    signal x0_reg, x1_reg, x2_reg, x3_reg : signed(15 downto 0);
    signal w0_reg, w1_reg, w2_reg, w3_reg : signed(15 downto 0);
    signal b_reg, b_reg2 : signed(15 downto 0);
    
    signal mult0, mult1, mult2, mult3 : signed(31 downto 0);
    
    signal prod0_reg, prod1_reg, prod2_reg, prod3_reg : signed(15 downto 0);
    
    signal soma_total : signed(15 downto 0);
    signal y_reg : signed(15 downto 0);
begin
    x0_s <= signed(x0);
    x1_s <= signed(x1);
    x2_s <= signed(x2);
    x3_s <= signed(x3);
    
    w0_s <= signed(w0);
    w1_s <= signed(w1);
    w2_s <= signed(w2);
    w3_s <= signed(w3);
    
    b_s <= signed(b);
    
    process(clk, reset)
    begin
        if reset = '1' then
            x0_reg <= (others => '0');
            x1_reg <= (others => '0');
            x2_reg <= (others => '0');
            x3_reg <= (others => '0');
            
            w0_reg <= (others => '0');
            w1_reg <= (others => '0');
            w2_reg <= (others => '0');
            w3_reg <= (others => '0');
            
            prod0_reg <= (others => '0');
            prod1_reg <= (others =>'0');
            prod2_reg <= (others => '0');
            prod3_reg <= (others => '0');
            
            b_reg <= (others => '0');
            b_reg2 <= (others => '0');
            y_reg <= (others => '0');
        
        elsif rising_edge(clk) then
            -- 1º CICLO
            x0_reg <= x0_s;
            x1_reg <= x1_s;
            x2_reg <= x2_s;
            x3_reg <= x3_s;
            
            w0_reg <= w0_s;
            w1_reg <= w1_s;
            w2_reg <= w2_s;
            w3_reg <= w3_s;
            
            b_reg <= b_s;
            
            --2º CICLO
            prod0_reg <= mult0(23 downto 8);
            prod1_reg <= mult1(23 downto 8);
            prod2_reg <= mult2(23 downto 8);
            prod3_reg <= mult3(23 downto 8);
            
            b_reg2 <= b_reg;
            
            --3º CICLO
            y_reg <= soma_total;
        end if;
    end process;
    
    mult0 <= w0_reg*x0_reg;
    mult1 <= w1_reg*x1_reg;
    mult2 <= w2_reg*x2_reg;
    mult3 <= w3_reg*x3_reg;
    
    soma_total <= prod0_reg+ prod1_reg + prod2_reg + prod3_reg + b_reg2;
    
    y <= std_logic_vector(y_reg) when y_reg(15) = '0' else (others => '0');
        
end Behavioral;