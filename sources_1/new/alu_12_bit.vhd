----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 16.09.2021 14:07:34
-- Design Name: 
-- Module Name: alu_12_bit - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      12-bit ALU
--   Dj | S2 S1 S0 | Funktion Fi      | Funktion Gi
--   D0 | 0  0  0  |  f0 = ai         |  g0 = 0
--   D1 | 0  0  1  |  f1 = ai-bi-ci   |  g1 = Bi+1
--   D2 | 0  1  0  |  f2 = ai nand bi |  g2 = 0
--   D3 | 0  1  1  |  f3 = ai+bi+ci   |  g3 = Ci+1
--   D4 | 1  0  0  |  f4 = ai         |  
--   D5 | 1  0  1  |  f5 = bi         |
--   D6 | 1  1  0  |  f6 = ai         |
--   D7 | 1  1  1  |  f7 = ai         |
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;




entity alu_12_bit is
    Port (
        A    : in  STD_LOGIC_VECTOR (11 downto 0);
        B    : in  STD_LOGIC_VECTOR (11 downto 0);
        SEL  : in  STD_LOGIC_VECTOR (2 downto 0);
        F    : out STD_LOGIC_VECTOR (11 downto 0);
        CIN  : in  STD_LOGIC;
        DOUT : out STD_LOGIC
    );
end alu_12_bit;

architecture rtl of alu_12_bit is

------------------Signal-declaration---------------
    signal a_int_s : std_logic_vector(11 downto 0);
    signal b_int_s : std_logic_vector(11 downto 0);
    signal c_int_s : std_logic;
    
    signal f_int_s : std_logic_vector(11 downto 0);

-----------------------------------
begin

    alu_p : process (SEL)
    begin
        a_int_s     <= A;
        b_int_s     <= B;
        c_int_s     <= CIN;
        f_int_s(11) <= '0'; 
        case SEL is
            when "000" => 
                --interconnect A
                f_int_s <= a_int_s;
            when "001" =>
                --substraction
                f_int_s <= a_int_s - b_int_s - c_int_s;
              --  f_int_s <= std_logic_vector(signed(a_int_s) - signed(b_int_s) - signed('0'& c_int_s));
            when "010" =>
                --NAND A,B
                f_int_s <= a_int_s nand b_int_s;
                f_int_s(11) <= '0';
            when "011" =>
                --addition
                f_int_s <= a_int_s + b_int_s + c_int_s;
              -- f_int_s <= std_logic_vector(signed(a_int_s) + signed(b_int_s) + signed('0'& c_int_s));
            when "100" =>
                --interconnect A
                f_int_s <= a_int_s;
            when "101" => 
                --interconnect B
                f_int_s <= b_int_s;
            when "110" =>
                --interconnect A
                f_int_s <= a_int_s;
            when "111" =>
                --interconnect A
                f_int_s <= a_int_s;
            when others => null;
        end case;
        --signal assignments
        F <= f_int_s;
        DOUT <= f_int_s(11);
    end process alu_p;

end rtl;
