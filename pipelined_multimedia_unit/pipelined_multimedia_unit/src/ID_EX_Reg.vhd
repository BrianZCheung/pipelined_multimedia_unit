--
-- Entity Name : ID_EX_Reg
-- Entity Description: 
-- Architecture Name : ID_EX_Reg_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;		

entity ID_EX_Reg is	 
	port(		   
		clk : in std_logic;
		rs_1_in : in std_logic_vector(127 downto 0);   
		rs_2_in : in std_logic_vector(127 downto 0);
		rs_3_in : in std_logic_vector(127 downto 0);
		instruction_in: in std_logic_vector(24 downto 0);
		rs_1_out : out std_logic_vector(127 downto 0);   
		rs_2_out : out std_logic_vector(127 downto 0);
		rs_3_out : out std_logic_vector(127 downto 0);
		instruction_out: out std_logic_vector(24 downto 0)
	);
end ID_EX_Reg;			   

architecture ID_EX_Reg_arch of ID_EX_Reg is

begin 
	
	ID_EX_Reg: process(rs_1_in, rs_2_in, rs_3_in, clk) 
	
	--variables to store the register information from previous stage
	variable rs_1_reg_store: std_logic_vector(127 downto 0); 
	variable rs_2_reg_store: std_logic_vector(127 downto 0);
	variable rs_3_reg_store: std_logic_vector(127 downto 0); 
	variable instruction_store: std_logic_vector(24 downto 0);
	
	begin	 
		
		rs_1_reg_store := rs_1_in; 		   
		rs_2_reg_store := rs_2_in; 
		rs_3_reg_store := rs_3_in; 	
		instruction_store := instruction_in;
		
		--pass information to next stage on next clock cycle
		if (rising_edge(clk)) then
			rs_1_out <= rs_1_reg_store;	   
			rs_2_out <= rs_2_reg_store;	
			rs_3_out <= rs_3_reg_store;		
			instruction_out <= instruction_store;
		end if;
	
	end process ID_EX_Reg;

end ID_EX_Reg_arch;