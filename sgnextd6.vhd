library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity sgnextd6 is
	port (x : in std_logic_vector(5 downto 0);
		z : out std_logic_vector(15 downto 0));
end entity;
architecture behave of sgnextd6 is
begin
z(15) <= '0';
z(14) <= '0';
z(13) <= '0';
z(12) <= '0';
z(11) <= '0';
z(10) <= '0';
z(9) <= '0';
z(8) <= '0';
z(7) <= '0';
z(6) <= '0';
z(5) <= x(5);
z(4) <= x(4);
z(3) <= x(3);
z(2) <= x(2);
z(1) <= x(1);
z(0) <= x(0);
end behave;
