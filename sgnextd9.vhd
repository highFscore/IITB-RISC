library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity sgnextd9 is
	port (x : in std_logic_vector(8 downto 0);
		z : out std_logic_vector(15 downto 0));
end entity;
architecture behave of sgnextd9 is
begin
z(15) <= x(8);
z(14) <= x(7);
z(13) <= x(6);
z(12) <= x(5);
z(11) <= x(4);
z(10) <= x(3);
z(9) <= x(2);
z(8) <= x(1);
z(7) <= x(0);
z(6) <= '0';
z(5) <= '0';
z(4) <= '0';
z(3) <= '0';
z(2) <= '0';
z(1) <= '0';
z(0) <= '0';
end behave;
