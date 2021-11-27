--
-- Entity Name : pipelined_multimedia_unit_tb
-- Entity Description: testbench for the entire pipelined multimedia unit
-- Architecture Name : tb_architecture
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--

library ieee;
use ieee.std_logic_1164.all;   
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;
use std.textio.all;-- library for reading text files
	
entity pipelined_multimedia_unit_tb is
end pipelined_multimedia_unit_tb;

architecture tb_architecture of pipelined_multimedia_unit_tb is

--stimulus signals:	
signal index_tb : std_logic_vector(31 downto 0);
signal clk_tb : std_logic;
signal pc_reset_tb : std_logic;
signal load_enable_tb : std_logic;
signal load_instruction_tb : std_logic_vector(24 downto 0);

begin
	
	UUT: entity pipelined_multimedia_unit
		port map(  
			index => index_tb,
			clk => clk_tb,
			pc_reset => pc_reset_tb,
			load_enable	=> load_enable_tb,
			load_instruction => load_instruction_tb
		);
		
	stimulus: process
	
	variable txt_line : line;
	file read_file : text;
	variable txt_line_vector : std_logic_vector(25*4-1 downto 0);
	variable instr_vector : std_logic_vector(24 downto 0);		
	variable numbOfInstr : integer := 0;
	
	file write_file : text open write_mode is "test_writing.txt";
	
	begin
		clk_tb <= '0';
		load_enable_tb <= '1';
		
		file_open(read_file, "translatedMIPSCode.txt", read_mode);
		
		while not endfile(read_file) loop
			if(numbOfInstr < 64) then
				readline(read_file, txt_line);
				hread(txt_line, txt_line_vector);
				--report to_string(txt_line_vector);
				
				for index in 0 to 24 loop
					instr_vector(index) := txt_line_vector(index*4);
				end loop;  
				
				--report(to_string(instr_vector));
				
				load_instruction_tb <= instr_vector;
				index_tb <=	std_logic_vector(to_unsigned(numbOfInstr,32));
				
				numbOfInstr := numbOfInstr + 1;
				
				hwrite(txt_line, txt_line_vector);
				writeline(write_file, txt_line);
			else
				exit;
			end if;
														
			wait for 10ns;
			
		end loop;
		file_close(read_file);
		file_close(write_file);
		
		pc_reset_tb <= '1';
		wait for 50ns;
		pc_reset_tb <= '0';
		wait for 50ns;
		load_enable_tb <= '0';
		wait for 100ns;
		
		
		
		for clock_pass in 0 to 20 loop
			clk_tb <= '1';
			wait for 100ns;
			
			clk_tb <= '0';
			wait for 100ns;
		end loop;
		
		std.env.finish;
	end process;
	
end tb_architecture;
	