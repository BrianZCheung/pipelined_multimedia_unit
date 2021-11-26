--
-- Entity Name : IF_stage_tb
-- Entity Description: testbench for our IF_stage stage
-- Architecture Name : tb_architecture
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
-- 

library ieee;
use ieee.std_logic_1164.all;   
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;

entity IF_stage_tb is
end IF_stage_tb;

architecture tb_architecture of IF_stage_tb is
	
-- stimulus signals 
signal LorF_tb : std_logic;		 
signal instrToBuffer_tb : std_logic_vector(24 downto 0);
signal pc_in_tb : std_logic_vector(31 downto 0);	

-- observed signals 
signal pc_out_tb : std_logic_vector(31 downto 0);
signal instruction_out_tb : std_logic_vector(24 downto 0);
	
	
begin
	
	-- Unit Under Test port map
	UUT : entity IF_stage
	port map (
		LorF => LorF_tb,
		instrToBuffer => instrToBuffer_tb,
		pc_in => pc_in_tb,
		pc_out => pc_out_tb,
		instruction_out => instruction_out_tb
		);
	
	stimlus: process	  
	begin
		
		LorF_tb <= '0'; 
		wait for 100ns;
		
		pc_in_tb <= std_logic_vector(to_unsigned(0, 32));
		instrToBuffer_tb <= "0000000000000000000000000";	   
		wait for 100ns;	
		
   		pc_in_tb <= std_logic_vector(to_unsigned(1, 32));
		instrToBuffer_tb <= "0000000000000000000000010";	   
		wait for 100ns;	
		
		pc_in_tb <= std_logic_vector(to_unsigned(2, 32));
		instrToBuffer_tb <= "0000000000000000000000100";	   
		wait for 100ns;	
		
		LorF_tb <= '1';
		wait for 100ns;
		
		pc_in_tb <= std_logic_vector(to_unsigned(0, 32));	   
		wait for 100ns;	
		
   		pc_in_tb <= pc_out_tb;	   
		wait for 100ns;	
		
		pc_in_tb <= pc_out_tb;	   
		wait for 100ns;		
		
		pc_in_tb <= pc_out_tb;	   
		wait for 100ns;	
	
	std.env.finish;
	end process;	
	
	
	
end tb_architecture;
