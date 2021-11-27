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

--observed signals:
signal IF_instr_tb : std_logic_vector(24 downto 0);	
signal IF_pc_tb : std_logic_vector(31 downto 0);
signal IF_cont_EX_tb : std_logic;
signal IF_cont_WB_tb : std_logic;

signal IF_ID_Reg_instr_tb : std_logic_vector(24 downto 0);
signal IF_ID_Reg_pc_tb : std_logic_vector(31 downto 0);

signal ID_stage_rs_1_tb : std_logic_vector(127 downto 0);
signal ID_stage_rs_2_tb : std_logic_vector(127 downto 0);
signal ID_stage_rs_3_tb : std_logic_vector(127 downto 0);

signal ID_EX_Reg_instr_tb :	std_logic_vector(24 downto 0);
signal ID_EX_Reg_rs_1_tb : std_logic_vector(127 downto 0);
signal ID_EX_Reg_rs_2_tb : std_logic_vector(127 downto 0);
signal ID_EX_Reg_rs_3_tb : std_logic_vector(127 downto 0);
signal ID_EX_Reg_cont_EX_tb : std_logic;
signal ID_EX_Reg_cont_WB_tb : std_logic;

signal EX_stage_rd_tb : std_logic_vector(127 downto 0);
signal EX_Stage_rd_address_tb : std_logic_vector(4 downto 0);  
signal EX_WB_Reg_instr_tb : std_logic_vector(24 downto 0);
signal EX_WB_Reg_cont_WB_tb : std_logic;

