----------------------------------------------------------------------------------
-- Company: Digtaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 20.09.2021 14:23:04
-- Design Name: 12 bit Microprozerssor
-- Module Name: MPU_12 - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      See datasheet
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MPU_12 is
    Port (
        PORT_OUT : out STD_LOGIC_VECTOR (11 downto 0);
        PORT_IN  : in  STD_LOGIC_VECTOR (11 downto 0);
        CLK      : in  STD_LOGIC;
        CLR      : in  STD_LOGIC;
        IPV      : in  STD_LOGIC;
        START    : in  STD_LOGIC;
        LOAD     : in  STD_LOGIC;
        OPREC    : in  STD_LOGIC;
        IPREQ    : out  STD_LOGIC;
        OPV      : out  STD_LOGIC           
    );
end MPU_12;

architecture rtl of MPU_12 is
------------------Component-Declaration-----------------------------------------
    component operationswerk_n_bit is
        port (
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
    end component;
----------------------------------------
    component Controlunit is
        port (
            OPC      : in  STD_LOGIC_VECTOR (4 downto 0);
            INSTRUCT : out STD_LOGIC_VECTOR (16 downto 0);
            CLK      : in  STD_LOGIC;
            CLR      : in  STD_LOGIC;
            IPV      : in  STD_LOGIC;
            OPREC    : in  STD_LOGIC;   
            START    : in  STD_LOGIC;     
            OP_Z     : in  STD_LOGIC;
            OP_S     : in  STD_LOGIC;
            OP_C     : in  STD_LOGIC;
            IPREQ    : out STD_LOGIC;
            OPV      : out STD_LOGIC
        );
    end component;
----------------------------------------
    component RAM_12 is
        port (
            ADR  : in  STD_LOGIC_VECTOR (6  downto 0);
            DI   : in  STD_LOGIC_VECTOR (11 downto 0);
            DO   : out STD_LOGIC_VECTOR (11 downto 0);
            LOAD : in STD_LOGIC;
            WE   : in STD_LOGIC;
            CLK  : in STD_LOGIC
        );
    end component;
------------------Signal-Declaration---------------------------------------------
    signal instruction_s : STD_LOGIC_VECTOR (16 downto 0);
    signal opc_s         : STD_LOGIC_VECTOR (4 downto 0);
    signal sys_data_s    : STD_LOGIC_VECTOR (11 downto 0);
    signal adress_s      : STD_LOGIC_VECTOR (6 downto 0);
    signal gnd_s         : STD_LOGIC_VECTOR (4 downto 0);
    signal data_out_s    : STD_LOGIC_VECTOR (11 downto 0);
    signal st_c1_s       : STD_LOGIC; --Statusflag
    signal st_s1_s       : STD_LOGIC; --Statusflag
    signal st_z1_s       : STD_LOGIC; --Statusflag
begin
------------------SIGNAL Assignemnt----------------------------------------------
    gnd_s <= "00000";
------------------Component-Instansiation----------------------------------------
    CU_a : Controlunit
    port map (
        OPC      => opc_s,
        INSTRUCT => instruction_s,
        CLK      => CLK,
        CLR      => CLR,
        IPV      => IPV,
        OPREC    => OPREC,
        START    => START,
        OP_Z     => st_c1_s,
        OP_S     => st_s1_s,
        OP_C     => st_z1_s,
        IPREQ    => IPREQ,
        OPV      => OPV
    );

    OP_a : operationswerk_n_bit
    port map (
        SYSBUS             => sys_data_s, -- system bus
        MR_D               => data_out_s, -- Memory register
        IPR_D              => PORT_IN,-- Input register
        AR_Q (11 downto 7) => gnd_s, -- Address register
        AR_Q (6 downto 0)  => adress_s, -- Address register
        IR_Q               => opc_s, -- instruction output
        OPR_Q              => PORT_OUT, -- output register
        INSTRUCT           => instruction_s, -- Control instructions
        CLK                => CLK,
        CLR                => CLR,
        OP_C               => st_c1_s,
        OP_S               => st_s1_s,
        OP_Z               => st_z1_s
    );

    ram_a : RAM_12
    port map (
        ADR  => adress_s,
        DI   => sys_data_s,
        DO   => data_out_s,
        LOAD => LOAD,
        WE   => instruction_s(13),
        CLK  => CLK
    );


end rtl;
