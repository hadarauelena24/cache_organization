----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2023 07:02:28 PM
-- Design Name: 
-- Module Name: ctrl - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl is
    Port ( instr : in STD_LOGIC_VECTOR (43 downto 0);
           addr : out STD_LOGIC_VECTOR (9 downto 0);
           wrData : out STD_LOGIC_VECTOR (31 downto 0);
           rd : out STD_LOGIC;
           wr : out STD_LOGIC);
end ctrl;

architecture Behavioral of ctrl is

begin
--scriere sau citire
process(instr)
begin
if instr(43 downto 42)="00" then
    rd<='1';
    wr<='0';
elsif instr(43 downto 42)="01" then
    rd<='0';
    wr<='1';
end if;
end process;

addr<=instr(41 downto 32);
wrData<=instr(31 downto 0);
end Behavioral;
