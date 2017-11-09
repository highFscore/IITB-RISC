library ieee;
use ieee.std_logic_1164.all;

entity reg is
  generic (nbits : integer);
  port (
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    reset: in std_logic;
    clk     : in  std_logic);
end reg;

architecture behave of reg is
shared variable zero : std_logic_vector(nbits-1 downto 0);
begin  -- behave

process(clk,reset)
begin
  for i in 0 to nbits-1 loop
    zero(i):='0';
  end loop;
  if(reset = '1') then
  dout<=zero;
  else
   if(clk'event and clk = '1') then
     if enable = '1' then
       dout <= din;
     end if;
   end if;
  end if;
end process;
end behave;
