library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
  	generic (nbits : integer);
	port (s0,s1 : in std_logic_vector(nbits-1 downto 0);
		z : out std_logic_vector(nbits-1 downto 0);
		dn : in std_logic);
end entity;
architecture struct_mux2 of mux2 is
begin

process(s1,s0,dn)
begin
if (dn='0') then 
z <=s0;
else 
z <=s1;
end if;

end process;

end struct_mux2;
