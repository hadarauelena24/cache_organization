----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2023 06:02:25 PM
-- Design Name: 
-- Module Name: top_env - Behavioral
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

entity topenv is
    Port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC_VECTOR (4 downto 0);
       sw : in STD_LOGIC_VECTOR (15 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0);
       an : out STD_LOGIC_VECTOR (3 downto 0);
       led : out STD_LOGIC_VECTOR (15 downto 0));
end topenv;

architecture Behavioral of topenv is
signal enW,enR: std_logic:='0';
signal ugmc_out: std_logic_vector(31 downto 0):=(others=>'0');
signal hit,miss,ready,rd,wr,bv:std_logic:='0';
component monoimpuls is
    Port ( input: in std_logic;
           clk: in std_logic;
           output: out std_logic);
end component monoimpuls;

component SSD is
    Port ( Digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC);
end component SSD;

signal outtemp: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');

component IFF is
    Port ( clk:in std_logic;
           enableW: in std_logic;
           enableRst: in std_logic;
           pc : out STD_LOGIC_VECTOR (3 downto 0);
           instr : out STD_LOGIC_VECTOR (43 downto 0));
end component IFF;
signal instr: std_logic_vector(43 downto 0):=(others=>'0');
signal pccnt: std_logic_vector(3 downto 0):=(others=>'0');

component UGMC is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (43 downto 0);
           ugmcOut : out STD_LOGIC_VECTOR (31 downto 0);
           bV : out STD_LOGIC;
           rdo : out STD_LOGIC;
           wro : out STD_LOGIC;
           hit : out STD_LOGIC;
           miss : out STD_LOGIC;
           ready : out STD_LOGIC);
end component UGMC;
begin

mpgen: monoimpuls port map (input=>btn(0),clk=>clk, output=>enW);
mpgrst: monoimpuls port map (input=>btn(1),clk=>clk, output=>enR); 
instrFetch: IFF port map (clk=>clk,enableW=>enW,enableRst=>enR,pc=>pccnt,instr=>instr);
ug_memcache: UGMC port map(clk=>clk,en=>enW,instr=>instr,ugmcOut=>ugmc_out,bV=>bv,rdo=>rd,wro=>wr,hit=>hit,miss=>miss,ready=>ready);
process(sw)
begin
case sw(2 downto 0) is
    when "000" => outtemp(15 downto 0)<=instr(15 downto 0); --instr primele 4 cifre hexa
    when "001" => outtemp(15 downto 0)<=instr(31 downto 16); --instr urm 4 cifre hexa
    when "010" => outtemp(15 downto 0)<="0000"&instr(43 downto 32); --instr urm 3 cifre hexa 
    when "011" => outtemp(15 downto 0)<="000000000000"&pccnt;
    when "100" => outtemp(15 downto 0)<=ugmc_out(15 downto 0);
    when "101" => outtemp(15 downto 0)<=ugmc_out(31 downto 16);
    when others => outtemp(15 downto 0)<=(others=>'0');
end case;
end process;
sevsegdisp: SSD port map(Digit0=>outtemp(3 downto 0),Digit1=>outtemp(7 downto 4),Digit2=>outtemp(11 downto 8),Digit3=>outtemp(15 downto 12),cat=>cat,an=>an,clk=>clk);
led(0)<=miss;
led(1)<=hit;
led(2)<=bv;
led(3)<=ready;
led(4)<=rd;
led(5)<=wr;
end Behavioral;
