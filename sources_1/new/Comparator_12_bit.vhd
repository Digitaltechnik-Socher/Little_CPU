----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 16.09.2021 14:42:04
-- Design Name: 
-- Module Name: Comparator_12_bit - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  12-bit comparator 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Comparator_12_bit is
Port (
    A  : in STD_LOGIC_VECTOR;
    EQ : out STD_LOGIC
);
end Comparator_12_bit;

architecture rtl of Comparator_12_bit is

begin

    process (A)
    begin
        if(A = "000000000000") then
            EQ <= '1';
        else
            EQ <= '0';
        end if;
    end process;
        

end rtl;
