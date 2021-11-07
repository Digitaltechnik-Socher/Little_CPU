----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 14.09.2021 10:51:33
-- Design Name: 
-- Module Name: register_12bit - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      12bit register with shift function
--       di | CLR | CE | S1 S0 | Qi         | Function 
--     -----------------------------------------------
--      x   | 1   | x  | x   x | Qi = 0     | erase
--      x   | 0   | 0  | x   x | Qi = konst | save 
--      D0  | 0   | 1  | 0   0 | qi = di    | load 
--      D1  | 0   | 1  | 0   1 | qi = di    | laod
--      QIM | 0   | 1  | 1   0 | qi = qi+1  | shift right
--      QIP | 0   | 1  | 1   1 | qi = qi-1  | shift left
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_12bit is
    Port ( 
        D   : in  STD_LOGIC_VECTOR (11 downto 0);
        SEL : in  STD_LOGIC_VECTOR (1 downto 0);
        Q   : out STD_LOGIC_VECTOR (11 downto 0);
        CLK : in  STD_LOGIC;
        CLR : in  STD_LOGIC;
        CE  : in  STD_LOGIC
    );
end register_12bit;

architecture rtl of register_12bit is

    signal q_reg_s : std_logic_vector(11 downto 0);
    
begin

    register_process : process (CLK, CLR)
    begin
        if CLR = '1' then
            q_reg_s <= (others => '0');
        elsif rising_edge(CLK) then
            if CE = '1' then
                case SEL is
                    when "00" =>
                        --load
                        q_reg_s <= D;
                    when "01" =>
                        --load
                        q_reg_s <= D;
                    when "10" =>
                        --shift right
                        q_reg_s(10 downto 0) <= q_reg_s(11 downto 1);
                        q_reg_s(11) <= '0';
                    when "11" =>
                        --shift left
                        q_reg_s(11 downto 1) <= q_reg_s(10 downto 0);
                        q_reg_s(0) <= '0';
                    when others =>
                        null;
                end case;
            end if;      
        end if;

        Q <= q_reg_s;

    end process;



  
end rtl;
