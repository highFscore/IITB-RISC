
-----------------------------------------------
library std; 
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------
entity control_path is 
	port(
		rst: in std_logic;
		opcodebits: in std_logic_vector(3 downto 0);
		cz : in std_logic_vector(1 downto 0);
		clk: in std_logic;
		temp_zero: in std_logic;
		temp_in: in std_logic;
		a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q,IR_en, te9_en, RF_en,ALUA_en,ALUB_en,C_en,Z_en,mem_w: out std_logic;
		ALU_op: out std_logic_vector(1 downto 0);
		c_s: out std_logic_vector(3 downto 0);
		n_s: out std_logic_vector(3 downto 0)
		);
end entity;

architecture behave of control_path is 

	type state is (S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17);
	type opcodetype is (add,adc,adz,adi,ndu,ndc,ndz,lhi,lw,sw,sm,lm,beq,jal,jlr);
	signal present_state, next_state : state;
	signal opcode : opcodetype;

begin

syncronous_process : process (clk, rst)
begin
if rising_edge(clk) then
if (rst = '1') then
present_state <= S1;
else
present_state <= next_state;
end if;
end if;
end process;

--current_state <= present_state;

opcode_assign: process (opcodebits,cz)
begin
if	(opcodebits = "0000" and cz ="00") then opcode <= add;
elsif	(opcodebits = "0000" and cz ="10") then opcode <= adc;
elsif	((opcodebits = "0000") and (cz ="01")) then opcode <= adz;
elsif	((opcodebits = "0010") and (cz ="00")) then opcode <= ndu;
elsif	((opcodebits = "0010") and (cz ="10")) then opcode <= ndc;
elsif	((opcodebits = "0010") and (cz ="01")) then opcode <= ndz;
elsif  (opcodebits = "0001") then opcode <= adi;
elsif  (opcodebits = "0011") then opcode <= lhi;
elsif  (opcodebits = "0100") then opcode <= lw; 
elsif  (opcodebits = "0101") then opcode <= sw;
elsif  (opcodebits = "0110") then opcode <= lm;
elsif  (opcodebits = "0111") then opcode <= sm;
elsif  (opcodebits = "1100") then opcode <= beq;
elsif  (opcodebits = "1000") then opcode <= jal;
elsif  (opcodebits = "1001") then opcode <= jlr;
end if;
end process opcode_assign;

next_state_and_output_decoder : process(present_state, next_state, opcode, temp_zero, temp_in)
begin

case (present_state) is

when S1 =>
c_s <= "0000";
n_s <= "0001";
next_state <= S2;
a<='0';
b<='0';
k<='1';
l<='0';
n<='0';
o<='0';
p<='1';
IR_en<='1';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="00";

when S2 =>
c_s <= "0001";
if (opcode=add or opcode=adc or opcode=adz or opcode=adi or opcode=ndu or opcode=ndc or opcode=ndz or opcode=lw or opcode= sw or opcode= beq) then
next_state <= S3;
n_s <= "0010";
e<='0';
f<='1';
g<='1';
i<='1';
j<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";
elsif (opcode=lhi) then
next_state <= S5;
n_s <= "0100";
e<='0';
f<='1';
g<='1';
i<='1';
j<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";
elsif(opcode=jal or opcode=jlr) then
next_state <= S9;
n_s <= "1000";
e<='0';
f<='1';
g<='1';
i<='1';
j<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";
elsif(opcode=lm or opcode=sm) then
next_state <= S13;
n_s <= "1100";
e<='0';
f<='1';
g<='1';
i<='1';
j<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";
end if;

when S3 =>
c_s <= "0010";
if (opcode=add or opcode=adc or opcode=adz or opcode=ndu or opcode=ndc or opcode=ndz) then
next_state <= S4;
n_s <= "0011";
a<='0';
b<='1';
c<='0';
d<='1';
k<='0';
l<='0';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='1';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";

elsif(opcode=adi) then
next_state <= S4;
n_s <= "0011";
a<='0';
b<='1';
k<='1';
l<='1';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="01";
elsif(opcode=beq) then
next_state <= S17;
n_s <= "0111";
a<='0';
b<='1';
c<='0';
d<='1';
k<='0';
l<='0';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='1';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";

elsif(opcode=lw) then
next_state <= S6;
n_s <= "0101";
a<='1';
b<='0';
k<='1';
l<='1';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="00";

