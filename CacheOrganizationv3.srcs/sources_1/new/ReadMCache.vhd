----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2023 06:32:06 PM
-- Design Name: 
-- Module Name: ReadMCacheHit - Behavioral
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

entity ReadMCache is
    Port ( hit_miss : in STD_LOGIC;
           rd : in STD_LOGIC;
           blockM : in STD_LOGIC_VECTOR (127 downto 0);
           dataRd : out STD_LOGIC_VECTOR (31 downto 0);
           wordOff : in STD_LOGIC_VECTOR (1 downto 0));
end ReadMCache;

architecture Behavioral of ReadMCache is

begin
process(hit_miss,rd,blockM,wordOff)
begin
if hit_miss='1' then
    if rd='1' then
        case wordOff is
            when "00" =>  dataRd <= blockM(31 downto 0);
            when "01" =>  dataRd <= blockM(63 downto 32);
            when "10" =>  dataRd <= blockM(95 downto 64);
            when "11" =>  dataRd <= blockM(127 downto 96);
            end case;
    end if;
end if;
end process;

end Behavioral;
