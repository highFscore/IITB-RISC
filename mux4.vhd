library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
  	generic (nbits : integer);
	port (s0,s1,s2,s3 : in std_logic_vector(nbits-1 downto 0);
		z : out std_logic_vector(nbits-1 downto 0);
		dn1,dn0 : in std_logic);
end entity;
architecture struct_mux4 of mux4 is
begin

process(s1,s0,s2,s3,dn0,dn1)
begin
if (dn0='0' and dn1= '0') then 
z <=s0;
elsif (dn0='1' and dn1= '0') then 
z <=s1;
elsif (dn0='0' and dn1= '1') then 
z <=s2;
else  
z <=s3;
end if;

end process;

end struct_mux4;
