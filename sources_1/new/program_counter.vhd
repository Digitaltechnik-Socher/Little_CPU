----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 13.09.2021 09:45:16
-- Design Name: Operationswerk CPU
-- Module Name: program_counter - rtl
-- Project Name: CPU
-- Target Devices: ARTIX 7
-- Tool Versions: 
-- Description: 
--      n Bit Programcounter 
--      sel_in | Function 
--      -----------------------
--        00   | d_out <= d_out
--        01   | d_out + 1 
--        10   | d_out <= d_in
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



entity program_counter is
    Generic ( n : natural := 12);
    
    Port ( d_out   : out STD_LOGIC_VECTOR (n-1 downto 0);
           d_in    : in  STD_LOGIC_VECTOR (n-1 downto 0);
           sel_in  : in  STD_LOGIC_VECTOR (1 downto 0);
           clk_in  : in  STD_LOGIC;
           rst_in  : in  STD_LOGIC);
end program_counter;

architecture rtl of program_counter is

    constant NULL_V : STD_LOGIC_VECTOR (n-1 downto 0) := x"000";
    constant MAX_V  : STD_LOGIC_VECTOR (n-1 downto 0) := x"FFF";
    
    signal data_s  : STD_LOGIC_VECTOR (n-1 downto 0);
    
begin

    program_counter_p : process (rst_in, clk_in)
    begin
        if rst_in = '1' then 
            data_s <= NULL_V;
        elsif rising_edge(clk_in) then
            case sel_in is 
                when "00" => 
                    data_s <= data_s;
                when "01" => 
                    data_s <= std_logic_vector(unsigned(data_s)+ 1) ;
                when "10" => 
                    data_s <= d_in;
                when others => 
                    null;
            end case;
            if data_s > MAX_V then
                data_s <= NULL_V;
            end if;
        end if;
    end process program_counter_p;
    
    d_out <= data_s;
end rtl;
