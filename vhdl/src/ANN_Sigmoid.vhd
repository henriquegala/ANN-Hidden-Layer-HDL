----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.07.2026 12:18:46
-- Design Name: 
-- Module Name: ANN_Sigmoid - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ANN_Sigmoid is
    port (
        clk, reset : in std_logic;
        x0, x1, x2, x3 : in std_logic_vector(15 downto 0);
        w0, w1, w2, w3 : in std_logic_vector(15 downto 0);
        b : in std_logic_vector(15 downto 0);
        y : out std_logic_vector(15 downto 0)
    );
end ANN_Sigmoid;

architecture Behavioral of ANN_Sigmoid is
    signal x0_s, x1_s, x2_s, x3_s : signed(15 downto 0);
    signal w0_s, w1_s, w2_s, w3_s : signed(15 downto 0);
    signal b_s : signed(15 downto 0);
    
    signal x0_reg, x1_reg, x2_reg, x3_reg : signed(15 downto 0);
    signal w0_reg, w1_reg, w2_reg, w3_reg : signed(15 downto 0);
    signal b_reg, b_reg2 : signed(15 downto 0);
    
    signal mult0, mult1, mult2, mult3 : signed(31 downto 0);
    
    signal prod0_reg, prod1_reg, prod2_reg, prod3_reg : signed(15 downto 0);
    
    signal soma_total : signed(15 downto 0);
    
    signal addr_calc : std_logic_vector(7 downto 0);
    
    signal addr_reg : std_logic_vector(7 downto 0);
    
    signal sat_low : std_logic;
    signal sat_high : std_logic;
    
    signal sat_low_reg : std_logic;
    signal sat_high_reg : std_logic;
    
    signal sat_low_reg2 : std_logic;
    signal sat_high_reg2 : std_logic;
    
    signal rom_data : std_logic_vector(15 downto 0);
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
            
            addr_reg <= (others => '0');
            
            sat_low_reg <= '0';
            sat_high_reg <= '0';
            
            sat_low_reg2 <= '0';
            sat_high_reg2 <= '0';
        
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
            addr_reg <= addr_calc;
            
            sat_low_reg <= sat_low;
            sat_high_reg <= sat_high;
            
            sat_low_reg2 <= sat_low_reg;
            sat_high_reg2 <= sat_high_reg;
        end if;
    end process;
    
    mult0 <= x0_reg * w0_reg;
    mult1 <= x1_reg * w1_reg;
    mult2 <= x2_reg * w2_reg;
    mult3 <= x3_reg * w3_reg;
    
    soma_total <= prod0_reg + prod1_reg + prod2_reg + prod3_reg + b_reg2;
    
    addr_calc <= std_logic_vector(shift_right(soma_total + 1024, 3)(7 downto 0));

    sat_low <= '1' when soma_total <= to_signed(-1024, 16) else '0';
    sat_high <= '1' when soma_total >= to_signed(1024, 16) else '0';
    
    sigmoid_inst : entity work.Sigmoid_ROM
        port map (
            clk => clk,
            data => rom_data,
            addr => addr_reg
        );
        
    y <= (others => '0') when sat_low_reg2 = '1' else X"0100" when sat_high_reg2 = '1' else rom_data;
    
end Behavioral;
