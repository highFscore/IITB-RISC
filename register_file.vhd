library ieee;
use ieee.std_logic_1164.all;

entity register_file is
  port (
    RF_R1  : in  std_logic_vector(2 downto 0);
    RF_R2  : in  std_logic_vector(2 downto 0);
    RF_data  : in  std_logic_vector(15 downto 0);
    RF_write : in std_logic_vector(2 downto 0);
    RF_enable: in std_logic;
    reset: in std_logic;
    clk     : in  std_logic;
    RF_out1 : out std_logic_vector(15 downto 0);
    RF_out2 : out std_logic_vector(15 downto 0)
    );
end entity;

architecture struct of register_file is
--Register Component
  component reg is
    generic (nbits : integer);
    port (
      din  : in  std_logic_vector(nbits-1 downto 0);
      dout : out std_logic_vector(nbits-1 downto 0);
      enable: in std_logic;
      reset: in std_logic;
      clk : in  std_logic);
  end component;

--Extra Signals
  signal r_en : std_logic_vector(7 downto 0);
  signal r_out0,r_out1,r_out2,r_out3,r_out4,r_out5,r_out6,r_out7 : std_logic_vector(15 downto 0);

begin 


process(RF_enable,RF_R1,RF_R2,RF_data,RF_write,reset,clk,r_out0,r_out1,r_out2,r_out3,r_out4,r_out5,r_out6,r_out7)
begin

--Register FIle Writing Process
  if(RF_enable = '0') then
  	r_en <= "00000000";
  elsif(RF_write = "000" and RF_enable = '1') then
  	r_en <= "00000001";
  elsif(RF_write = "001" and RF_enable = '1') then
  	r_en <= "00000010";
  elsif(RF_write = "010" and RF_enable = '1') then
  	r_en <= "00000100";
  elsif(RF_write = "011" and RF_enable = '1') then
  	r_en <= "00001000";
  elsif(RF_write = "100" and RF_enable = '1') then
  	r_en <= "00010000";
  elsif(RF_write = "101" and RF_enable = '1') then
  	r_en <= "00100000";
  elsif(RF_write = "110" and RF_enable = '1') then
  	r_en <= "01000000";
  else 
  	r_en <= "10000000";
  end if;

--Register Reading Process
--RF_R1
    if(RF_R1 = "000") then
      RF_out1 <= r_out0;
    elsif(RF_R1 = "001") then
      RF_out1 <= r_out1;
    elsif(RF_R1 = "010") then
    RF_out1 <= r_out2;
    elsif(RF_R1 = "011") then
    RF_out1 <= r_out3;
    elsif(RF_R1 = "100") then
    RF_out1 <= r_out4;
    elsif(RF_R1 = "101") then
    RF_out1 <= r_out5;
    elsif(RF_R1 = "110") then
    RF_out1 <= r_out6;
    else
    RF_out1 <= r_out7;
    end if;
--RF_R2
    if(RF_R2 = "000") then
      RF_out2 <= r_out0;
    elsif(RF_R2 = "001") then
      RF_out2 <= r_out1;
    elsif(RF_R2 = "010") then
    RF_out2 <= r_out2;
    elsif(RF_R2 = "011") then
    RF_out2 <= r_out3;
    elsif(RF_R2 = "100") then
    RF_out2 <= r_out4;
    elsif(RF_R2 = "101") then
    RF_out2 <= r_out5;
    elsif(RF_R2 = "110") then
    RF_out2 <= r_out6;
    else 
    RF_out2 <= r_out7;
    end if;

end process;

--Register Component Declaration(With Correpsonding Port Maps)
   R0 : reg generic map(16)
    port map(RF_data, r_out0, r_en(0) ,reset,clk);

   R1 : reg generic map(nbits => 16) 
    port map(RF_data, r_out1, r_en(1) ,reset,clk);

   R2 : reg generic map(nbits => 16) 
    port map(RF_data, r_out2, r_en(2) ,reset,clk);
 
   R3 : reg generic map(nbits => 16) 
    port map(RF_data, r_out3, r_en(3) ,reset,clk);

   R4 : reg generic map(nbits => 16) 
    port map(RF_data, r_out4, r_en(4) ,reset,clk);

   R5 : reg generic map(nbits => 16) 
    port map(RF_data, r_out5, r_en(5) ,reset,clk);

   R6 : reg generic map(nbits => 16) 
    port map(RF_data, r_out6, r_en(6) ,reset,clk);

   R7 : reg generic map(nbits => 16)
    port map(RF_data, r_out7, r_en(7) ,reset,clk);

  

end struct;
