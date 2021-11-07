----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.09.2021 11:29:21
-- Design Name: 
-- Module Name: mux_4_1_12bit - rtl
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

entity mux_4_1_12bit is
    Port (
        SEL : in  STD_LOGIC_VECTOR (1  downto 0);
        D0  : in  STD_LOGIC_VECTOR (11 downto 0);
        D1  : in  STD_LOGIC_VECTOR (11 downto 0);
        D2  : in  STD_LOGIC_VECTOR (11 downto 0);
        D3  : in  STD_LOGIC_VECTOR (11 downto 0);
        Q   : out STD_LOGIC_VECTOR (11 downto 0)
     );
end mux_4_1_12bit;

architecture rtl of mux_4_1_12bit is

begin
    
    p1 : process(SEL, D0, D1, D2, D3)
    begin
        case SEL is 
         when "00" =>
            Q <= D0;   
         when "01" =>
            Q <= D1;
         when "10" =>
            Q <= D2;
         when "11" =>
            Q <= D3;
         when others => 
            null;
        end case;
    end process p1;


end rtl;
