library ieee;
use ieee.std_logic_1164.all;   
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;

entity alu_tb is
end alu_tb;

architecture tb_architecture of alu_tb is
	
-- stimulus signals 
signal instruction_in_tb : std_logic_vector(24 downto 0);
signal rs_1_tb : std_logic_vector(127 downto 0);
signal rs_2_tb : std_logic_vector(127 downto 0);
signal rs_3_tb : std_logic_vector(127 downto 0);
signal rs_4_tb : std_logic_vector(127 downto 0);
-- observed signals 
signal rd_tb : std_logic_vector(127 downto 0);	 
	
	
begin
	
	-- Unit Under Test port map
	UUT : entity alu
	port map (
		instruction_in => instruction_in_tb,
		rs_1 => rs_1_tb,
		rs_2 => rs_2_tb,
		rs_3 => rs_3_tb,
		rd => rd_tb
	);
	
	stimlus: process   
	variable max64Bit: std_logic_vector(63 downto 0) := x"7FFFFFFFFFFFFFFF";	
	variable min64Bit: std_logic_vector(63 downto 0) := x"8000000000000000";
	variable max32Bit: std_logic_vector(31 downto 0) := x"7FFFFFFF";
	variable min32Bit: std_logic_vector(31 downto 0) := x"80000000";
	variable max16Bit: std_logic_vector(15 downto 0) := x"7FFF";
	variable min16Bit: std_logic_vector(15 downto 0) := x"8000"; 
	
	variable zero64Bit: std_logic_vector(63 downto 0) := x"0000000000000000";   
	variable zero32Bit: std_logic_vector(31 downto 0) := x"00000000";	
	variable zero16Bit: std_logic_vector(15 downto 0) := x"0000"; 
	begin		  
		--tests for int instructions
		for i in 0 to 3 loop   
			--+rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & zero32Bit & min32Bit;     
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & zero32Bit & min32Bit; 	   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & zero32Bit & min32Bit;   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & zero32Bit & min32Bit;    
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
		end loop;	
		--tests for long instructions
		for i in 5 to 8 loop   
			--+rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & max64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & max32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max32Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & max64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & max32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min32Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & max64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & min32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max32Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & max64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & min32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min32Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & min64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & max32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max32Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & min64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & max32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min32Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & min64Bit;   
			rs_2_tb <= zero64Bit & zero32Bit & min32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max32Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & min64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & min32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min32Bit;
			wait for 100ns;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
		end loop;
		std.env.finish;
	end process;	
	
	
	
end tb_architecture;



