----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2023 07:00:23 PM
-- Design Name: 
-- Module Name: UGMC - Behavioral
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

entity UGMC is
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
end UGMC;

architecture Behavioral of UGMC is

component ctrl is
    Port ( instr : in STD_LOGIC_VECTOR (43 downto 0);
           addr : out STD_LOGIC_VECTOR (9 downto 0);
           wrData : out STD_LOGIC_VECTOR (31 downto 0);
           rd : out STD_LOGIC;
           wr : out STD_LOGIC);
end component ctrl;

signal addr: std_logic_vector(9 downto 0):=(others=>'0');
signal wrData: std_logic_vector(31 downto 0):=(others=>'0');
signal wr: std_logic:='0';
signal rd: std_logic:='0';

component MainMemory is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           memWr : in STD_LOGIC;
           memRd: in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (9 downto 0);
           wrData : in STD_LOGIC_VECTOR (31 downto 0);
           rdData : out STD_LOGIC_VECTOR (31 downto 0);
           rdBlock : out STD_LOGIC_VECTOR (127 downto 0);
           readyMM : out STD_LOGIC);
end component MainMemory;

signal rdDataMM: std_logic_vector(31 downto 0):=(others=>'0');
signal rdBlockMM: std_logic_vector(127 downto 0):=(others=>'0');

component CacheMemory is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rd : in STD_LOGIC;
           wr : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (9 downto 0);
           wrData : in STD_LOGIC_VECTOR (31 downto 0);
           wrBlock : in STD_LOGIC_VECTOR (127 downto 0);
           rdData : out STD_LOGIC_VECTOR (31 downto 0);
           bV : out STD_LOGIC;
           hit : out STD_LOGIC;
           miss : out STD_LOGIC);
end component CacheMemory;

signal rdDataMC: std_logic_vector(31 downto 0):=(others=>'0');
signal hitC,missC,bvc:std_logic:='0';

begin
ctrl_instr: ctrl port map(instr=>instr,addr=>addr,wrData=>wrData,rd=>rd,wr=>wr);
mem_mainmem: MainMemory port map(clk=>clk,en=>en,memWr=>wr,memRd=>rd,address=>addr,wrData=>wrData,rdData=>rdDataMM,rdBlock=>rdBlockMM,readyMM=>ready);
mem_cache: CacheMemory port map(clk=>clk,en=>en,rd=>rd,wr=>wr,addr=>addr,wrData=>wrData,wrBlock=>rdBlockMM,rdData=>rdDataMC,bV=>bvc,hit=>hitC,miss=>missC);
process(hitC,missC,rdDataMM,rdDataMC)
begin
if hitC='1' then
    ugmcOut<=rdDataMC;
elsif missC='1' then
    ugmcOut<=rdDataMM;
end if;
end process;
rdo<=rd;
wro<=wr;
hit<=hitC;
miss<=missC;
bV<=bvc;
end Behavioral;
