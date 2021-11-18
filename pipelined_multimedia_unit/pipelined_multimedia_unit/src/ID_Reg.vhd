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

entity ID_Reg is
	port(
	i_fetch : in std_logic_vector(24 downto 0);-- instruction being executed	
	i_wb : in std_logic_vector(24 downto 0);-- instruction of the write back data 
	rs_1 : out std_logic_vector(127 downto 0);   
	rs_2 : out std_logic_vector(127 downto 0);
	rs_3 : out std_logic_vector(127 downto 0);
	rd : in std_logic_vector(127 downto 0)
	);
end ID_Reg;

architecture ID_Reg_arch of ID_Reg is	 	

begin
	
	ID_Reg: process(i_fetch, rd)
	begin 			  
		
		
		
	end process ID_Reg;
	
end ID_Reg_arch;