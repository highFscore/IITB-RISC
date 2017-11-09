library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity comparator is
	port (x: in std_logic_vector(15 downto 0);
		z : out std_logic);
end entity;
architecture behave of comparator is
begin

process(x)
begin

if (x="0000000000000000") then
	z <= '1';
else
	z <= '0';
end if;
end process;
end behave;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity comparator8 is
	port (x: in std_logic_vector(7 downto 0);
		z : out std_logic);
end entity;
architecture behave of comparator8 is
begin

process(x)
begin

if (x="00000000") then
	z <= '1';
else
	z <= '0';
end if;
end process;
end behave;