elsif(opcode=sw) then
next_state <= S7;
n_s <= "0110";
a<='1';
b<='0';
c<='0';
d<='0';
k<='1';
l<='1';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='1';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="00";
end if;

when S17 =>
c_s <= "1111";
next_state <= S8;
n_s <= "0111";
ALU_op<="11";

when S4 =>
c_s <= "0011";
next_state <= S1;
n_s <= "0000";
i<='1';
j<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
if (opcode=ndu or opcode=ndc or opcode=ndz) then
ALU_op<="10";
elsif (opcode=add or opcode=adc or opcode=adz or opcode=adi) then
ALU_op<="00";
end if;

if(opcode=adi) then
e<='0';
f<='0';
g<='0';
else
e<='0';
f<='1';
g<='0';
end if;

when S5 =>
c_s <= "0100";
next_state <= S1;
n_s <= "0000";
e<='0';
f<='0';
g<='0';
i<='0';
j<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="01";


when S6 =>
c_s <= "0101";
next_state <= S1;
n_s <= "0000";
e<='0';
f<='0';
g<='0';
i<='0';
j<='1';
n<='0';
o<='1';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="01";

when S7 =>
c_s <= "0110";
next_state <= S1;
n_s <= "0000";
n<='0';
o<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='1';
ALU_op<="00";

when S8 =>
c_s <= "0111";
if (temp_zero = '1') then
next_state <= S4;
n_s <= "0011";
a<='0';
b<='0';
k<='1';
l<='1';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="00";
elsif(temp_zero= '0') then
next_state <= S1;
n_s <= "0000";
a<='0';
b<='0';
k<='1';
l<='1';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="00";
end if;

when S9 =>
c_s <= "1000";
next_state <= S10;
n_s <= "1001";
a<='0';
b<='0';
k<='0';
l<='1';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";

when S10 =>
c_s <= "1001";
next_state <= S11;
n_s <= "1010";
e<='0';
f<='0';
g<='0';
i<='1';
j<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="00";


when S11 =>
c_s <= "1010";
if (opcode=jal) then
next_state <= S12;
n_s <= "1011";
a<='0';
b<='0';
k<='1';
l<='1';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";

elsif(opcode=jlr) then
next_state <= S12;
n_s <= "1011";
a<='1';
b<='0';
k<='0';
l<='1';
p<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="01";
end if;

when S12 =>
c_s <= "1011";
next_state <= S1;
n_s <= "0000";
e<='0';
f<='1';
g<='1';
i<='1';
j<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="00";


when S13 =>
c_s <= "1100";
if (opcode=sw) then
next_state <= S14;
n_s <= "1101";
a<='0';
b<='1';
h<='0';
k<='0';
l<='1';
p<='1';
IR_en<='0';
te9_en<='1';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="00";
elsif(opcode=lw) then
next_state <= S15;
n_s <= "1110";
a<='0';
b<='1';
k<='0';
l<='1';
p<='1';
IR_en<='0';
te9_en<='1';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="00";
end if;

when S14 =>
c_s <= "1101";
next_state <= S16;
n_s <= "1111";
c<='1';
d<='0';
k<='1';
l<='0';
n<='0';
o<='1';
p<='0';
q<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='1';
ALU_op<="00";

when S15 =>
c_s <= "1110";
next_state <= S16;
n_s <= "1111";
e<='1';
f<='0';
g<='0';
i<='0';
j<='1';
k<='1';
l<='0';
n<='0';
o<='1';
p<='0';
IR_en<='0';
te9_en<='0';
RF_en<='1';
ALUA_en<='1';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="00";

when S16 =>
c_s <= "1111";
if(temp_in/= '0' and opcode=sm)then
next_state <= S14;
n_s <= "1101";
h<='1';
k<='0';
l<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';

mem_w<='0';
ALU_op<="00";
elsif(temp_in/= '0' and opcode=lm) then
next_state <= S15;
n_s <= "1110";
h<='1';
k<='0';
l<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="00";

elsif(temp_in= '0') then
next_state <= S1;
n_s <= "0000";
h<='1';
k<='0';
l<='1';
IR_en<='0';
te9_en<='0';
RF_en<='0';
ALUA_en<='0';
ALUB_en<='0';
C_en<='0';
Z_en<='0';
mem_w<='0';
ALU_op<="00";
end if;

end case;
end process;
 
end behave;