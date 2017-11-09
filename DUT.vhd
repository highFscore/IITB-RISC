-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  two-bit adder.
entity DUT is
   port(input_vector: in bit_vector(7 downto 0);
       	output_vector: out bit_vector(3 downto 0));
end entity;

architecture DutWrap of DUT is
   component priority_encoder is
     port (
          pe_in  : in  bit_vector(7 downto 0);
          pe_out  : out  bit_vector(2 downto 0);
          check_out  : out  bit
          );
   end component;
begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   pe_instance: priority_encoder 
			port map (
					pe_in => input_vector(7 downto 0),
					pe_out => output_vector(2 downto 0),
					check_out => output_vector(3)
      );

end DutWrap;

