library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity pe_demux_and is
	port (x: in std_logic_vector(7 downto 0);
			selector: in std_logic_vector(2 downto 0);
			z: out std_logic_vector(7 downto 0)
			);
end entity;
architecture behave of pe_demux_and is
begin
process(selector)
begin

if (selector="000") then
	z <= x and "11111110";
elsif (selector="001") then
	z <= x and "11111101";
elsif (selector="010") then
	z <= x and "11111011";
elsif (selector="011") then
	z <= x and "11110111";
elsif (selector="100") then
	z <= x and "11101111";
elsif (selector="101") then
	z <= x and "11011111";
elsif (selector="110") then
	z <= x and "10111111";
elsif (selector="111") then
	z <= x and "01111111";
end if;
end process;
end behave;