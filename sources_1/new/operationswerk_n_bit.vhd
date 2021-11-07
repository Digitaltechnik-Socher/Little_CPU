----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.09.2021 09:45:16
-- Design Name: 
-- Module Name: operationswerk_n_bit - rtl
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

entity operationswerk_n_bit is
    Port ( 
        SYSBUS   : inout STD_LOGIC_VECTOR (11 downto 0); -- system bus
        MR_D     : in    STD_LOGIC_VECTOR (11 downto 0); -- Memory register
        IPR_D    : in    STD_LOGIC_VECTOR (11 downto 0); -- Input register
        AR_Q     : out   STD_LOGIC_VECTOR (11 downto 0); -- Address register
        IR_Q     : out   STD_LOGIC_VECTOR (4  downto 0); -- instruction output
        OPR_Q    : out   STD_LOGIC_VECTOR (11 downto 0); -- output register
        INSTRUCT : in    STD_LOGIC_VECTOR (16 downto 0); -- Control instructions
        CLK      : in    STD_LOGIC;
        CLR      : in    STD_LOGIC;
        OP_C     : out   STD_LOGIC;
        OP_S     : out   STD_LOGIC;
        OP_Z     : out   STD_LOGIC
    );
end operationswerk_n_bit;

architecture rtl of operationswerk_n_bit is
    ----------------------------------------------------
    --Component declaration
    ----------------------------------------------------
    component program_counter is
        Generic ( 
            n : natural := 12
        );
        Port ( 
            d_out   : out STD_LOGIC_VECTOR (n-1 downto 0);
            d_in    : in  STD_LOGIC_VECTOR (n-1 downto 0);
            sel_in  : in  STD_LOGIC_VECTOR (1 downto 0);
            clk_in  : in  STD_LOGIC;
            rst_in  : in  STD_LOGIC
        );
    end component;
---------------------------
    component register_12bit is
        Port ( 
            D   : in  STD_LOGIC_VECTOR (11 downto 0);
            SEL : in  STD_LOGIC_VECTOR (1 downto 0);
            Q   : out STD_LOGIC_VECTOR (11 downto 0);
            CLK : in  STD_LOGIC;
            CLR : in  STD_LOGIC;
            CE  : in  STD_LOGIC
        );
    end component;
---------------------------
    component address_register_12bit is
        Port (
            Q   : out STD_LOGIC_VECTOR (11 downto 0);
            D   : in  STD_LOGIC_VECTOR (11 downto 0);
            CLK : in STD_LOGIC;
            CLR : in STD_LOGIC;
            CE  : in STD_LOGIC
         );
    end component;
 ---------------------------   
    component register_5_bit is
        port (
            D   : in  STD_LOGIC_VECTOR(4 downto 0);
            Q   : out STD_LOGIC_VECTOR(4 downto 0);
            CLK : in  STD_LOGIC;
            CLR : in  STD_LOGIC;
            CE  : in  STD_LOGIC
        );
    end component;
