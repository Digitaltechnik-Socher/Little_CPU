----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 16.09.2021 09:06:47
-- Design Name: 
-- Module Name: address_register_12bit - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      12 bit register with CE
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity address_register_12bit is
    Port (
        Q   : out STD_LOGIC_VECTOR (11 downto 0);
        D   : in  STD_LOGIC_VECTOR (11 downto 0);
        CLK : in STD_LOGIC;
        CLR : in STD_LOGIC;
        CE  : in STD_LOGIC
     );
end address_register_12bit;

architecture rtl of address_register_12bit is



begin

    process (CLK, CLR)
    begin
        if CLR = '1' then
            Q <= (others => '0');     
        elsif rising_edge(CLK) then
            if CE = '1' then
                Q <= D;  
            end if;
            
        end if;
    end process;

 

 



end rtl;
