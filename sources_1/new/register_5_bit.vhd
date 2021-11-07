----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.09.2021 09:14:25
-- Design Name: 
-- Module Name: register_5_bit - rtl
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

entity register_5_bit is
    Port (
        D   : in  STD_LOGIC_VECTOR(4 downto 0);
        Q   : out STD_LOGIC_VECTOR(4 downto 0);
        CLK : in  STD_LOGIC;
        CLR : in  STD_LOGIC;
        CE  : in  STD_LOGIC
     );
end register_5_bit;

architecture rtl of register_5_bit is


begin

    process (CLK, CLR)
    begin
        if CLR = '1' then
            Q <=  (others => '0');
        elsif rising_edge(CLK) then
            if CE = '1' then
                Q <= D;
            end if;
        end if;
    end process;


end rtl;
