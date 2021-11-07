----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 19.10.2021 15:13:48
-- Design Name: MPU_12
-- Module Name: uut_mpu_12 - rtl
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
--      Testbench for mpu_12 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uut_mpu_12 is
--  Port ( );
end uut_mpu_12;

architecture rtl of uut_mpu_12 is

    component MPU_12 is
    Port (
        PORT_OUT : out  STD_LOGIC_VECTOR (11 downto 0);
        PORT_IN  : in   STD_LOGIC_VECTOR (11 downto 0);
        CLK      : in   STD_LOGIC;
        CLR      : in   STD_LOGIC;
        IPV      : in   STD_LOGIC;
        START    : in   STD_LOGIC;
        LOAD     : in   STD_LOGIC;
        OPREC    : in   STD_LOGIC;
        IPREQ    : out  STD_LOGIC;
        OPV      : out  STD_LOGIC           
    );
    end component;
---------------------Signal-declaration------------------------------    
    signal clk_s      : std_logic;
    signal clr_s      : std_logic;
    signal ipv_s      : std_logic;
    signal start_s    : std_logic;
    signal load_s     : std_logic;
    signal oprec_s    : std_logic;
    signal ipreq_s    : std_logic;
    signal opv_s      : std_logic;
    
    signal port_in_s  : std_logic_vector(11 downto 0);
    signal port_out_s : std_logic_vector(11 downto 0);
    

begin

--------------------Component-instances-UUT-------------------------
    UUT : MPU_12
    port map(
        PORT_OUT => port_in_s,
        PORT_IN  => port_out_s,
        CLK      => clk_s,
        CLR      => clr_s,
        IPV      => ipv_s,
        START    => start_s,
        LOAD     => load_s,
        OPREC    => oprec_s,
        IPREQ    => ipreq_s,
        OPV      => opv_s
    );
    
-------------------------start-condition----------------------------

    clr_in : process
    begin
        ipv_s <= '0';
        clr_s <= '1';
        wait for 15 ns;
        clr_s <= '0';
        wait for 3 ns;
        --start-address-machine-programm
        port_out_s <= "000000110000";
        wait;
    end process;
    
--------------------initialising-RAM--------------------------------
    ram_load : process
    begin
        load_s <= '0';
        wait for 20 ns;
        load_s <= '1';
        wait for 150 ns;
        load_s <= '0';
        wait;
    end process;
------------------TEST-PROGRAM--------------------------------------
        -------------data-12-bit-stataddres-0-----------------------
        --    ADR          BINARY            HEX    OPCODE
        --    00           "001100110011"; --333
        --    01           "010001000100"; --444
        --    02           "000000000000"; --000
        --    03           "000000000000"; --000
        --    04           "000100010001"; --111
        --    05           "000001010101"; --055
        -----------------OPCODE-startaddress-x30-------------------
        --                BINARY          HEX    OPCODE
        --    30          "111100000000"; --F00  LOAD   A, 00
        --    31          "110000000001"; --C01  ADD    A, 01
        --    32          "000100000010"; --102  STORE  02, A  
        --    33          "000000000010"; --002  OUTPUT O, 02 
        --    34          "010000111000"; --438  JUMP   Z, 38
        --    35          "110100000010"; --D02  SUB    A, 02 
        --    36          "010001010101"; --455  JUMP   Z, 55 
        --    37          "001100000000"; --300  STOP --error
        --    38          "001100000000"; --300  STOP --error   
        ------------jump-addres-85------------------------------
        --    85         "111100000100"; --F04  LOAD   A, 04 
        --    86         "110000000101"; --C05  ADD    A, 05  
        --    87         "000100000110"; --106  STORE  06, A
        --    88)        "001100000000"; --300  STOP    
        
        
        ---clk-t=50ns------------------------------------------
        clk_gen : process
        begin
            clk_s <= '0';
            wait for 25 ns;
            clk_s <= '1';
            wait for 25 ns;
       end process;
       ---porgram start-----------------------------------------
       start_in : process       
       begin
         start_s <= '0';
         wait for 260 ns;
         start_s <= '1';
         wait for 150 ns;
         start_s <= '0';
         wait;
      end process;
      
      --output-register-----------------------------------------
      out_data : process
      begin
        oprec_s <= '0';
        wait for 2410 ns;
        oprec_s <= '1';
        wait for 100 ns;
        oprec_s <= '0';
        wait;
     end process; 
      
end rtl;
