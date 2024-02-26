----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2023 05:45:18 PM
-- Design Name: 
-- Module Name: CacheMemory - Behavioral
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

entity CacheMemory is
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
end CacheMemory;

architecture Behavioral of CacheMemory is

component TAG is
    Port ( clk: in STD_LOGIC;
       en : in STD_LOGIC;
       address : in STD_LOGIC_VECTOR (9 downto 0);
       bV : out STD_LOGIC;
       hit : out STD_LOGIC;
       miss : out STD_LOGIC);
end component TAG;

component DataMemory is
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
end component DataMemory;
signal hitT,missT,bvt:std_logic:='0';
begin
tagm: TAG port map(clk=>clk,en=>en,address=>addr,bV=>bvt,hit=>hitT,miss=>missT);
datam: DataMemory port map(clk=>clk,en=>en,hit=>hitT,miss=>missT,rd=>rd,wr=>wr,addr=>addr,wrData=>wrData,wrBlock=>wrBlock,rdData=>rdData);
hit<=hitT;
miss<=missT;
bV<=bvt;
end Behavioral;
