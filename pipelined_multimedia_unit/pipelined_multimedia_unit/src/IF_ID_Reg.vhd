--
-- Entity Name : IF_ID_stage
-- Entity Description: 
-- Architecture Name : IF_ID_stage_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;		

entity IF_ID_stage is	 
	port(		   
		clk : in std_logic;
		instruction_in: in std_logic_vector(24 downto 0);
		instruction_out: out std_logic_vector(24 downto 0)
	);
end IF_ID_stage;			   

architecture IF_ID_stage_arch of IF_ID_stage is

begin 
	
	IF_ID_stage: process(clk) 
	
	--variables to store the instruction information from previous stage
	variable instruction_store: std_logic_vector(24 downto 0);
	
	begin	 
		
		instruction_store := instruction_in;
		
		--pass information to next stage on next clock cycle
		if (rising_edge(clk)) then	
			instruction_out <= instruction_store;
		end if;
	
	end process IF_ID_stage;

end IF_ID_stage_arch;