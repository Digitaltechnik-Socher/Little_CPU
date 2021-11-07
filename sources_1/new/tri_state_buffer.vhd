----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 17.09.2021 09:14:25
-- Design Name: 
-- Module Name: tri_state_buffer - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Tri-state buffer active low
--      EN | X | Y
--       1 | 0 | 0
--       1 | 1 | 1
--       0 | 0 | Z
--       0 | 1 | Z
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state_buffer is
    Port (
        D  : in  STD_LOGIC_VECTOR (11 downto 0);
        Q  : out STD_LOGIC_VECTOR (11 downto 0);
        EN : in  STD_LOGIC
     );
end tri_state_buffer;

architecture rtl of tri_state_buffer is

begin

    Q <= D when (EN = '0') else "ZZZZZZZZZZZZ";

end rtl;
