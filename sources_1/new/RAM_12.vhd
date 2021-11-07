----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 20.09.2021 14:30:56
-- Design Name: 
-- Module Name: RAM_12 - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--          RAM for 12 bit MCU 7 bit adress 
--                             11 bit data
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

entity RAM_12 is
    Port (
        ADR  : in  STD_LOGIC_VECTOR (6  downto 0);
        DI   : in  STD_LOGIC_VECTOR (11 downto 0);
        DO   : out STD_LOGIC_VECTOR (11 downto 0);
        LOAD : in STD_LOGIC;
        WE   : in STD_LOGIC;
        CLK  : in STD_LOGIC
     );
end RAM_12;

architecture rtl of RAM_12 is
---------------
    type ram_type is array (127 downto 0) of std_logic_vector (11 downto 0);
    signal data_s : ram_type;
---------------
begin

    process (CLK, LOAD, ADR, Di, data_s)
        
    begin
        if (LOAD = '1') then
        -------------LOAD-TEST-PROGRAM
        -- DATA 0 - 47 (0x2F)
        --               BINARY            HEX    OPCODE
            data_s(0) <= "001100110011"; --333
            data_s(1) <= "010001000100"; --444
            data_s(2) <= "000000000000"; --000
            data_s(3) <= "000000000000"; --000
            data_s(4) <= "000100010001"; --111
            data_s(5) <= "000001010101"; --055
        -- PROGRAM 48 - 127 (0x7F)
        --                BINARY          HEX    OPCODE
            data_s(48) <= "111100000000"; --F00  LOAD   A, 00
            data_s(49) <= "110000000001"; --C01  ADD    A, 01
            data_s(50) <= "000100000010"; --102  STORE  02, A  
            data_s(51) <= "000000000010"; --002  OUTPUT O, 02 
            data_s(52) <= "010000111000"; --438  JUMP   Z, 38
            data_s(53) <= "110100000010"; --D02  SUB    A, 02 
            data_s(54) <= "010001010101"; --455  JUMP   Z, 55 
            data_s(55) <= "001100000000"; --300  STOP
            data_s(56) <= "001100000000"; --300  STOP    
            data_s(85) <= "111100000100"; --F04  LOAD   A, 04 
            data_s(86) <= "110000000101"; --C05  ADD    A, 05  
            data_s(87) <= "000100000110"; --106  STORE  06, A
            data_s(88) <= "001100000000"; --300  STOP                  
        else
            if rising_edge(CLK) then
                if WE = '1' then
                    data_s(to_integer(unsigned(ADR))) <= DI; --write to RAM
                end if;
            end if;
        end if;
            DO <= data_s(to_integer(unsigned(ADR))); --read from ram                 
    end process;
end rtl;

