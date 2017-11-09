library ieee;
use ieee.std_logic_1164.all;

entity datapath is
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
end entity;
architecture Struct of datapath is
    component reg is
        generic (nbits : integer);
        port (
        din  : in  std_logic_vector(nbits-1 downto 0);
        dout : out std_logic_vector(nbits-1 downto 0);
        enable: in std_logic;
        reset: in std_logic;
        clk     : in  std_logic);
    end component;
    component register_file is
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
    end component;
    component ALU is
        port(alu_in_1, alu_in_2: in std_logic_vector(15 downto 0);
              op_in: in std_logic_vector(1 downto 0);
              alu_out: out std_logic_vector(15 downto 0);
              carry: out std_logic;
              zero: out std_logic);
    end component;
    component Memory is
      port(
         mem_out      : out std_logic_vector(15 downto 0);
         data         : in std_logic_vector(15 downto 0);
         addr         : in  std_logic_vector(15 downto 0);
         mem_write    : in  std_logic;
         clk          : in  std_logic
         );
    end component;
    component comparator is
        port (x: in std_logic_vector(15 downto 0);
            z : out std_logic);
    end component;
	 component comparator8 is
		  port (x: in std_logic_vector(7 downto 0);
			z : out std_logic);
	 end component;
    component mux2 is
        generic (nbits : integer);
        port (s0,s1 : in std_logic_vector(nbits-1 downto 0);
            z : out std_logic_vector(nbits-1 downto 0);
            dn : in std_logic);
    end component;
    component mux4 is
        generic (nbits : integer);
        port (s0,s1,s2,s3 : in std_logic_vector(nbits-1 downto 0);
            z : out std_logic_vector(nbits-1 downto 0);
            dn1,dn0 : in std_logic);
    end component;
    component mux8 is
        generic (nbits : integer);
        port (s0,s1,s2,s3,s4,s5,s6,s7 : in std_logic_vector(nbits-1 downto 0);
            z : out std_logic_vector(nbits-1 downto 0);
            dn1,dn0,dn2 : in std_logic);
    end component;
    component priority_encoder is
      port (
         pe_in  : in  std_logic_vector(7 downto 0);
         pe_out  : out  std_logic_vector(2 downto 0);
         check_out  : out  std_logic
         );
    end component;
    component sgnextd9 is
        port (x : in std_logic_vector(8 downto 0);
            z : out std_logic_vector(15 downto 0));
    end component;
    component sgnextd6 is
        port (x : in std_logic_vector(5 downto 0);
            z : out std_logic_vector(15 downto 0));
    end component;
	 component pe_demux_and is
		port (x: in std_logic_vector(7 downto 0);
				selector: in std_logic_vector(2 downto 0);
				z: out std_logic_vector(7 downto 0)
				);
	 end component;
    
    signal ir_out, from_se6, from_se9, mux_to_rf_data, from_rf_out1, from_rf_out2, from_alu_out, from_alu_a, from_alu_b, from_alu_b_mux, from_mem_out, from_rf_out1_mux, to_mem_addr, to_mem_data: std_logic_vector(15 downto 0);
    signal imm6: std_logic_vector(5 downto 0);
    signal imm9: std_logic_vector(8 downto 0);
    signal imm8, pe_modified, to_temp_pe, to_pe: std_logic_vector(7 downto 0);
    signal ir_out_3_5, ir_out_6_8, ir_out_9_11, to_rf_r1, to_rf_r2, to_rf_write, from_pe_out: std_logic_vector(2 downto 0);
    signal reset_internal, from_alu_carry, from_alu_zero, from_mem_comp, to_zero_flag, temp: std_logic;

