----------------------------------------------------------------------------------
-- Company: Digitaltechnik Socher
-- Engineer: Socher
-- 
-- Create Date: 20.09.2021 09:36:36
-- Design Name: 
-- Module Name: Controlunit - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  Control unit for 12-bit CPU
--  Mealy-machine with 7 states.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controlunit is
    Port (
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
end Controlunit;

architecture rtl of Controlunit is

    ------------------------------------------------------
    --type declaration state machine
    ------------------------------------------------------
    type status_reg_type is (S0, S1, S2, S3, S4, S5, S6);
    signal status_reg_s : status_reg_type;


begin
------------------Process Statemachine--------------
    main_state_machine : process(CLK, CLR)
    begin
        if CLR = '1' then
            status_reg_s <= S0;
        elsif rising_edge(CLK) then
            case status_reg_s is
----------------S0-----------------------------------
                when S0 => -- NOOP state
                    if START = '0' then
                        status_reg_s <= S0;
                    elsif START = '1' then
                        status_reg_s <= S1;
                    end if;    
----------------S1------------------------------
                when S1 => --starting
                    status_reg_s <= S2;
----------------S2-----------------------------------
                when S2 => --starting
                    status_reg_s <= S3;
----------------S3-----------------------------------
                when S3 => 
                    if OPC(0) = '1' then -- implicit addressing
                        status_reg_s <= S4;
                    elsif OPC(0) = '0' then
                        status_reg_s <= S5; --direct addressing
                    end if;
----------------S4-----------------------------------
                when S4 =>
                    status_reg_s <= S5;
----------------S5-----------------------------------
                when S5 =>
                    case OPC is
                        when "10100" => --SHR
                            status_reg_s <= S1;
                        when "10110" => --SHL
                            status_reg_s <= S1;  
                        when "00010" => --ST
                            status_reg_s <= S1;
                        when "00011" => --STI
                            status_reg_s <= S1;
                        when "00100" => --IN
                            if IPV = '1' then
                                status_reg_s <= S1;
                            elsif IPV = '0' then 
                                status_reg_s <= S5;
                            end if;
                        when "00101" => --INI
                            if IPV = '1' then
                                status_reg_s <= S1;
                            elsif IPV = '0' then 
                                status_reg_s <= S5;
                            end if;    
                        when "01110" => --JU
                            status_reg_s <= S1;
                        when "01111" => --JUI
                            status_reg_s <= S1;
                        when "01000" => --JZ
                            status_reg_s <= S1;
                        when "01001" => --JZI
                            status_reg_s <= S1;
                        when "01010" => --JS
                            status_reg_s <= S1;
                        when "01011" => --JSI
                            status_reg_s <= S1;
                        when "01100" => --JC
                            status_reg_s <= S1; 
                        when "01101" => --JCI
                            status_reg_s <= S1;
                        when "11110" => --LO    
                            status_reg_s <= S6;
                        when "11111" => --LI
                            status_reg_s <= S6;
                        when "00000" => --OU
                            status_reg_s <= S6;
                        when "00001" => --OUI
                            status_reg_s <= S6;
                        when "11000" => --AD
                            status_reg_s <= S6;
                        when "11001" => --ADI
                            status_reg_s <= S6;
                        when "11010" => --SU
                            status_reg_s <= S6; 
                        when "11011" => --SUI
                            status_reg_s <= S6;
                        when "11100" => --NA
                            status_reg_s <= S6;
                        when "11101" => --NAI
                            status_reg_s <= S6;
                        when "00110" => --STOP
                            status_reg_s <= S0;
                        when "10010" => --RETURN
                            status_reg_s <= S6;
                        when "10000" => --CA
                            status_reg_s <= S1; 
                        when "10001" => --CAI
                            status_reg_s <= S1;
                        when "00111" => --NOP reserve
                            status_reg_s <= S1;
                        when "10011" => --NOP reserve
                            status_reg_s <= S1;
                        when "10101" => --NOP reserve
                            status_reg_s <= S1;
                        when "10111" => --NOP reserve
                            status_reg_s <= S1;
                        when others =>
                            status_reg_s <= S1;  
                    end case;
----------------S6-----------------------------------
                when S6 =>
                    case OPC is
                        when "11110" => --LO
                            status_reg_s <= S1;  
                        when "11111" => --LOI
                            status_reg_s <= S1;  
                        when "11000" => --AD
                            status_reg_s <= S1;  
                        when "11001" => --ADI
                            status_reg_s <= S1;
                        when "11010" => --SU
                            status_reg_s <= S1; 
                        when "11011" => --SUI
                            status_reg_s <= S1; 
                        when "11100" => --NA
                            status_reg_s <= S1;
                        when "11101" => --NAI
                            status_reg_s <= S1;
                        when "00000" => --OU
                            if OPREC = '0' then
                                status_reg_s <= S6; 
                            elsif OPREC = '1' then
                                status_reg_s <= S1;
                            end if;
                        when "00001" => --OUI
                            if OPREC = '0' then
                                status_reg_s <= S6; 
                            elsif OPREC = '1' then
                                status_reg_s <= S1;
                            end if;        
                        when others =>
                            status_reg_s <= S1;
                    end case;
                when others => null;
            end case;
        end if;
    end process;

------------Control-vector-INSTRUCT-(16:0)----------
----------------S0-NOP--------------------------------
    INSTRUCT <= "00000100000000000" when (status_reg_s = S0 and START = '0') else
                "00000100001000110" when (status_reg_s = S0 and START = '1') else
----------------S1------------------------------------
                "00000000010000100" when (status_reg_s = S1) else --FETCH instruction
----------------S2------------------------------------     
                "00001001001000000" when (status_reg_s = S2) else --DECODE instruction
----------------S3------------------------------------   
                "00000000010000000" when (status_reg_s = S3 and OPC(0) = '1') else -- implicit adressing
                "00000000000000000" when (status_reg_s = S3 and OPC(0) = '0') else -- direct adressing
----------------S4------------------------------------   
                "00000001101000000" when status_reg_s = S4 else -- implicit adressing
----------------S5---JUMP-condition-not-complied------
                "00000000001100000" when (status_reg_s = S5 and OPC = "01000" and OP_Z = '0') else --JZ
                "00000000001100000" when (status_reg_s = S5 and OPC = "01010" and OP_S = '0') else --JS
                "00000000001100000" when (status_reg_s = S5 and OPC = "01100" and OP_C = '0') else --JC
-----------------------------------
                "00000000001100000" when (status_reg_s = S5 and OPC = "01001" and OP_Z = '0') else --JZI
                "00000000001100000" when (status_reg_s = S5 and OPC = "01011" and OP_S = '0') else --JSI
                "00000000001100000" when (status_reg_s = S5 and OPC = "01101" and OP_C = '0') else --JCI
----------------S5---JUMP-condition-complied---------
                "00000001000000110" when (status_reg_s = S5 and OPC = "01000" and OP_Z = '1') else --JZ
                "00000001000000110" when (status_reg_s = S5 and OPC = "01010" and OP_S = '1') else --JS
                "00000001000000110" when (status_reg_s = S5 and OPC = "01100" and OP_C = '1') else --JC
-----------------------------------
                "00000001100000110" when (status_reg_s = S5 and OPC = "01001" and OP_Z = '1') else --JZI            
                "00000001100000110" when (status_reg_s = S5 and OPC = "01011" and OP_S = '1') else --JSI
                "00000001100000110" when (status_reg_s = S5 and OPC = "01101" and OP_C = '1') else --JCI
-----------------------------------
                "00000001000000110" when (status_reg_s = S5 and OPC = "01110") else --JU
                "00000001100000110" when (status_reg_s = S5 and OPC = "01111") else --JUI
-----------------------------------
                "11000000001100000" when (status_reg_s = S5 and OPC = "10100") else --SHR
                "11100000001100000" when (status_reg_s = S5 and OPC = "10110") else --SHL
-----------------------------------   
                "00000000010000000" when (status_reg_s = S5 and OPC = "11001") else --AD/ADI
                "00000000010000000" when (status_reg_s = S5 and OPC = "11011") else --SU/SUI
                "00000000010000000" when (status_reg_s = S5 and OPC = "11101") else --NA/NAI
                "00000000010000000" when (status_reg_s = S5 and OPC = "00001") else --OU/OUI
                "00000000010000000" when (status_reg_s = S5 and OPC = "11111") else --LO/LOI
                "00010000101100000" when (status_reg_s = S5 and OPC = "00011") else --ST/STI
-----------------------------------   
                "00000100000000000" when (status_reg_s = S5 and OPC = "00100" and IPV = '0') else --IN
                "00000100000000000" when (status_reg_s = S5 and OPC = "00101" and IPV = '0') else --INI
                "00010100001100000" when (status_reg_s = S5 and OPC = "00100" and IPV = '1') else --IN
                "00010100001100000" when (status_reg_s = S5 and OPC = "00101" and IPV = '1') else --INI
-----------------------------------  
                "00000000000000000" when (status_reg_s = S5 and OPC = "00110") else --STOP
                "00000000001100000" when (status_reg_s = S5 and OPC = "00111") else --NOP
                "00000000001100000" when (status_reg_s = S5 and OPC = "10011") else --NOP
                "00000000001100000" when (status_reg_s = S5 and OPC = "10101") else --NOP
                "00000000001100000" when (status_reg_s = S5 and OPC = "10111") else --NOP
----------------S6------------------------------------
                "01100001101100000" when (status_reg_s = S6 and (OPC = "11000" or OPC = "11001")) else --AD/ADI
                "00100001101100000" when (status_reg_s = S6 and (OPC = "11010" or OPC = "11011")) else --ASU/SUI
                "01000001101100000" when (status_reg_s = S6 and (OPC = "11100" or OPC = "11101")) else --NA/NAI
                "10100001101100000" when (status_reg_s = S6 and (OPC = "11110" or OPC = "11111")) else --LO/LOI
                "00000001100000000" when (status_reg_s = S6 and (OPC = "00000" or OPC = "00001") and OPREC = '0') else --OU/OUI
                "00000011101100000" when (status_reg_s = S6 and (OPC = "00000" or OPC = "00001") and OPREC = '1') else --OU/OUI
                "00000000001100000" when (status_reg_s = S6 and OPC  = "10010")  else --RETURN   
                "00000000001100000";
---------INPUT-OUTPUT-PROTOCOL---------------------
----------------OPV-Assignment-----------------------
    OPV <=  '0' when (status_reg_s = S0 and START = '0') else --Output valid
            '1' when (status_reg_s = S6 and (OPC = "00000" or OPC = "00001")) and OPREC = '0' else --OU/OUI
            '0';
----------------IPREQ-Assignment---------------------
    IPREQ <= '0' when (status_reg_s = S0 and START = '0') else --Input request
             '1' when (status_reg_s = S5 and (OPC = "00100" or OPC = "00101")) and IPV = '0' else --IN/INI
             '0';
end rtl;
