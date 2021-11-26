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
		instruction_out: out std_logic_vector(24 downto 0);
		
		cont_EX_in : in std_logic;
		cont_WB_in : in std_logic;
		cont_EX_out : out std_logic;
		cont_WB_out : out std_logic
	);
end ID_EX_Reg;			   

architecture ID_EX_Reg_arch of ID_EX_Reg is

begin 
	
	ID_EX_Reg: process(clk, rs_1_in, rs_2_in, rs_3_in, instruction_in) 
	
	--variables to store the register information from previous stage
	variable rs_1_reg_store: std_logic_vector(127 downto 0); 
	variable rs_2_reg_store: std_logic_vector(127 downto 0);
	variable rs_3_reg_store: std_logic_vector(127 downto 0); 
	variable instruction_store: std_logic_vector(24 downto 0); 
	variable cont_EX_store : std_logic;
	variable cont_WB_store : std_logic;
	
	begin	 
		
		rs_1_reg_store := rs_1_in; 		   
		rs_2_reg_store := rs_2_in; 
		rs_3_reg_store := rs_3_in; 	
		instruction_store := instruction_in;
		cont_EX_store := cont_EX_in;
		cont_WB_store := cont_WB_in;
		
		--pass information to next stage on next clock cycle
		if (rising_edge(clk)) then
			if(cont_WB_store = '1') then
				rs_1_out <= rs_1_reg_store;	   
				rs_2_out <= rs_2_reg_store;	
				rs_3_out <= rs_3_reg_store;		
				instruction_out <= instruction_store;
				cont_EX_out <= cont_EX_store;
				cont_WB_out <= cont_WB_out;
			end if;
		end if;
	
	end process ID_EX_Reg;

end ID_EX_Reg_arch;