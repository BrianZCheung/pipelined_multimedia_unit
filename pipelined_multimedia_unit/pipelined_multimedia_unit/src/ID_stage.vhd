--
-- Entity Name : ID_stage
-- Entity Description: 
-- Architecture Name : ID_stage_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;	  

entity ID_stage is
	port(
	i_fetch : in std_logic_vector(24 downto 0);-- instruction being executed	
	i_wb : in std_logic_vector(24 downto 0);-- instruction of the write back data 		 
	rd : in std_logic_vector(127 downto 0);	
	rs_1 : out std_logic_vector(127 downto 0);   
	rs_2 : out std_logic_vector(127 downto 0);
	rs_3 : out std_logic_vector(127 downto 0)
	);
end ID_stage;

architecture ID_stage_arch of ID_stage is	 	   



begin		  															
	
	ID_stage: process(i_fetch, rd)			 			
	
	type REG is array (31 downto 0) of std_logic_vector(127 downto 0);
	variable registers : REG := (others=>(others=>'0'));
	
	begin 		
		
		--write rd into register from write back
		registers(to_integer(unsigned(i_wb(4 downto 0)))) := rd;
		
		
		--reads rs1 rs2 rs3 from register depending on instruction
		
		--4.1 instructions	 
		--Load Immediate
		if(i_fetch(24) = '0') then
			--assumes rs1 to be rd
			rs_1 <= registers(to_integer(unsigned(i_fetch(4 downto 0))));	 
			
		--4.2 instructions 
		--Multiply-Add and Multiply-Subtract R4-Instruction Format
		elsif(i_fetch(24 downto 23) = "10") then	  
			rs_3 <= registers(to_integer(unsigned(i_fetch(19 downto 15))));
			rs_2 <= registers(to_integer(unsigned(i_fetch(14 downto 10))));
			rs_1 <= registers(to_integer(unsigned(i_fetch(9 downto 5))));	 
			
		--4.3 instructions	
		--R3-Instruction Format
		elsif(i_fetch(24 downto 23) = "11") then	  
			rs_2 <= registers(to_integer(unsigned(i_fetch(14 downto 10))));
			rs_1 <= registers(to_integer(unsigned(i_fetch(9 downto 5))));
		end if;
		
		
	end process ID_stage;
	
end ID_stage_arch;