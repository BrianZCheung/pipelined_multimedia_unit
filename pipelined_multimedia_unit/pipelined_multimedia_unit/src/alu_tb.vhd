<<<<<<< HEAD
--
-- Entity Name : alu_tb
-- Entity Description: testbench for our alu
-- Architecture Name : tb_architecture
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
-- 

=======
>>>>>>> main
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
	
<<<<<<< HEAD
	stimlus: process
	
	--4.2 variables:
	variable max64Bit: std_logic_vector(63 downto 0) := x"7FFFFFFFFFFFFFFF";	
	variable min64Bit: std_logic_vector(63 downto 0) := x"8000000000000000";
	variable max32Bit: std_logic_vector(31 downto 0) := x"7FFFFFFF";
	variable min32Bit: std_logic_vector(31 downto 0) := x"80000000";
	variable max16Bit: std_logic_vector(15 downto 0) := x"7FFF";
	variable min16Bit: std_logic_vector(15 downto 0) := x"8000"; 
	
	variable zero64Bit: std_logic_vector(63 downto 0) := x"0000000000000000";   
	variable zero32Bit: std_logic_vector(31 downto 0) := x"00000000";	
	variable zero16Bit: std_logic_vector(15 downto 0) := x"0000"; 
	
	--4.3 variables:
	variable dont_care: std_logic_vector(3 downto 0) := "0000";
	variable dont_care16Bit: std_logic_vector(15 downto 0) := x"0000";
	begin		  				
		
		--TEST FOR 4.2 INSTRUCTIONS:
		
		--test first int instruction for expected values 0
		rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  
		rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
		rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
		instruction_in_tb <= "10" & "000" &"00000000000000000000";
		wait for 100ns;	
		rs_1_tb <= zero64Bit & zero32Bit & zero32Bit;  
		rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & zero16Bit;  
		rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & zero16Bit;
		instruction_in_tb <= "10" & "000" &"00000000000000000000";
		wait for 100ns;	 
		
		--tests for int instructions
		for i in 0 to 3 loop	
			--lower 16 bits non-zero
			--+rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & zero32Bit & max32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & zero32Bit & min32Bit;     
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & zero32Bit & min32Bit; 	   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & zero32Bit & min32Bit;   
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & max16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & zero32Bit & min32Bit;    
			rs_2_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & zero16Bit & min16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			
			--upper 16 bits non-zero
			--+rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & max32Bit & zero32Bit;  
			rs_2_tb <= zero64Bit & zero32Bit & max16Bit & zero16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max16Bit & zero16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & max32Bit & zero32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & max16Bit & zero16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min16Bit & zero16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & max32Bit & zero32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & min16Bit & zero16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max16Bit & zero16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & max32Bit & zero32Bit;  	   
			rs_2_tb <= zero64Bit & zero32Bit & min16Bit & zero16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min16Bit & zero16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & min32Bit & zero32Bit;     
			rs_2_tb <= zero64Bit & zero32Bit & max16Bit & zero16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max16Bit & zero16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & min32Bit & zero32Bit; 	   
			rs_2_tb <= zero64Bit & zero32Bit & max16Bit & zero16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min16Bit & zero16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & min32Bit & zero32Bit;   
			rs_2_tb <= zero64Bit & zero32Bit & min16Bit & zero16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max16Bit & zero16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & min32Bit & zero32Bit;    
			rs_2_tb <= zero64Bit & zero32Bit & min16Bit & zero16Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min16Bit & zero16Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
		end loop;
		--tests for long instructions
		for i in 4 to 7 loop   
			--lower 64 bits non-zero
			--+rs1 +rs2 +rs3
			rs_1_tb <= zero64Bit & max64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & max32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 +rs2 -rs3
			rs_1_tb <= zero64Bit & max64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & max32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & max64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & min32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & max64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & min32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min32Bit;
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
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 +rs3
			rs_1_tb <= zero64Bit & min64Bit;   
			rs_2_tb <= zero64Bit & zero32Bit & min32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & max32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 -rs3
			rs_1_tb <= zero64Bit & min64Bit;	   
			rs_2_tb <= zero64Bit & zero32Bit & min32Bit;  
			rs_3_tb <= zero64Bit & zero32Bit & min32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	  
			
			--upper 64 bits non-zero
			--+rs1 +rs2 +rs3
			rs_1_tb <= max64Bit & zero64Bit;	   
			rs_2_tb <= zero64Bit & max32Bit & zero32Bit;  
			rs_3_tb <= zero64Bit & max32Bit & zero32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 +rs2 -rs3
			rs_1_tb <= max64Bit & zero64Bit;	   
			rs_2_tb <= zero64Bit & max32Bit & zero32Bit;  
			rs_3_tb <= zero64Bit & min32Bit & zero32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 +rs3
			rs_1_tb <= max64Bit & zero64Bit;	   
			rs_2_tb <= zero64Bit & min32Bit & zero32Bit;  
			rs_3_tb <= zero64Bit & max32Bit & zero32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			--+rs1 -rs2 -rs3
			rs_1_tb <= max64Bit & zero64Bit;	   
			rs_2_tb <= zero64Bit & min32Bit & zero32Bit;  
			rs_3_tb <= zero64Bit & min32Bit & zero32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 +rs3
			rs_1_tb <= min64Bit & zero64Bit;	   
			rs_2_tb <= zero64Bit & max32Bit & zero32Bit;  
			rs_3_tb <= zero64Bit & max32Bit & zero32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 +rs2 -rs3
			rs_1_tb <= min64Bit & zero64Bit;	   
			rs_2_tb <= zero64Bit & max32Bit & zero32Bit;  
			rs_3_tb <= zero64Bit & min32Bit & zero32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 +rs3
			rs_1_tb <= min64Bit & zero64Bit;   
			rs_2_tb <= zero64Bit & min32Bit & zero32Bit;  
			rs_3_tb <= zero64Bit & max32Bit & zero32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
			---rs1 -rs2 -rs3
			rs_1_tb <= min64Bit & zero64Bit;	   
			rs_2_tb <= zero64Bit & min32Bit & zero32Bit;  
			rs_3_tb <= zero64Bit & min32Bit & zero32Bit;
			instruction_in_tb <= "10" & std_logic_vector(to_unsigned(i, 3)) &"00000000000000000000";
			wait for 100ns;	
		end loop;
		
		
			--as of 10/23/2021 above ends at 13400ns
		--TEST FOR 4.3 INSTRUCTIONS:	 
			
			
		--nop
		rs_1_tb <= zero64Bit & zero64Bit;
		rs_2_tb <= zero64Bit & zero64Bit;
		instruction_in_tb <= "11" & dont_care & "0000" & "000000000000000";
		wait for 100ns;
		
		
		
			--above ends at 13500ns
		--AH (add halfword, adding each of the positive 16 bit segments):
			--(min and max for 16 bits: min: 0, max: 65535)
			
			--test case 1: just add zeros	
		rs_1_tb <= zero64Bit & zero64Bit;
		rs_2_tb <= zero64Bit & zero64Bit;
		instruction_in_tb <= "11" & dont_care & "0001" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = zero64Bit & zero64Bit)
		report "test failed for 4.3 AH instruction, test case 1" severity error;
			
			--test case 2: trigger the carry for each 16 bit positive addition.
				--each result should roll over.	
		rs_1_tb <= x"F000" & x"F001" & x"F002" & x"F003" & x"F004" & x"F000" & x"F000" & x"F000";
		rs_2_tb <= x"F000" & x"F000" & x"F000" & x"F000" & x"F000" & x"F005" & x"F006" & x"F007";	
		instruction_in_tb <= "11" & dont_care & "0001" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"E000" & x"E001" & x"E002" & x"E003" & x"E004" & x"E005" & x"E006" & x"E007")
		report "test failed for 4.3 AH instruction, test case 2" severity error;
			
			--test case 3: adding random numbers together.
		rs_1_tb <= x"0012" & x"0034" & x"0056" & x"0078" & x"009A" & x"00BC" & x"00DE" & x"00FF"; 
		rs_2_tb <= x"1200" & x"3400" & x"5600" & x"7800" & x"9A00" & x"BC00" & x"DE00" & x"FF00";
		instruction_in_tb <= "11" & dont_care & "0001" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"1212" & x"3434" & x"5656" & x"7878" & x"9A9A" & x"BCBC" & x"DEDE" & x"FFFF")
		report "test failed for 4.3 AH instruction, test case 3" severity error;
			
			--test case 4: adding random numbers together version 2.
		rs_1_tb <= x"0012" & x"0034" & x"0056" & x"0078" & x"009A" & x"00BC" & x"00DE" & x"00FF"; 
		rs_2_tb <= x"0012" & x"0034" & x"0056" & x"0078" & x"009A" & x"00BC" & x"00DE" & x"00FF";
		instruction_in_tb <= "11" & dont_care & "0001" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"0024" & x"0068" & x"00AC" & x"00F0" & x"0134" & x"0178" & x"01BC" & x"01FE")
		report "test failed for 4.3 AH instruction, test case 3" severity error;
		
			
		
			--above ends at 13900ns	
		--AHS (add halfword saturated, adding each of the signed 16 bit segments with suppression):
			--(min and max for 16 bits: min: -32768, max: 32767)
			
			--test case 1: just add zeros	
		rs_1_tb <= zero64Bit & zero64Bit;
		rs_2_tb <= zero64Bit & zero64Bit;
		instruction_in_tb <= "11" & dont_care & "0010" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = zero64Bit & zero64Bit)
		report "test failed for 4.3 AHS instruction, test case 1" severity error;
			
			--test case 2: trigger negative overflow for each 16 bit signed addition.
				--each segment should be suppresssed to negative max.	
		rs_1_tb <= min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit;
		rs_2_tb <= min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit;	
		instruction_in_tb <= "11" & dont_care & "0010" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit & min16Bit)
		report "test failed for 4.3 AHS instruction, test case 2" severity error;
			
			--test case 3: trigger positive overflow for each 16 bit signed addition.
				--each segment should be suppressed to positive max.	
		rs_1_tb <= max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit;
		rs_2_tb <= max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit;	
		instruction_in_tb <= "11" & dont_care & "0010" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit & max16Bit)
		report "test failed for 4.3 AHS instruction, test case 3" severity error;
			
			--test case 4: adding random numbers together.
		rs_1_tb <= x"0012" & x"0034" & x"0056" & x"0078" & x"009A" & x"00BC" & x"00DE" & x"00FF"; 
		rs_2_tb <= x"1200" & x"3400" & x"5600" & x"7800" & x"9A00" & x"BC00" & x"DE00" & x"FF00";
		instruction_in_tb <= "11" & dont_care & "0010" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"1212" & x"3434" & x"5656" & x"7878" & x"9A9A" & x"BCBC" & x"DEDE" & x"FFFF")
		report "test failed for 4.3 AHS instruction, test case 4" severity error;
			
			--test case 5: adding random numbers together version 2.
		rs_1_tb <= x"1200" & x"3400" & x"5600" & x"7800" & x"9A00" & x"BC00" & x"DE00" & x"FF00"; 
		rs_2_tb <= x"0120" & x"0340" & x"0560" & x"0780" & x"09A0" & x"0BC0" & x"0DE0" & x"0FF0";
		instruction_in_tb <= "11" & dont_care & "0010" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"1320" & x"3740" & x"5B60" & x"7F80" & x"A3A0" & x"C7C0" & x"EBE0" & x"0EF0")
		report "test failed for 4.3 AHS instruction, test case 5" severity error;
		
			
		
			--above ends in 14400ns	
		--BCW (broadcast word, copy the rightmost 32 bits of rs1 to each segment of rd):
		
			--test case 1: copy a random segment into rd
		rs_1_tb <= dont_care16Bit & dont_care16Bit & dont_care16Bit & dont_care16Bit & 
			dont_care16Bit & dont_care16Bit & x"1234CDEF";
		instruction_in_tb <= "11" & dont_care & "0011" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"1234CDEF" & x"1234CDEF" & x"1234CDEF" & x"1234CDEF")
		report "test failed for 4.3 BCW instruction, test case 1" severity error;
		
		
			
			--above ends in 14500ns	
		--CGH (carry generate halfword, add each of the positive 16 bit segments in rs1 and rs2, and 
			--give the segment in rd a 1 if there was a carry):
		
			--test case 1: add a random selection of numbers together
		rs_1_tb <= x"1234" & x"5678" & x"9ABC" & x"DEFF" & x"FEDC" & x"BA98" & x"7654" & x"3210";
		rs_2_tb <= x"1234" & x"5678" & x"9ABC" & x"DEFF" & x"FEDC" & x"BA98" & x"7654" & x"3210";
		instruction_in_tb <= "11" & dont_care & "0100" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = zero16Bit & x"0001" & x"0001" & x"0001" & x"0001" & x"0001" & x"0001" & zero16Bit)
		report "test failed for 4.3 CGH instruction, test case 1" severity error;
		
			
		
			--above ends in 14600ns	
		--CLZ (count leading zeros in word, count leading zeros in each 32 bit segments of rs1 and 
			--place the count into each segment of rd):
		
			--test case 1: count the zeros of arbitrary 32 bit numbers (test no zeros, full zeros, some zeros)
		rs_1_tb <= zero32Bit & x"FFFFFFFF" & x"00004ABC" & x"12345678";
		instruction_in_tb <= "11" & dont_care & "0101" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"00000020" & zero32Bit & x"00000011" & x"00000003")
		report "test failed for 4.3 CLZ instruction, test case 1" severity error;
		
			
		
			--above ends in 14700ns	
		--MAX (max signed word, place the max of each 32 bit segment of rs_1 and rs_2 and into each
			--segment of rd):
		
			--test case 1: compare same cases and positive cases
		rs_1_tb <= zero32Bit & x"FFFFFFFF" & x"12345678" & x"3456789A";
		rs_2_tb <= zero32Bit & x"FFFFFFFF" & x"23456789" & x"23456789";
		instruction_in_tb <= "11" & dont_care & "0110" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = zero32Bit & x"FFFFFFFF" & x"23456789" & x"3456789A")
		report "test failed for 4.3 MAX instruction, test case 1" severity error;
			
			--test case 2: compare negative cases and mixed cases
		rs_1_tb <= x"FEDCBA98" & x"DCBA9876" & x"12345678" & x"23456789";
		rs_2_tb <= x"EDCBA987" & x"EDCBA987" & x"FEDCBA98" & x"EDCBA987";
		instruction_in_tb <= "11" & dont_care & "0110" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"FEDCBA98" & x"EDCBA987" & x"12345678" & x"23456789")
		report "test failed for 4.3 MAX instruction, test case 2" severity error;
		
			
		
			--above ends in 14900ns	
		--MIN (min signed word, place the min of each 32 bit segment of rs_1 and rs_2 and into each
			--segment of rd):
		
			--test case 1: compare same cases and positive cases
		rs_1_tb <= zero32Bit & x"FFFFFFFF" & x"12345678" & x"3456789A";
		rs_2_tb <= zero32Bit & x"FFFFFFFF" & x"23456789" & x"23456789";
		instruction_in_tb <= "11" & dont_care & "0111" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = zero32Bit & x"FFFFFFFF" & x"12345678" & x"23456789")
		report "test failed for 4.3 MIN instruction, test case 1" severity error;
			
			--test case 2: compare negative cases and mixed cases
		rs_1_tb <= x"FEDCBA98" & x"DCBA9876" & x"12345678" & x"23456789";
		rs_2_tb <= x"EDCBA987" & x"EDCBA987" & x"FEDCBA98" & x"EDCBA987";
		instruction_in_tb <= "11" & dont_care & "0111" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"EDCBA987" & x"DCBA9876" & x"FEDCBA98" & x"EDCBA987")
		report "test failed for 4.3 MIN instruction, test case 2" severity error;
		
			
			
			--above ends in 15100ns	
		--MSGN (multiply sign, mutiply the sign of each 32 segment of rs2 with the 32 bit
			--segment of rs1 and store into rd. Make sure to suppresss with saturation):
		
			--test case 1: check both positive, both negative, and mixed cases
		rs_1_tb <= x"12345678" & x"87654321" & x"12345678" & x"87654321";
		rs_2_tb <= x"76543210" & x"FEDCBA98" & x"FEDCBA98" & x"76543210";
		instruction_in_tb <= "11" & dont_care & "1000" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"12345678" & x"789ABCDF" & x"EDCBA988" & x"87654321")
		report "test failed for 4.3 MSGN instruction, test case 1" severity error;
			
			--test case 2: check zero and saturation cases
		rs_1_tb <= x"12345678" & x"87654321" & min32Bit & max32Bit;
		rs_2_tb <= zero32Bit & zero32Bit & x"FEDCBA98" & x"FEDCBA98";
		instruction_in_tb <= "11" & dont_care & "1000" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"12345678" & x"87654321" & max32Bit & x"80000001")
		report "test failed for 4.3 MSGN instruction, test case 2" severity error;
		
			
			
			--above ends in 15300ns	
		--POPCNTH (count 1s in halfword, count the number of 1s in each 16 bit segment of 
			--rs1 and store it in rd):
		
			--test case 1: count 1s in each random 16 bit segment of rs1 (check max case, min
				--case, and mixed case)
		rs_1_tb <= x"FFFF" & x"0000" & x"1234" & x"5678" & x"9ABC" & x"DEF0" & x"2468" & x"1357";
		instruction_in_tb <= "11" & dont_care & "1001" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"0010" & x"0000" & x"0005" & x"0008" & x"0009" & x"000A" & x"0005" & x"0008")
		report "test failed for 4.3 POPCNTH instruction, test case 1" severity error;
		
			
		
			--above ends in 15400ns
		--ROT (rotate entirety of rs1 right according to the least-sig 7 bits of rs2. Shift can be
			--negative, and bit shifted out on the right comes back in from the left. Result in rd.):
		
			--test case 1: no shift
		rs_1_tb <= x"11112222333344445555666677778888";
		rs_2_tb <= dont_care16Bit & dont_care16Bit & dont_care16Bit & dont_care16Bit & 
			dont_care16Bit & dont_care16Bit & dont_care16Bit & dont_care16Bit(8 downto 0) & "0000000";
		instruction_in_tb <= "11" & dont_care & "1010" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"11112222333344445555666677778888")
		report "test failed for 4.3 ROT instruction, test case 1" severity error;
		
			--test case 2: max positive shift (63 bits right)
		rs_1_tb <= x"00000000000000007FFFFFFFFFFFFFFF";
		rs_2_tb <= dont_care16Bit & dont_care16Bit & dont_care16Bit & dont_care16Bit & 
			dont_care16Bit & dont_care16Bit & dont_care16Bit & dont_care16Bit(8 downto 0) & "0111111";
		instruction_in_tb <= "11" & dont_care & "1010" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"FFFFFFFFFFFFFFFE0000000000000000")
		report "test failed for 4.3 ROT instruction, test case 2" severity error;	
		
			--test case 3: max negative shift (64 bits left)
		rs_1_tb <= x"0000000000000000FFFFFFFFFFFFFFFF";
		rs_2_tb <= dont_care16Bit & dont_care16Bit & dont_care16Bit & dont_care16Bit & 
			dont_care16Bit & dont_care16Bit & dont_care16Bit & dont_care16Bit(8 downto 0) & "1000000";
		instruction_in_tb <= "11" & dont_care & "1010" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"FFFFFFFFFFFFFFFF0000000000000000")
		report "test failed for 4.3 ROT instruction, test case 3" severity error;
		
			
		
			--above ends in 15700ns	
		--ROTW (rotate each 32 bit segment in rs1 according to the least-sig 5 bits of the corresponding rs2
			--segment. Shift can be negative, and bit shifted out on the right comes back in from the left.
			--Result in rd.):
		
			--test case 1: no shift
		rs_1_tb <= x"11112222" & x"33334444" & x"55556666" & x"77778888";
		rs_2_tb <= dont_care16Bit & dont_care16Bit(15 downto 5) & "00000" & 
			dont_care16Bit & dont_care16Bit(15 downto 5) & "00000" &
			dont_care16Bit & dont_care16Bit(15 downto 5) & "00000" &
			dont_care16Bit & dont_care16Bit(15 downto 5) & "00000";
		instruction_in_tb <= "11" & dont_care & "1011" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"11112222333344445555666677778888")
		report "test failed for 4.3 ROTW instruction, test case 1" severity error;
		
			--test case 2: max positive shift (15 bits right)
		rs_1_tb <= x"00007FFF" & x"000007FF" & x"0000007F" & x"00000007";
		rs_2_tb <= dont_care16Bit & dont_care16Bit(15 downto 5) & "01111" & 
			dont_care16Bit & dont_care16Bit(15 downto 5) & "01111" &
			dont_care16Bit & dont_care16Bit(15 downto 5) & "01111" &
			dont_care16Bit & dont_care16Bit(15 downto 5) & "01111";
		instruction_in_tb <= "11" & dont_care & "1011" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"FFFE0000" & x"0FFE0000" & x"00FE0000" & x"000E0000")
		report "test failed for 4.3 ROTW instruction, test case 2" severity error;	
		
			--test case 3: max negative shift (16 bits left)
		rs_1_tb <= x"0000FFFF" & x"00000FFF" & x"000000FF" & x"0000000F";
		rs_2_tb <= dont_care16Bit & dont_care16Bit(15 downto 5) & "10000" & 
			dont_care16Bit & dont_care16Bit(15 downto 5) & "10000" &
			dont_care16Bit & dont_care16Bit(15 downto 5) & "10000" &
			dont_care16Bit & dont_care16Bit(15 downto 5) & "10000";
		instruction_in_tb <= "11" & dont_care & "1011" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"FFFF0000" & x"0FFF0000" & x"00FF0000" & x"000F0000")
		report "test failed for 4.3 ROTW instruction, test case 3" severity error;
		
			
			
		--SHLHI (shift left halfword immediate, NEED TO COMPLETE THIS LATER)
		
		
		
			--above ends in 16000ns
		--SFH (subtract from halfword, subtract each 16 bit segment of rs1 from rs2 so that rd = rs2-rs1.
			--Each 16 bit segment is positive)
		
			--test case 1: just subtract zero from zero	
		rs_1_tb <= zero64Bit & zero64Bit;
		rs_2_tb <= zero64Bit & zero64Bit;
		instruction_in_tb <= "11" & dont_care & "1101" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = zero64Bit & zero64Bit)
		report "test failed for 4.3 SFH instruction, test case 1" severity error;
		
			--test case 2: trigger the roll over and subtract random numbers.	
		rs_1_tb <= x"FFFF" & x"0000" & x"0001" & x"0002" & x"0003" & x"0004" & x"0005" & x"000F";
		rs_2_tb <= x"0000" & x"FFFF" & x"0004" & x"0003" & x"0002" & x"0001" & x"0000" & x"FFFF";	
		instruction_in_tb <= "11" & dont_care & "1101" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"0000" & x"FFFF" & x"0003" & x"0001" & x"FFFE" & x"FFFC" & x"FFFA" & x"FFF0")
		report "test failed for 4.3 SFH instruction, test case 2" severity error;	
		
		
			
			--above ends in 16200ns	
		--SFHS (subtract from halfword saturated, subtract each 16 bit segment of rs1 from rs2 so that 
			--rd = rs2-rs1. Each 16 bit segment is signed)
		
			--test case 1: just subtract zero from zero	
		rs_1_tb <= zero64Bit & zero64Bit;
		rs_2_tb <= zero64Bit & zero64Bit;
		instruction_in_tb <= "11" & dont_care & "1110" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = zero64Bit & zero64Bit)
		report "test failed for 4.3 SFHS instruction, test case 1" severity error;
		
			--test case 2: trigger negative and positive overflow, subtract from 0, subtract 0, 
				--subtract random numbers.	
		rs_1_tb <= x"7FFF" & x"FFFF" & x"0001" & x"0000" & x"8FFE" & x"0004" & x"0005" & x"000F";
		rs_2_tb <= x"8000" & x"7FFF" & x"0000" & x"FFFF" & x"0001" & x"0001" & x"0000" & x"FFFF";	
		instruction_in_tb <= "11" & dont_care & "1110" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = min16Bit & max16Bit & x"FFFF" & x"FFFF" & x"7003" & x"FFFD" & x"FFFB" & x"FFF0")
		report "test failed for 4.3 SFHS instruction, test case 2" severity error;
		
			
			
			--above ends in 16400ns
		--XOR (xor the contents of rs1 and rs2)
		
			--test case 1: xor a random combination	
		rs_1_tb <= x"11112222333344445555666677778888";
		rs_2_tb <= x"88887777666655554444333322221111";
		instruction_in_tb <= "11" & dont_care & "1111" & "000000000000000";
		wait for 100ns;
		assert(rd_tb = x"99995555555511111111555555559999")
		report "test failed for 4.3 XOR instruction, test case 1" severity error;
		
			
=======
	stimlus: process 
	begin
		rs_1_tb <= std_logic_vector(to_signed(5, 128));	   
		rs_2_tb <= std_logic_vector(to_signed(2, 128));  
		rs_3_tb <= std_logic_vector(to_signed(6, 128));
		wait for 100ns;
		instruction_in_tb <= "1000000000000000000000000";
		wait for 200ns;
		
>>>>>>> main
	std.env.finish;
	end process;	
	
	
	
end tb_architecture;



