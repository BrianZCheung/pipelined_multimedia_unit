--
-- Entity Name : alu
-- Entity Description: 
-- Architecture Name : alu_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;

entity alu is
	port(
		instruction_in : in std_logic_vector(24 downto 0)-- instruction being executed
	);
end alu;

architecture alu_arch of alu is	 

begin
	
	li: process(instruction_in(24))
	begin 
		if(instruction_in(24) = '0') then
			
		end if;
	end process li;
	
	r3: process(instruction_in(24 downto 23))
	begin  
		if(instruction_in(24 downto 23) = "10") then
			
		end if;	
	end process r3;
	
	r4: process(instruction_in(24 downto 23))
	begin
		if(instruction_in(24 downto 23) = "11") then
			
		end if;
	end process r4;
	
end alu_arch;