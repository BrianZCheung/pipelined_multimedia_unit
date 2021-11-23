--
-- Entity Name : EX_WB_Reg
-- Entity Description: 
-- Architecture Name : EX_WB_Reg_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;		

entity EX_WB_Reg is	 
	port(		   
		clk : in std_logic;
		rd_in : in std_logic_vector(127 downto 0);   		
		rd_address_in : in std_logic_vector(4 downto 0);
		instruction_in: in std_logic_vector(24 downto 0);
		rd_out : out std_logic_vector(127 downto 0);
		rd_address_out : out std_logic_vector(4 downto 0);
		instruction_out: out std_logic_vector(24 downto 0)
	);
end EX_WB_Reg;			   

architecture EX_WB_Reg_arch of EX_WB_Reg is

begin 
	
	EX_WB_Reg: process(rd_in, clk) 
	
	--variables to store the register information from previous stage
	variable rd_reg_store: std_logic_vector(127 downto 0); 	   
	variable rd_address_reg_store: std_logic_vector(4 downto 0);
	variable instruction_store: std_logic_vector(24 downto 0);
	
	begin	 
		
		rd_reg_store := rd_in; 		   
		rd_address_reg_store := rd_address_in;
		instruction_store := instruction_in;
		
		--pass information to next stage on next clock cycle
		if (rising_edge(clk)) then
			rd_out <= rd_reg_store;	 
			rd_address_out <= rd_address_reg_store;
			instruction_out <= instruction_store;
		end if;
	
	end process EX_WB_Reg;

end EX_WB_Reg_arch;