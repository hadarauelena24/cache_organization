----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2023 04:28:45 PM
-- Design Name: 
-- Module Name: TAG - Behavioral
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

entity TAG is
    Port ( clk: in STD_LOGIC;
           en : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (9 downto 0);
           bV : out STD_LOGIC;
           hit : out STD_LOGIC;
           miss : out STD_LOGIC);
end TAG;

architecture Behavioral of TAG is
type mem128_9 is array (0 to 127) of std_logic_vector(8 downto 0);--adr: 10b + data de scris: 16b + op.scriere/citire: 2b
    signal mtag:mem128_9:=(others=>"000000000");
signal temp_hit,temp_miss:std_logic:='0';
begin

--verific daca blocul cuvantului dorit este scris in memorie
process(address)
variable lineTag:integer:=0;
variable bloc:std_logic_vector(8 downto 0):=(others=>'0');
begin
lineTag:=conv_integer(address(8 downto 2));
bloc:=mtag(lineTag);
if bloc(8)='1' then
    if bloc(7 downto 0)=address(9 downto 2) then
        temp_hit<='1';
        temp_miss<='0';
    else
        temp_hit<='0';
        temp_miss<='1';
    end if;
else
    temp_hit<='0';
    temp_miss<='1';
end if;
bV<=bloc(8);
end process;
hit<=temp_hit;
miss<=temp_miss;

--daca blocul nu se afla in memoria cache, atunci trebuie sa il aducem si sa actualizam linia din mTag
process(address,temp_miss,clk,en)
variable lineTag:integer:=0;
begin
lineTag:=conv_integer(address(8 downto 2));
if rising_edge(clk) then
if en='1' then
if temp_miss='1' then
    mtag(lineTag)<='1'&address(9 downto 2);
end if;
end if;
end if;
end process;
end Behavioral;
