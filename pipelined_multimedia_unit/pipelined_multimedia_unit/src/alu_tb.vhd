library ieee;
use ieee.std_logic_1164.all;   
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;

entity alu_tb is
end alu_tb;

architecture tb_architecture of alu_tb is
	
-- stimulus signals 
signal instruction_in_tb : std_logic_vector(24 downto 0);
signal rs_1_tb : std_logic_vector(127 downto 0);
signal rs_2_tb : std_logic_vector(127 downto 0);
signal rs_3_tb : std_logic_vector(127 downto 0);
signal rs_4_tb : std_logic_vector(127 downto 0);
-- observed signals 
signal rd_tb : std_logic_vector(127 downto 0);	 
	
	
begin
	
	-- Unit Under Test port map
	UUT : entity alu
	port map (
		instruction_in => instruction_in_tb,
		rs_1 => rs_1_tb,
		rs_2 => rs_2_tb,
		rs_3 => rs_3_tb,
		rd => rd_tb
		);
	
	stimlus: process 
	begin
		rs_1_tb <= std_logic_vector(to_signed(5, 128));	   
		rs_2_tb <= std_logic_vector(to_signed(2, 128));  
		rs_3_tb <= std_logic_vector(to_signed(6, 128));
		wait for 100ns;
		instruction_in_tb <= "1000000000000000000000000";
		wait for 200ns;
		
	std.env.finish;
	end process;	
	
	
	
end tb_architecture;



