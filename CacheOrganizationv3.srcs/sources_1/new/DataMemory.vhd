----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2023 05:06:11 PM
-- Design Name: 
-- Module Name: DataMemory - Behavioral
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

entity DataMemory is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           hit : in STD_LOGIC;
           miss : in STD_LOGIC;
           rd : in STD_LOGIC;
           wr : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (9 downto 0);
           wrData : in STD_LOGIC_VECTOR (31 downto 0);
           wrBlock : in STD_LOGIC_VECTOR (127 downto 0);
           rdData : out STD_LOGIC_VECTOR (31 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

type memCacheType is array(0 to 127) of std_logic_vector(127 downto 0);
signal Cache:memCacheType:=(others=>x"00000000000000000000000000000000");

component ReadMCache is
    Port ( hit_miss : in STD_LOGIC;
           rd : in STD_LOGIC;
           blockM : in STD_LOGIC_VECTOR (127 downto 0);
           dataRd : out STD_LOGIC_VECTOR (31 downto 0);
           wordOff : in STD_LOGIC_VECTOR (1 downto 0));
end component ReadMCache;
signal rdDataCH:std_logic_vector(31 downto 0):=(others=>'0');
signal blockCache:std_logic_vector(127 downto 0):=(others=>'0');
signal wordOffset:std_logic_vector(1 downto 0):="00";

component WriteMCache is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           hit_miss : in STD_LOGIC;
           wr : in STD_LOGIC;
           wordOff : in STD_LOGIC_VECTOR (1 downto 0);
           blockMC : in STD_LOGIC_VECTOR (127 downto 0);
           blockToWr : out STD_LOGIC_VECTOR (127 downto 0);
           dataWr : in STD_LOGIC_VECTOR (31 downto 0));
end component WriteMCache;
signal wrBlockCacheH,wrBlockCacheM: std_logic_vector(127 downto 0):=(others=>'0');
signal rdDataCM:std_logic_vector(31 downto 0):=(others=>'0');
begin
blockCache<=Cache(conv_integer(addr(8 downto 2)));
wordOffset<=addr(1 downto 0);
rdHitCache: ReadMCache port map(hit_miss=>hit, rd=>rd, blockM=> blockCache, dataRd=>rdDataCH, wordOff=>wordOffset);
wrHitCache: WriteMCache port map(clk=>clk,en=>en,hit_miss=>hit,wr=>wr,wordOff=>wordOffset,blockMC=>blockCache,blockToWr=>wrBlockCacheH,dataWr=>wrData);
rdMissCache: ReadMCache port map(hit_miss=>miss, rd=>rd, blockM=> blockCache, dataRd=>rdDataCM, wordOff=>wordOffset);
wrMissCache: WriteMCache port map(clk=>clk,en=>en,hit_miss=>miss,wr=>wr,wordOff=>wordOffset,blockMC=>blockCache,blockToWr=>wrBlockCacheM,dataWr=>wrData);

process(hit,miss,rd,wr,clk,en)
variable lineOffsetC: integer:=0;
begin
lineOffsetC:=conv_integer(addr(8 downto 2));
if rising_edge(clk) then
    if en='1' then
        if wr='1' then
            if hit='1' then
                Cache(lineOffsetC)<=wrBlockCacheH;
            elsif miss='1' then
                Cache(lineOffsetC)<=wrBlockCacheM;
            end if;
        elsif rd='1' then
            if miss='1' then
                Cache(lineOffsetC)<=wrBlock;
            end if;
        end if;
    end if;
end if;
end process;

process(hit,miss,rd,wr)
begin
if rd='1' then
    if hit='1' then
        rdData<=rdDataCH;
    elsif miss='1' then
        rdData<=rdDataCM;
    end if;
elsif wr='1' then
    rdData<=x"00000000";
end if;
end process;
end Behavioral;
