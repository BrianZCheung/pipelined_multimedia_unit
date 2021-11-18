--
-- Entity Name : IF_stage
-- Entity Description: 
-- Architecture Name : IF_stage_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;	  

entity IF_stage is
	port(	 
	pc : in std_logic_vector(31 downto 0);
	instruction_out : out std_logic_vector(24 downto 0)-- instruction being executed	
	);
end IF_stage;

architecture IF_stage_arch of IF_stage is	

type instr_buffer_arr is array (63 downto 0) of std_logic_vector(24 downto 0);
signal instr_buffer : instr_buffer_arr := (others=>(others=>'0'));

begin			   

	IF_module: process(pc)	  
	begin					  
		
		instruction_out <= instr_buffer(integer(to_integer(unsigned(pc)) / 4));
	
	end process IF_module;

end IF_stage_arch;