begin

    reset_internal <=rst_data;

    IR:  reg generic map(16)
    port map(from_mem_out, ir_out, ir_en, reset_internal, clk);

    op_code <= ir_out(15 downto 12);

    ir_out_9_11 <= ir_out(11 downto 9);
    ir_out_6_8 <= ir_out(8 downto 6);
    ir_out_3_5 <= ir_out(5 downto 3);

    imm9 <= ir_out(8 downto 0);
    imm6 <= ir_out(5 downto 0);
	 imm8 <= ir_out(7 downto 0);

    se9: sgnextd9 port map(imm9, from_se9);

    se6: sgnextd6 port map(imm6, from_se6);

    mux_for_rf_r1: mux4 generic map(3)
    port map(s0 => "111",
             s1 => ir_out_9_11,
             s2 => ir_out_6_8,
             s3 => "000",
             z => to_rf_r1,
             dn1 => controls(0),
             dn0 =>controls(1));

    mux_for_rf_r2: mux4 generic map(3)
    port map(s0 => ir_out_9_11,
             s1 => ir_out_6_8,
             s2 => from_pe_out,
             s3 => "000",
             z => to_rf_r2,
             dn1 => controls(2),
             dn0 =>controls(3));

    mux_for_rf_write: mux8 generic map(3)
    port map(s0 => ir_out_9_11,
             s1 => ir_out_6_8,
             s2 => ir_out_3_5,
             s3 => "111",
             s4 => from_pe_out,
             s5 => "000",
             s6 => "000",
             s7 => "000",
             z => to_rf_write,
             dn2 => controls(4),
             dn1 => controls(5),
             dn0 =>controls(6));

    mux_for_rf_data: mux4 generic map(16)
    port map(s0 => from_se9,
             s1 => from_mem_out,
             s2 => from_alu_out,
             s3 => "0000000000000000",
             z => mux_to_rf_data,
             dn1 => controls(8),
             dn0 =>controls(9));

    rf: register_file
        port map(
         RF_R1  => to_rf_r1,
         RF_R2  => to_rf_r2,
         RF_data  => mux_to_rf_data,
         RF_write => to_rf_write,
         RF_enable => rf_en,
         reset => reset_internal,
         clk => clk,
         RF_out1 => from_rf_out1,
         RF_out2 => from_rf_out2
         );

    debug_rf_out1<= from_rf_out1;
    debug_rf_out2<= from_rf_out2;

    mux_between_rf_out1_and_alu_a: mux2 generic map(16)
    port map(s0 => from_alu_out,
             s1 => from_rf_out1,
             z => from_rf_out1_mux,
             dn => controls(15));

    alu_a: reg generic map(16)
    port map(from_rf_out1_mux, from_alu_a, alua_en, reset_internal, clk);

    alu_b: reg generic map(16)
    port map(from_rf_out2, from_alu_b, alub_en, reset_internal, clk);

    mux_for_alu_in2: mux4 generic map(16)
    port map(s0 => from_alu_b,
             s1 => "0000000000000000",
             s2 => "0000000000000001",
             s3 => from_se6,
             z => from_alu_b_mux,
             dn1 => controls(10),
             dn0 =>controls(11));

    alu0: ALU
         port map(
            alu_in_1 => from_alu_a, 
            alu_in_2 => from_alu_b_mux,
            op_in => alu_op,
            alu_out => from_alu_out,
            carry => from_alu_carry,
            zero => from_alu_zero
            );
	 
	 temp_zero<=from_alu_zero;
	 
    mux_for_zero_flag: mux2 generic map(1)
    port map(s0(0) => from_mem_comp,
             s1(0) => from_alu_zero,
             z(0) => to_zero_flag,
             dn => controls(12));

    zero_flag_reg:  reg generic map(1)
	 port map(
        din(0) => to_zero_flag,
        dout(0) => zero_flag,
        enable => z_en,
        reset => reset_internal,
        clk => clk);

    carry_flag_reg:  reg generic map(1)
	 port map(
        din(0) => from_alu_carry,
        dout(0) => carry_flag,
        enable => c_en,
        reset => reset_internal,
        clk => clk);

    mux_for_alu_out: mux4 generic map(16)
    port map(s0 => from_rf_out1,
             s1 => from_alu_out,
             s2 => from_alu_b,
             s3 => "0000000000000000",
             z => to_mem_addr,
             dn1 => controls(13),
             dn0 =>controls(14));

    mux_for_mem_data: mux2 generic map(16)
    port map(s0 => from_alu_b,
             s1 => from_rf_out2,
             z => to_mem_data,
             dn => controls(16));

    mem0: Memory
          port map(
            mem_out => from_mem_out,
            data => to_mem_data,
            addr => to_mem_addr,
            mem_write => mem_w,
            clk => clk
            );

    debug_mem_addr <= to_mem_addr;
    debug_mem_data <= to_mem_data;    

    mem_comp: comparator
              port map( 
                x =>from_mem_out,
                z => from_mem_comp
                );
					 
	pe0: priority_encoder
			port map(
         pe_in => to_pe,
         pe_out => from_pe_out,
         check_out => temp
         );
			
	mux_for_pe: mux2 generic map(8)
         port map( 
			s0 => imm8,
			s1 => pe_modified,
			z => to_temp_pe,
			dn => controls(7)
			);
				 
	temp_pe: reg generic map(8)
		  port map(
        din => to_temp_pe,
        dout => to_pe,
        enable => te9_en,
        reset => reset_internal,
        clk => clk
		  );
	pe_comp: comparator8
            port map( 
            x => to_temp_pe,
            z => temp_in
            );
	demux_and: pe_demux_and
		port map (x => to_pe,
				selector => from_pe_out,
				z =>pe_modified
				);

end Struct;