library ieee;
use ieee.std_logic_1164.all;

entity top is 
	port(reset: in std_logic;
		  clk: in std_logic);
end entity;

architecture behave of top is 

signal opcodebits: std_logic_vector(3 downto 0);
signal cz : std_logic_vector(1 downto 0);
signal temp_zero: std_logic;
signal temp_in: std_logic;
signal a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q,IR_en, te9_en, RF_en,ALUA_en,ALUB_en,C_en,Z_en,mem_w: std_logic;
signal ALU_op: std_logic_vector(1 downto 0);
signal c_s : std_logic_vector(3 downto 0);
signal n_s : std_logic_vector(3 downto 0);
signal debug_rf_out1: std_logic_vector(15 downto 0);
signal debug_rf_out2: std_logic_vector(15 downto 0);
signal debug_mem_data: std_logic_vector(15 downto 0);
signal debug_mem_addr: std_logic_vector(15 downto 0);

component control_path is 
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
		n_s: out std_logic_vector(3 downto 0));
end component;

component datapath is
		port(controls: in std_logic_vector(16 downto 0);
        ir_en: in std_logic;
        te9_en: in std_logic;
        rf_en: in std_logic;
        alua_en: in std_logic;
        alub_en: in std_logic;
        c_en: in std_logic;
        z_en: in std_logic;
        mem_w: in std_logic;
        alu_op: in std_logic_vector(1 downto 0);
        clk: in std_logic;
        rst_data: in std_logic;
        op_code: out std_logic_vector(3 downto 0);
        carry_flag: out std_logic;
        zero_flag: out std_logic;
		  temp_zero: out std_logic;
		  temp_in:out std_logic;
        debug_rf_out1: out std_logic_vector(15 downto 0);
        debug_rf_out2: out std_logic_vector(15 downto 0);
        debug_mem_data: out std_logic_vector(15 downto 0);
        debug_mem_addr: out std_logic_vector(15 downto 0)
        );
end component;

begin

control0: control_path
			port map(
			reset,
			opcodebits,
			cz,
			clk,
			temp_zero,
			temp_in,
			a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q,IR_en, te9_en, RF_en,ALUA_en,ALUB_en,C_en,Z_en,mem_w,
			ALU_op,
			c_s,n_s
			);

datapath0: datapath
			  port map(
			  controls(0) => a,
			  controls(1) => b,
			  controls(2) => c,
			  controls(3) => d,
			  controls(4) => e,
			  controls(5) => f,
			  controls(6) => g,
			  controls(7) => h,
			  controls(8) => i,
			  controls(9) => j,
			  controls(10) => k,
			  controls(11) => l,
			  controls(12) => m,
			  controls(13) => n,
			  controls(14) => o,
			  controls(15) => p,
			  controls(16) => q,
			  ir_en => IR_en,
			  te9_en => te9_en,
			  rf_en => RF_en,
			  alua_en => ALUA_en,
			  alub_en => ALUB_en,
			  c_en => C_en,
			  z_en => Z_en,
			  mem_w => mem_w,
			  alu_op => ALU_op,
			  clk => clk,
        	  rst_data => reset,
			  op_code => opcodebits,
			  carry_flag => cz(1),
			  zero_flag => cz(0),
			  temp_zero => temp_zero,
			  temp_in => temp_in,
        	  debug_rf_out1 => debug_rf_out1,
        	  debug_rf_out2 => debug_rf_out2,
        	  debug_mem_addr => debug_mem_addr,
        	  debug_mem_data => debug_mem_data
			  );
			  
end behave;