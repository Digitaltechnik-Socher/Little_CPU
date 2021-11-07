----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2021 12:51:09
-- Design Name: 
-- Module Name: clk_mod - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Clk modualtion for simualtion. 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_mod is
    port (
        CLK   : in std_logic;
        CLR   : in std_logic;
        --clk/2
        CLK_1 : out std_logic;
        --clk/2 + 1/4 clk
        ClK_2 : out std_logic;
        --clk/2
        CLk_3 : out std_logic
    );
end clk_mod;

architecture rtl of clk_mod is

    signal clk_div : unsigned (3 downto 0);

begin

    clk_div_p : process (CLK, CLR)
    begin
        if CLR = '1' then
            clk_div <= (others => '0');       
        elsif rising_edge(CLK) then
            clk_div <= clk_div + 1;
        end if;
    end process;

    CLK_1 <= clk_div(0);
    ClK_2 <= clk_div(1);
    CLK_3 <= clk_div(0);



end rtl;
