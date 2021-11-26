--
-- Entity Name : IF_ID_reg
-- Entity Description: 
-- Architecture Name : IF_ID_reg_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;		

entity IF_ID_reg is	 
	port(		   
		clk : in std_logic;
		instruction_in: in std_logic_vector(24 downto 0);
		pc_in : in std_logic_vector(5 downto 0);
		pc_reset : in std_logic;
		
		instruction_out: out std_logic_vector(24 downto 0);
		pc_out : out std_logic_vector(5 downto 0)
	);
end IF_ID_reg;			   

architecture IF_ID_reg_arch of IF_ID_reg is

begin 
	
	IF_ID_reg: process(clk, instruction_in, pc_in, pc_reset) 
	
	--variables to store the instruction information from previous stage
	variable instruction_store: std_logic_vector(24 downto 0);
	variable pc_store: std_logic_vector(5 downto 0);
	
	begin
		if(pc_reset = '0') then
			instruction_store := instruction_in;
			pc_store := pc_in;
			
			--pass information to next stage on next clock cycle
			if (rising_edge(clk)) then	
				instruction_out <= instruction_store;
				pc_out <= pc_store;
			end if;
		end if;
	
	end process IF_ID_reg;
	
	
	
end IF_ID_reg_arch;