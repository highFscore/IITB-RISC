library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux8 is
  	generic (nbits : integer);
	port (s0,s1,s2,s3,s4,s5,s6,s7 : in std_logic_vector(nbits-1 downto 0);
		z : out std_logic_vector(nbits-1 downto 0);
		dn1,dn0,dn2 : in std_logic);
end entity;
architecture struct_mux8 of mux8 is
begin

process(s0,s1,s2,s3,s4,s5,s6,s7,dn0,dn1,dn2)
begin
if (dn0='0' and dn1= '0' and dn2= '0') then 
z <=s0;
elsif (dn0='1' and dn1= '0' and dn2= '0') then 
z <=s1;
elsif (dn0='0' and dn1= '1' and dn2= '0') then 
z <=s2;
elsif (dn0='1' and dn1= '1' and dn2= '0') then 
z <=s3;
elsif (dn0='0' and dn1= '0' and dn2= '1') then 
z <=s4;
elsif (dn0='1' and dn1= '0' and dn2= '1') then 
z <=s5;
elsif (dn0='0' and dn1= '1' and dn2= '1') then 
z <=s6;
else 
z <=s7;
end if;
end process;

end struct_mux8;
