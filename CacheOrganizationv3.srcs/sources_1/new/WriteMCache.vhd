----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2023 05:11:18 PM
-- Design Name: 
-- Module Name: WriteMCache - Behavioral
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
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2023 06:41:30 PM
-- Design Name: 
-- Module Name: WriteMCacheHit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WriteMCache is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           hit_miss : in STD_LOGIC;
           wr : in STD_LOGIC;
           wordOff : in STD_LOGIC_VECTOR (1 downto 0);
           blockMC : in STD_LOGIC_VECTOR (127 downto 0);
           blockToWr : out STD_LOGIC_VECTOR (127 downto 0);
           dataWr : in STD_LOGIC_VECTOR (31 downto 0));
end WriteMCache;

architecture Behavioral of WriteMCache is

begin
process(hit_miss,wordOff,wr,clk,en,dataWr,blockMC)
variable varBlockMC: std_logic_vector(127 downto 0):=(others=>'0');
begin
varBlockMC:=blockMC;
if hit_miss='1' then
     if wr='1' then
           case wordOff is
                when "00" => varBlockMC(31 downto 0) := dataWr;
                when "01" => varBlockMC(63 downto 32) := dataWr;
                when "10" => varBlockMC(95 downto 64) := dataWr;
                when "11" => varBlockMC(127 downto 96) := dataWr;
           end case;
           blockToWr<=varBlockMC;
     end if;
end if;
end process;

end Behavioral;
