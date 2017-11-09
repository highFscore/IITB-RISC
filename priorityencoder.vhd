library ieee;
use ieee.std_logic_1164.all;

entity priority_encoder is
  port (
    pe_in  : in  std_logic_vector(7 downto 0);
    pe_out  : out  std_logic_vector(2 downto 0);
    check_out  : out  std_logic
    );
end entity;

architecture pe_behave of priority_encoder is

begin
process (pe_in)
begin
    if(pe_in = "00000000") then
        check_out <= '1';
    else
        check_out <= '0';
    end if;

    if(pe_in(0) = '1') then
        pe_out <= "000";
    elsif(pe_in(1) = '1') then
        pe_out <= "001";
    elsif(pe_in(2) = '1') then
        pe_out <= "010";
    elsif(pe_in(3) = '1') then
        pe_out <= "011";
    elsif(pe_in(4) = '1') then
       pe_out <= "100";
    elsif(pe_in(5) = '1') then
        pe_out <= "101";
    elsif(pe_in(6) = '1') then
        pe_out <= "110";
    else
        pe_out <= "111";
    end if;
end process;
end pe_behave;