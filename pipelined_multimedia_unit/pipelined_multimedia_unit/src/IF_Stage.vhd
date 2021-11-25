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
	LorF: in std_logic; --flag to load instruction buffer or fetch from instruction buffer		   
	instrToBuffer : in std_logic_vector(24 downto 0);
	pc_in : in std_logic_vector(31 downto 0);		  
	pc_out : out std_logic_vector(31 downto 0);
	instruction_out : out std_logic_vector(24 downto 0)-- instruction being executed	
	);
end IF_stage;  


architecture IF_stage_arch of IF_stage is	

constant MAX_BUFFER : integer := 64;

type instr_buffer_arr is array ((MAX_BUFFER-1) downto 0) of std_logic_vector(24 downto 0);
signal instr_buffer : instr_buffer_arr;

begin			   
	
	IB_load: process(instrToBuffer)
	begin
		if(LorF = '0' and to_integer(unsigned(pc_in)) < MAX_BUFFER) then
			instr_buffer(to_integer(unsigned(pc_in))) <= instrToBuffer;
		end if;
	end process IB_load;
	
	IF_module: process(pc_in)	  
	begin					  
		
		if(LorF = '1' and to_integer(unsigned(pc_in)) < MAX_BUFFER) then
			instruction_out <= instr_buffer(to_integer(unsigned(pc_in)));	 
			pc_out <= std_logic_vector(to_unsigned(to_integer(unsigned(pc_in)) + 1, 32));
		end if;
	
	end process IF_module;

end IF_stage_arch;