---------------------------   
    component mux_2_1 is
        port (
            Q   : out STD_LOGIC_VECTOR(11 downto 0);
            D0  : in  STD_LOGIC_VECTOR(11 downto 0);
            D1  : in  STD_LOGIC_VECTOR(11 downto 0);
            SEL : in  STD_LOGIC
        );
    end component;
 ---------------------------   
    component mux_4_1_12bit is
        port (
            SEL : in  STD_LOGIC_VECTOR (1  downto 0);
            D0  : in  STD_LOGIC_VECTOR (11 downto 0);
            D1  : in  STD_LOGIC_VECTOR (11 downto 0);
            D2  : in  STD_LOGIC_VECTOR (11 downto 0);
            D3  : in  STD_LOGIC_VECTOR (11 downto 0);
            Q   : out STD_LOGIC_VECTOR (11 downto 0)
        );
    end component;
 ---------------------------   
    component Akkumulator_12_bit is 
        port (
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
    end component;
 ---------------------------   

    component tri_state_buffer is
        port (
            D  : in  STD_LOGIC_VECTOR (11 downto 0);
            Q  : out STD_LOGIC_VECTOR (11 downto 0);
            EN : in  STD_LOGIC
        );
    end component;

    ----------------------------------------------------
    --Signal declaration declaration
    ----------------------------------------------------
    signal pc_q_s        : STD_LOGIC_VECTOR (11 downto 0);
    signal mux2_1a_q_s   : STD_LOGIC_VECTOR (11 downto 0);
    signal reg_stack_q_s : STD_LOGIC_VECTOR (11 downto 0);
    signal addr_reg_s    : STD_LOGIC_VECTOR (11 downto 0); 
    signal input_reg_s   : STD_LOGIC_VECTOR (11 downto 0); 
    signal memory_reg_s   : STD_LOGIC_VECTOR (11 downto 0); 
    signal akku_q_s      : STD_LOGIC_VECTOR (11 downto 0); 
    signal mux_12_q_s      : STD_LOGIC_VECTOR (11 downto 0); 
    signal ena_tb_s      : STD_LOGIC;
    signal ena_tb_n_s    : STD_LOGIC;


begin

    pc : program_counter
    generic map (
        n => 12)
    port map (
        d_out     => pc_q_s,
        d_in      => mux2_1a_q_s,
        sel_in(0) => INSTRUCT(2),
        sel_in(1) => INSTRUCT(1),
        clk_in    => CLK,
        rst_in    => CLR
    );
---------------------------
    reg_stack : register_12bit 
    port map (
        D      => pc_q_s,
        SEL(0) => '0',
        SEL(1) => INSTRUCT(4),
        Q      => reg_stack_q_s,
        CLK    => CLK,
        CLR    => CLR,
        CE     => INSTRUCT(3)
    );
---------------------------
    addr_reg : address_register_12bit
    port map (
        Q   => AR_Q, 
        D   => addr_reg_s,
        CLK => CLK,
        CLR => CLR,
        CE  => INSTRUCT(6)
    );
---------------------------

    mux2_1a : mux_2_1
    port map (
        Q   => mux2_1a_q_s,
        D0  => SYSBUS,
        D1  => reg_stack_q_s,
        SEL => INSTRUCT(0)
    );
 ---------------------------
    mux2_1b : mux_2_1
    port map (
        Q   => addr_reg_s,
        D0  => SYSBUS,
        D1  => pc_q_s,
        SEL => INSTRUCT(5)
    );
 ---------------------------
    akku_12 :  Akkumulator_12_bit
    port map (
        B    => SYSBUS,
        Q    => akku_q_s,
        CIN  => '0',
        CLK  => CLK,
        CLR  => CLR,
        S0   => INSTRUCT(14),
        S1   => INSTRUCT(15),
        S2   => INSTRUCT(16),
        OP_C => OP_C,
        OP_S => OP_S,
        OP_Z => OP_Z
    );
 ---------------------------
    tbuff_a : tri_state_buffer
    port map (
        D  => mux_12_q_s,
        Q  => SYSBUS,
        EN => ena_tb_n_s
    );

   

    ----------------------------
    -- OR gate
    ----------------------------
    ena_tb_s <= INSTRUCT(11) or INSTRUCT(8) or INSTRUCT(9) or INSTRUCT(13);
    
    --------------------------------------
    -- invert signal for tri-state buffer
    --------------------------------------
    ena_tb_n_s <= ena_tb_s;
 ---------------------------
    mux_4_b : mux_4_1_12bit
    port map (
        SEL(0)          => INSTRUCT(8),
        SEL(1)          => INSTRUCT(9),
        D0              => input_reg_s,
        D1              => akku_q_s,
        D2(11 downto 7) => "00000",
        D2(6 downto 0)  => memory_reg_s(6 downto 0),
        D3              => memory_reg_s,
        Q               => mux_12_q_s
    );

    input_reg : address_register_12bit
    port map (
        Q   => input_reg_s,
        D   => IPR_D,
        CLK => CLK,
        CLR => CLR,
        CE  => INSTRUCT(11)
    );

    memory_reg : address_register_12bit
    port map (
        Q   => memory_reg_s,
        D   => MR_D,
        CLK => CLK,
        CLR => CLR,
        CE  => INSTRUCT(7)
    );

    output_reg : address_register_12bit
    port map (
        Q   => OPR_Q,
        D   => SYSBUS,
        CLK => CLK,
        CLR => CLR,
        CE  => INSTRUCT(10)
    );

    instruction_reg : register_5_bit
    port map (
        D   => memory_reg_s(11 downto 7), 
        Q   => IR_Q,
        CLK => CLK,
        CLR => CLR,
        CE  => INSTRUCT(12)
    );

end rtl;
