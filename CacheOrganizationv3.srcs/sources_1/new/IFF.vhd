----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 12:26:15 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFF is
    Port ( clk:in std_logic;
           enableW: in std_logic;
           enableRst: in std_logic;
           pc : out STD_LOGIC_VECTOR (3 downto 0);
           instr : out STD_LOGIC_VECTOR (43 downto 0));
end IFF;

architecture Behavioral of IFF is
type mem16_44 is array (0 to 15) of std_logic_vector(43 downto 0);--adr: 10b + data de scris: 32b + op.scriere/citire: 2b
    signal myROM:mem16_44:=( x"0_01_00000000",--rd, RAM(1) => bloc(1/4)=bloc 0, linia(0%128)=linia 0, cuv(1%4)=cuv 1 => miss
                             x"0_0A_00000000",--rd, RAM(10) => bloc(10/4)=bloc 2, linia(2%128)=linia 2,cuv(10%4)=cuv 2 => miss
                             x"0_01_00000000",--rd, RAM(1) => bloc(1/4)=bloc 0, linia(0%128)=linia 0, cuv(1%4)=cuv 1 => hit
                             x"0_0A_00000000",--rd, RAM(10) => bloc(10/4)=bloc 2, linia(2%128)=linia 2,cuv(10%4)=cuv 2 => hit
                             x"4_14_0000001A",--wr, RAM(20) => bloc(20/4)=bloc 5, linia(5%128)=linia 5,cuv(20%4)=cuv 0 => miss scrie 1A
                             x"4_9B_0000001E",--wr, RAM(155) => bloc(155/4)=bloc 38, linia(38%128)=linia 38,cuv(155%4)=cuv 3 => miss scrie 1E
                             x"0_9B_00000000",--rd, RAM(155) => bloc(155/4)=bloc 38, linia(38%128)=linia 38,cuv(155%4)=cuv 3 => hit citeste 1E
                             x"0_14_00000000",--rd, RAM(20) => bloc(20/4)=bloc 5, linia(5%128)=linia 5,cuv(20%4)=cuv 0 => hit citeste 1A
                             x"0_02_00000000",--rd, RAM(2) => bloc(2/4)=bloc 0, linia(0%128)=linia 0, cuv(2%4)=cuv 2 => hit
                             others=>x"0_00_00000000");
signal q:std_logic_vector(3 downto 0):="0000";
begin
process(clk)
begin
if rising_edge(clk) then
    if enableRst='1' then
        q<="0000";
    else
        if enableW='1' then
            q<=1+q;
        end if;
    end if;
end if;
end process;
instr<=myROM(conv_integer(q(3 downto 0)));
pc<=q;
end Behavioral;
