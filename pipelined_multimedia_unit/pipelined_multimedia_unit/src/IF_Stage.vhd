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
	pc_in : in std_logic_vector(5 downto 0);
	pc_reset : in std_logic;
	load_enable : in std_logic;--load enable signal to load in instruction values (for testbench purposes)
	load_instruction : in std_logic_vector(24 downto 0); --load instruction value (for testbench)
	
	instruction_out : out std_logic_vector(24 downto 0);-- instruction being executed
	pc_out : out std_logic_vector(5 downto 0)-- the incremented PC 
	);
end IF_stage;

architecture IF_stage_arch of IF_stage is	

type instr_buffer_arr is array (63 downto 0) of std_logic_vector(24 downto 0);
signal instr_buffer : instr_buffer_arr := (others=>(others=>'-'));

begin			   

	IF_module: process(pc_in, pc_reset)
	
	variable pc_in_var : std_logic_vector(5 downto 0);
	
	begin
		if(pc_reset = '1') then
			pc_out <= "000000";
		elsif(not rising_edge(pc_reset) and not falling_edge(pc_reset)) then	
			pc_in_var := pc_in;
			
			--just sends out nop if there's no instruction:
			if(instr_buffer(to_integer(unsigned(pc_in_var)))(0) = '-') then
				instruction_out <= "11----0000---------------";
				pc_out <= std_logic_vector(to_unsigned(to_integer(unsigned(pc_in_var))+1, pc_out'length));
			
			--fetches the instruction pointed by the program counter:
			else
				instruction_out <= instr_buffer(to_integer(unsigned(pc_in_var)));
				pc_out <= std_logic_vector(to_unsigned(to_integer(unsigned(pc_in_var))+1, pc_out'length));
			end if;
			
		end if;
	end process IF_module;
	
	
	
	load_instrs: process(load_instruction)
	
	variable load_index : integer := 0;
	
	begin
		if(load_enable = '1') then
			instr_buffer(load_index) <= load_instruction;
			load_index := load_index + 1;
			
			if(load_index = 64) then
				load_index := 0;
			end if;
			
		end if;
		
	end process load_instrs;
	
	
end IF_stage_arch;