begin
	
	UUT: entity pipelined_multimedia_unit
		port map(  
			index => index_tb,
			clk => clk_tb,
			pc_reset => pc_reset_tb,
			load_enable	=> load_enable_tb,
			load_instruction => load_instruction_tb, 
			
			IF_instr_tb => IF_instr_tb,
			IF_pc_tb => IF_pc_tb,
			IF_cont_EX_tb => IF_cont_EX_tb,
			IF_cont_WB_tb => IF_cont_WB_tb,
			
			IF_ID_Reg_instr_tb => IF_ID_Reg_instr_tb,
			IF_ID_Reg_pc_tb => IF_ID_Reg_pc_tb,
			
			ID_stage_rs_1_tb => ID_stage_rs_1_tb,	
			ID_stage_rs_2_tb => ID_stage_rs_2_tb,
			ID_stage_rs_3_tb => ID_stage_rs_3_tb, 
			
			ID_EX_Reg_instr_tb => ID_EX_Reg_instr_tb,
			ID_EX_Reg_rs_1_tb => ID_EX_Reg_rs_1_tb,
			ID_EX_Reg_rs_2_tb => ID_EX_Reg_rs_2_tb,
			ID_EX_Reg_rs_3_tb => ID_EX_Reg_rs_3_tb, 
			ID_EX_Reg_cont_EX_tb => ID_EX_Reg_cont_EX_tb,		
			ID_EX_Reg_cont_WB_tb => ID_EX_Reg_cont_WB_tb,	
			
			EX_stage_rd_tb => EX_stage_rd_tb,
			EX_stage_rd_address_tb => EX_stage_rd_address_tb,
			EX_WB_Reg_instr_tb => EX_WB_Reg_instr_tb,
			EX_WB_Reg_cont_WB_tb => EX_WB_Reg_cont_WB_tb
		);
		
	stimulus: process
	
	variable txt_line : line;
	file read_file : text;
	variable txt_line_vector : std_logic_vector(25*4-1 downto 0);
	variable instr_vector : std_logic_vector(24 downto 0);		
	variable numbOfInstr : integer := 0;		 
	variable cycleCount : integer := 1;
	
	file write_file : text open write_mode is "results.txt";
	
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
		
		write(txt_line, "Cycle " & to_string(cycleCount) & ":");
		writeline(write_file, txt_line);
		write(txt_line, "Stage 1: ");
		writeline(write_file, txt_line);	
		write(txt_line, "Input Information: ");
		writeline(write_file, txt_line);  
		write(txt_line, "PC input: " & to_string(to_integer(unsigned(IF_ID_Reg_pc_tb))));
		writeline(write_file, txt_line);  
		write(txt_line, " ");
		writeline(write_file, txt_line);   
		write(txt_line, "Output Information: "); 
		writeline(write_file, txt_line);		 
		write(txt_line, "PC output: " & to_string(to_integer(unsigned(IF_pc_tb))));
		writeline(write_file, txt_line);		
		write(txt_line, "Instruction output: " & to_string(IF_instr_tb));
		writeline(write_file, txt_line);
		write(txt_line, "Execute Control Signal: " & to_string(IF_cont_EX_tb));
		writeline(write_file, txt_line);
		write(txt_line, "Writeback Control Signal: " & to_string(IF_cont_WB_tb));
		writeline(write_file, txt_line);
		write(txt_line, " ");
		writeline(write_file, txt_line); 
		
		write(txt_line, "Stage 2: ");
		writeline(write_file, txt_line);	
		write(txt_line, "Input Information: ");
		writeline(write_file, txt_line);
		write(txt_line, "Instruction Fetch: " & to_string(IF_ID_Reg_instr_tb));
		writeline(write_file, txt_line);
		write(txt_line, " ");
		writeline(write_file, txt_line); 
		write(txt_line, "Writeback Information: ");
		writeline(write_file, txt_line);
		write(txt_line, "Writeback instruction: " & to_string(EX_WB_Reg_instr_tb));
		writeline(write_file, txt_line);
		write(txt_line, "Write enabled: " & to_string(EX_WB_Reg_cont_WB_tb));
		writeline(write_file, txt_line);
		write(txt_line, "Writeback Control: " & to_string(EX_WB_Reg_cont_WB_tb));
		writeline(write_file, txt_line);  
		write(txt_line, " ");
		writeline(write_file, txt_line); 
		write(txt_line, "Output Information: ");
		writeline(write_file, txt_line);
		write(txt_line, "rs1/rd: " & to_string(ID_stage_rs_1_tb));
		writeline(write_file, txt_line);	
		write(txt_line, "rs2: " & to_string(ID_stage_rs_3_tb));
		writeline(write_file, txt_line);
		write(txt_line, "rs3: " & to_string(ID_stage_rs_2_tb));
		writeline(write_file, txt_line);
		write(txt_line, " ");
		writeline(write_file, txt_line); 
		
		write(txt_line, "Stage 3: ");
		writeline(write_file, txt_line);	
		write(txt_line, "Input Information: ");
		writeline(write_file, txt_line);   
		write(txt_line, "Instruction: " & to_string(ID_EX_Reg_instr_tb));
		writeline(write_file, txt_line);
		write(txt_line, "rs1/rd: " & to_string(ID_EX_Reg_rs_1_tb));
		writeline(write_file, txt_line);	
		write(txt_line, "rs2: " & to_string(ID_EX_Reg_rs_2_tb));
		writeline(write_file, txt_line);
		write(txt_line, "rs3: " & to_string(ID_EX_Reg_rs_3_tb));
		writeline(write_file, txt_line);
		write(txt_line, "Execute Control: " & to_string(ID_EX_Reg_cont_EX_tb));
		writeline(write_file, txt_line);	   
		write(txt_line, "Forwarding (Writeback control): " & to_string(ID_EX_Reg_cont_WB_tb));
		writeline(write_file, txt_line);
		write(txt_line, " ");
		writeline(write_file, txt_line);   
		write(txt_line, "Output Information: ");
		writeline(write_file, txt_line);   
		write(txt_line, "rd: " & to_string(EX_stage_rd_tb));
		writeline(write_file, txt_line);  
		write(txt_line, "rd address: " & to_string(to_integer(unsigned(EX_stage_rd_address_tb))));
		writeline(write_file, txt_line);
		write(txt_line, " ");
		writeline(write_file, txt_line); 
		
		write(txt_line, "Stage 4: ");
		write(txt_line, "Input/Output Information: ");
		writeline(write_file, txt_line);  
		write(txt_line, "Instruction: " & to_string(EX_WB_Reg_instr_tb));
		writeline(write_file, txt_line); 
		write(txt_line, "rd: " & to_string(EX_stage_rd_tb));
		writeline(write_file, txt_line);
		write(txt_line, "rd address: " & to_string(to_integer(unsigned(EX_stage_rd_address_tb))));
		writeline(write_file, txt_line);
		write(txt_line, "Writeback Control: " & to_string(ID_EX_Reg_cont_WB_tb));
		writeline(write_file, txt_line);
		write(txt_line, " ");
		writeline(write_file, txt_line); 
		write(txt_line, " ");
		writeline(write_file, txt_line);   
		
		for clock_pass in 0 to 70 loop
			clk_tb <= '1';
			wait for 100ns;
			
			cycleCount := cycleCount + 1;
			
			clk_tb <= '0';
			wait for 100ns;
			
			write(txt_line, "Cycle " & to_string(cycleCount) & ":");
			writeline(write_file, txt_line);
			write(txt_line, "Stage 1: ");
			writeline(write_file, txt_line);	
			write(txt_line, "Input Information: ");
			writeline(write_file, txt_line);  
			write(txt_line, "PC input: " & to_string(to_integer(unsigned(IF_ID_Reg_pc_tb))));
			writeline(write_file, txt_line);  
			write(txt_line, " ");
			writeline(write_file, txt_line);   
			write(txt_line, "Output Information: "); 
			writeline(write_file, txt_line);		 
			write(txt_line, "PC output: " & to_string(to_integer(unsigned(IF_pc_tb))));
			writeline(write_file, txt_line);		
			write(txt_line, "Instruction output: " & to_string(IF_instr_tb));
			writeline(write_file, txt_line);
			write(txt_line, "Execute Control Signal: " & to_string(IF_cont_EX_tb));
			writeline(write_file, txt_line);
			write(txt_line, "Writeback Control Signal: " & to_string(IF_cont_WB_tb));
			writeline(write_file, txt_line);
			write(txt_line, " ");
			writeline(write_file, txt_line); 
			
			write(txt_line, "Stage 2: ");
			writeline(write_file, txt_line);	
			write(txt_line, "Input Information: ");
			writeline(write_file, txt_line);
			write(txt_line, "Instruction Fetch: " & to_string(IF_ID_Reg_instr_tb));
			writeline(write_file, txt_line);
			write(txt_line, " ");
			writeline(write_file, txt_line); 
			write(txt_line, "Writeback Information: ");
			writeline(write_file, txt_line);
			write(txt_line, "Writeback instruction: " & to_string(EX_WB_Reg_instr_tb));
			writeline(write_file, txt_line);
			write(txt_line, "Write enabled: " & to_string(EX_WB_Reg_cont_WB_tb));
			writeline(write_file, txt_line);
			write(txt_line, "Writeback Control: " & to_string(EX_WB_Reg_cont_WB_tb));
			writeline(write_file, txt_line);  
			write(txt_line, " ");
			writeline(write_file, txt_line); 
			write(txt_line, "Output Information: ");
			writeline(write_file, txt_line);
			write(txt_line, "rs1/rd: " & to_string(ID_stage_rs_1_tb));
			writeline(write_file, txt_line);	
			write(txt_line, "rs2: " & to_string(ID_stage_rs_3_tb));
			writeline(write_file, txt_line);
			write(txt_line, "rs3: " & to_string(ID_stage_rs_2_tb));
			writeline(write_file, txt_line);
			write(txt_line, " ");
			writeline(write_file, txt_line); 
			
			write(txt_line, "Stage 3: ");
			writeline(write_file, txt_line);	
			write(txt_line, "Input Information: ");
			writeline(write_file, txt_line);   
			write(txt_line, "Instruction: " & to_string(ID_EX_Reg_instr_tb));
			writeline(write_file, txt_line);
			write(txt_line, "rs1/rd: " & to_string(ID_EX_Reg_rs_1_tb));
			writeline(write_file, txt_line);	
			write(txt_line, "rs2: " & to_string(ID_EX_Reg_rs_2_tb));
			writeline(write_file, txt_line);
			write(txt_line, "rs3: " & to_string(ID_EX_Reg_rs_3_tb));
			writeline(write_file, txt_line);
			write(txt_line, "Execute Control: " & to_string(ID_EX_Reg_cont_EX_tb));
			writeline(write_file, txt_line);	   
			write(txt_line, "Forwarding (Writeback control): " & to_string(ID_EX_Reg_cont_WB_tb));
			writeline(write_file, txt_line);
			write(txt_line, " ");
			writeline(write_file, txt_line);   
			write(txt_line, "Output Information: ");
			writeline(write_file, txt_line);   
			write(txt_line, "rd: " & to_string(EX_stage_rd_tb));
			writeline(write_file, txt_line);  
			write(txt_line, "rd address: " & to_string(to_integer(unsigned(EX_stage_rd_address_tb))));
			writeline(write_file, txt_line);
			write(txt_line, " ");
			writeline(write_file, txt_line); 
			
			write(txt_line, "Stage 4: ");
			write(txt_line, "Input/Output Information: ");
			writeline(write_file, txt_line);  
			write(txt_line, "Instruction: " & to_string(EX_WB_Reg_instr_tb));
			writeline(write_file, txt_line); 
			write(txt_line, "rd: " & to_string(EX_stage_rd_tb));
			writeline(write_file, txt_line);
			write(txt_line, "rd address: " & to_string(to_integer(unsigned(EX_stage_rd_address_tb))));
			writeline(write_file, txt_line);
			write(txt_line, "Writeback Control: " & to_string(ID_EX_Reg_cont_WB_tb));
			writeline(write_file, txt_line);
			write(txt_line, " ");
			writeline(write_file, txt_line); 
			write(txt_line, " ");
			writeline(write_file, txt_line); 
			
			--report out pipeline information
			
		end loop;
		
		std.env.finish;
	end process;
	
end tb_architecture;
	