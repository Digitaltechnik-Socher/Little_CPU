----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher   
-- Engineer: Socher
-- 
-- Create Date: 15.09.2021 10:50:01
-- Design Name: 
-- Module Name: mux_2_1 - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      2:1 Multiplexer
--      SEL | Q
--      ---------
--       0  | D0
--       1  | D1
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_1 is
    Port (
        Q   : out STD_LOGIC_VECTOR(11 downto 0);
        D0  : in  STD_LOGIC_VECTOR(11 downto 0);
        D1  : in  STD_LOGIC_VECTOR(11 downto 0);
        SEL : in  STD_LOGIC
     );
end mux_2_1;

architecture rtl of mux_2_1 is

begin

    p1 : process (SEL, D0, D1)
    begin
        case SEL is
            when '0' =>
                Q <= D0;
            when '1' =>
                q <= D1;
            when others =>
                null;   
        end case;      
    end process;


end rtl;
