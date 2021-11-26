--
-- Entity Name : WB_stage
-- Entity Description: 
-- Architecture Name : WB_stage_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;	  

entity WB_stage is
	port(
	instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed	
	rd_in : in std_logic_vector(127 downto 0);	
	
	rd_out : out std_logic_vector(127 downto 0);   
	wr_enabled : out std_logic
	);
end WB_stage;

architecture WB_stage_arch of WB_stage is	 	   



begin		  															
	
	WB_stage: process(instruction_in, rd_in)			 			
	
	variable rd_in_var : std_logic_vector(127 downto 0);
	
	begin 		
		
		--update rd_in:
		rd_in_var := rd_in;
		
		
		--check if the instruction is a NOP:
		if(instruction_in(24 downto 23) = "11" and instruction_in(18 downto 15) = "0000") then
			wr_enabled <= '0';
		--check if the instruction isn't garbage values:
		elsif(instruction_in(24) = '1' or instruction_in(24) = '0')	then
			wr_enabled <= '1';
		else
			wr_enabled <= '0';
		end if;
		
		
		rd_out <= rd_in_var;
		
		
	end process WB_stage;
	
end WB_stage_arch;