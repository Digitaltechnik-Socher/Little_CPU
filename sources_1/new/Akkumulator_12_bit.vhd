----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 16.09.2021 14:42:04
-- Design Name: 
-- Module Name: Akkumulator_12_bit - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  12 bit Akkumulator
--  CLR | S2 S1 S0 | Function          | Meaning
--   1  |  x  x  x | A_Q = 0           | Delete register
--   0  |  0  0  0 | A_Q = konst       | Akku constant
--   0  |  0  0  1 | A_Q = A_Q-B-CIN   | Substraction
--   0  |  0  1  0 | A_Q = NAND(A_Q,B) | NAND function
--   0  |  0  1  1 | A_Q = A_Q+B+CIN   | Addition
--   0  |  1  0  0 | A_Q = konst       | Akku constant
--   0  |  1  0  1 | A_Q = B           | LOAD Akku
--   0  |  1  1  0 | A_Q = SHR(A_Q)    | Shift right
--   0  |  1  1  1 | A_Q = SHL(A_Q)    | Shift left
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Akkumulator_12_bit is
    Port (
        B    : in  STD_LOGIC_VECTOR (11 downto 0);
        Q    : out STD_LOGIC_VECTOR (11 downto 0);
        CIN  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLR  : in  STD_LOGIC;
        S0   : in  STD_LOGIC;
        S1   : in  STD_LOGIC;
        S2   : in  STD_LOGIC;
        OP_C : out STD_LOGIC;
        OP_S : out STD_LOGIC;
        OP_Z : out STD_LOGIC
     );
end Akkumulator_12_bit;

architecture rtl of Akkumulator_12_bit is

    component alu_12_bit is
        port (
            A    : in  STD_LOGIC_VECTOR (11 downto 0);
            B    : in  STD_LOGIC_VECTOR (11 downto 0);
            SEL  : in  STD_LOGIC_VECTOR (2 downto 0);
            F    : out STD_LOGIC_VECTOR (11 downto 0);
            CIN  : in  STD_LOGIC;
            DOUT : out STD_LOGIC
        );
    end component;
-------------------------------------
    component register_12bit is
        port (
            D   : in  STD_LOGIC_VECTOR (11 downto 0);
            SEL : in  STD_LOGIC_VECTOR (1 downto 0);
            Q   : out STD_LOGIC_VECTOR (11 downto 0);
            CLK : in  STD_LOGIC;
            CLR : in  STD_LOGIC;
            CE  : in  STD_LOGIC
        );
    end component;
---------------
    component Comparator_12_bit is
        port (
            A  : in STD_LOGIC_VECTOR;
            EQ : out STD_LOGIC
        );
    end component;
 
    signal a_q_s       : STD_LOGIC_VECTOR (11 downto 0);
    signal data_in_s   : STD_LOGIC_VECTOR (11 downto 0);
    signal carry_out_s : STD_LOGIC;
    signal vcc_s       : STD_LOGIC;
    signal z_1_s       : STD_LOGIC;
    signal a_s         : STD_LOGIC;
    signal b_s         : STD_LOGIC;
begin
-------------------------------------
    Q     <= a_q_s;
    vcc_s <= '1';
-------------------------------------
    alu : alu_12_bit
    port map (
        A       => a_q_s,
        B       => B,
        SEL(0)  => S0,
        SEL(1)  => S1,
        SEL(2)  => S2,
        F       => data_in_s,
        CIN     => CIN,
        DOUT    => carry_out_s
    );

    comp_a : Comparator_12_bit
    port map (
        A  =>  a_q_s,
        EQ => z_1_s
    );

    slr_reg : register_12bit
    port map (
        D      => data_in_s,
        SEL(0) => a_s,
        SEL(1) => b_s,
        Q      => a_q_s,
        CLK    => CLK,
        CLR    => CLR,
        CE     => vcc_s
);


-------------------------------------
-- register status flag ALU
--------------------------------------
    status_flag:process (CLK, CLR)
    begin
        if CLR = '1' then
            OP_S <= '0';
            OP_Z <= '0';
            OP_C <= '0';
        elsif rising_edge(CLK) then
            OP_S <= a_q_s(11);
            OP_Z <= z_1_s;
            OP_C <= carry_out_s;       
        end if;
    end process;

-------------------------------------
-- Combinatorical and
-------------------------------------
    a_s <= S2 and S0;

    b_s <= S2 and S1;

end rtl;
