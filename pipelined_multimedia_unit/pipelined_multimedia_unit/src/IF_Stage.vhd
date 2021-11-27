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
	index : in std_logic_vector(31 downto 0);
	pc_in : in std_logic_vector(31 downto 0);
	pc_reset : in std_logic;
	load_enable : in std_logic;--load enable signal to load in instruction values (for testbench purposes)
	load_instruction : in std_logic_vector(24 downto 0); --load instruction value (for testbench)
	
	instruction_out : out std_logic_vector(24 downto 0);-- instruction being executed
	pc_out : out std_logic_vector(31 downto 0);-- the incremented PC 			   
	
	cont_EX_out : out std_logic;
	cont_WB_out : out std_logic
	);
end IF_stage;  


architecture IF_stage_arch of IF_stage is	

constant MAX_BUFFER_SIZE : integer := 64;
type instr_buffer_arr is array ((MAX_BUFFER_SIZE-1) downto 0) of std_logic_vector(24 downto 0);
signal instr_buffer : instr_buffer_arr := (others=>(others=>'-')); 

begin	

	IF_module: process(pc_in, pc_reset, load_enable)
	
	variable pc_in_var : std_logic_vector(31 downto 0);
	
	begin
		if(pc_reset = '1') then
			pc_out <= x"00000000";
		elsif(pc_reset = '0' and load_enable = '0' and to_integer(unsigned(pc_in)) < MAX_BUFFER_SIZE) then	
			pc_in_var := pc_in;
			
			--just sends out nop if there's no instruction:
			if(instr_buffer(to_integer(unsigned(pc_in_var)))(0) = '-') then
				instruction_out <= "1100000000000000000000000";
				cont_EX_out <= '0';
				cont_WB_out <= '0';
				
			
			--fetches the instruction pointed by the program counter:
			else	
				--check if the instruction is a nop instruction
				--if it is, no write back but still "execute" the instruction
				--if it isn't, it's a normal instruction and will require write back
				if(instr_buffer(to_integer(unsigned(pc_in_var)))(24 downto 23) = "11" and instr_buffer(to_integer(unsigned(pc_in_var)))(18 downto 15) = "0000") then  
					instruction_out <= instr_buffer(to_integer(unsigned(pc_in_var)));
					cont_EX_out <= '1';
					cont_WB_out <= '0';
				else
					instruction_out <= instr_buffer(to_integer(unsigned(pc_in_var)));
					cont_EX_out <= '1';
					cont_WB_out <= '1';	  
				end if;
			end if;			
			
			pc_out <= std_logic_vector(to_unsigned(to_integer(unsigned(pc_in_var))+1, pc_out'length));
			
		end if;
	end process IF_module;
	
	
	
	load_instrs: process(index)
	
	begin	 
		--check for load enable to load instructions
		if(load_enable = '1') then					
			--check that the index of the instructions are within the buffer bounds
			if(to_integer(unsigned(index)) >= 0 and to_integer(unsigned(index)) < MAX_BUFFER_SIZE) then
				--put instructions into the instruction buffer at the specified index
				instr_buffer(to_integer(unsigned(index))) <= load_instruction;	
			else
				report "To many instructions";
			end if;
		end if;
		
	end process load_instrs;
	
	
end IF_stage_arch;