----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2023 05:55:49 PM
-- Design Name: 
-- Module Name: MainMemory - Behavioral
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

entity MainMemory is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           memWr : in STD_LOGIC;
           memRd: in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (9 downto 0);
           wrData : in STD_LOGIC_VECTOR (31 downto 0);
           rdData : out STD_LOGIC_VECTOR (31 downto 0);
           rdBlock : out STD_LOGIC_VECTOR (127 downto 0);
           readyMM : out STD_LOGIC);
end MainMemory;

architecture Behavioral of MainMemory is
type memRam is array(0 to 1023) of std_logic_vector(31 downto 0);
signal RAM: memRam:=(x"00000001",x"00000002",x"00000003",x"00000004",x"00000005",x"00000006",x"00000007",x"00000008",x"00000009",x"0000000A",others=>x"0000000F");

begin

process(clk,memWr,en,address,wrData)
variable wOff,addr:integer:=0;
begin
addr:=conv_integer(address);
wOff:=conv_integer(address(1 downto 0));
if rising_edge(clk) then
    if en='1' then
        if memWr='1' then
            RAM(addr)<=wrData;
        end if;
    end if;
end if;
end process;

process(address,memRd)
variable wOff,addr:integer:=0;
begin
addr:=conv_integer(address);
wOff:=conv_integer(address(1 downto 0));
if memRd='1' then
    rdData<=RAM(addr);
    case wOff is
        when 0 => rdBlock <= RAM(addr+3)&RAM(addr+2)&RAM(addr+1)&RAM(addr);
        when 1 => rdBlock <= RAM(addr+2)&RAM(addr+1)&RAM(addr)&RAM(addr-1);
        when 2 => rdBlock <= RAM(addr+1)&RAM(addr)&RAM(addr-1)&RAM(addr-2);
        when 3 => rdBlock <= RAM(addr)&RAM(addr-1)&RAM(addr-2)&RAM(addr-3);
        when others => rdBlock<=(others=>'0');
    end case;
end if;
end process;

process(memWr)
begin
if memWr='1' then
    readyMM<='1';
else
    readyMM<='0';
end if;
end process;
end Behavioral;
