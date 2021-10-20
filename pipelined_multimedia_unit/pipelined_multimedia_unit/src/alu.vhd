--
-- Entity Name : alu
-- Entity Description: 
-- Architecture Name : alu_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;

entity alu is
	port(
	instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed		 
	rs_1 : in std_logic_vector(127 downto 0);   
	rs_2 : in std_logic_vector(127 downto 0);
	rs_3 : in std_logic_vector(127 downto 0);
	rd : out std_logic_vector(127 downto 0)
	);
end alu;

architecture alu_arch of alu is	 	

begin
	
	alu: process(instruction_in(24 downto 23))	
	
	--variables used in 4.2  
	variable longMin: std_logic_vector(63 downto 0) := x"8000000000000000";
	variable longMax: std_logic_vector(63 downto 0) := x"7FFFFFFFFFFFFFFF";
	variable intMin: std_logic_vector(31 downto 0) := std_logic_vector(to_signed(-(2**31),32));	  
	variable intMax: std_logic_vector(31 downto 0) := std_logic_vector(to_signed((2**31)-1,32));	
	variable temp_signed1: std_logic_vector(63 downto 0);
	variable temp_signed2: std_logic_vector(63 downto 0);
	
	variable result: std_logic_vector(127 downto 0); 
	
	--variables used 4.2 and 4.3
	variable temp_int: integer;	
	
	--variables used in 4.3	 
	variable temp_vector: std_logic_vector(31 downto 0);
	variable temp_vector2: std_logic_vector(127 downto 0);
	variable temp_vector3: std_logic_vector(15 downto 0);
	begin 				 
		report to_string(longMax);
		--4.1 instructions	 
		--Load Immediate
		if(instruction_in(24) = '0') then	  	
			result(((16*to_integer(unsigned(instruction_in(23 downto 21))))+15) downto (16*to_integer(unsigned(instruction_in(23 downto 21))))) := instruction_in(20 downto 5);
			--rd gets the results of the 4.2 instructions into
			rd <= result;
		end if;	  

		--4.2 instructions 
		--Multiply-Add and Multiply-Subtract R4-Instruction Format
		if(instruction_in(24 downto 23) = "10") then	
			--Signed Integer Multiply-Add Low with Saturation:
			if(instruction_in(22 downto 20) = "000") then
				for i in 0 to 3 loop   
					--compute at the respective 32-bit field  
					temp_signed1(31 downto 0) := std_logic_vector(signed(rs_3((32*i)+15 downto (32*i)))*signed(rs_2((32*i)+15 downto (32*i))));	  
					temp_signed2(31 downto 0) := std_logic_vector(signed(rs_1((32*i)+31 downto (32*i))));
					--check if the 32-bit field is at saturation
					if(signed(temp_signed1(31 downto 0)) < 0 and signed(temp_signed1(31 downto 0)) + signed(temp_signed2(31 downto 0)) > 0) then
						result(((32*i)+31) downto (32*i)) := intMin;
					elsif(signed(temp_signed1(31 downto 0)) > 0 and signed(temp_signed1(31 downto 0)) + signed(temp_signed2(31 downto 0)) < 0) then
						result(((32*i)+31) downto (32*i)) := intMax;	
					else
						result(((32*i)+31) downto (32*i)) := std_logic_vector(signed(temp_signed1(31 downto 0)) + signed(temp_signed2(31 downto 0)));	
					end if;		  
				end loop;	 
			--Signed Integer Multiply-Add High with Saturation
			elsif(instruction_in(22 downto 20) = "001") then	 
				for i in 0 to 3 loop
					--compute at the respective 32-bit field  
					temp_signed1(31 downto 0) := std_logic_vector(signed(rs_3((32*i)+31 downto (32*i)+16))*signed(rs_2((32*i)+31 downto (32*i)+16)));	  
					temp_signed2(31 downto 0) := std_logic_vector(signed(rs_1((32*i)+31 downto (32*i))));
					--check if the 32-bit field is at saturation
					if(signed(temp_signed1(31 downto 0)) < 0 and signed(temp_signed1(31 downto 0)) + signed(temp_signed2(31 downto 0)) > 0) then
						result(((32*i)+31) downto (32*i)) := intMin;
					elsif(signed(temp_signed1(31 downto 0)) > 0 and signed(temp_signed1(31 downto 0)) + signed(temp_signed2(31 downto 0)) < 0) then
						result(((32*i)+31) downto (32*i)) := intMax;	
					else
						result(((32*i)+31) downto (32*i)) := std_logic_vector(signed(temp_signed1(31 downto 0)) + signed(temp_signed2(31 downto 0)));	
					end if;	
				end loop;	 	
			--Signed Integer Multiply-Subtract Low with Saturation
			elsif(instruction_in(22 downto 20) = "010") then   
				for i in 0 to 3 loop					
					--compute at the respective 32-bit field  
					temp_signed1(31 downto 0) := std_logic_vector(signed(rs_3((32*i)+15 downto (32*i)))*signed(rs_2((32*i)+15 downto (32*i))));	  
					temp_signed2(31 downto 0) := std_logic_vector(signed(rs_1((32*i)+31 downto (32*i))));
					--check if the 32-bit field is at saturation
					if(signed(temp_signed1(31 downto 0)) < 0 and signed(temp_signed1(31 downto 0)) - signed(temp_signed2(31 downto 0)) > 0) then
						result(((32*i)+31) downto (32*i)) := intMin;
					elsif(signed(temp_signed1(31 downto 0)) > 0 and signed(temp_signed1(31 downto 0)) - signed(temp_signed2(31 downto 0)) < 0) then
						result(((32*i)+31) downto (32*i)) := intMax;	
					else
						result(((32*i)+31) downto (32*i)) := std_logic_vector(signed(temp_signed1(31 downto 0)) - signed(temp_signed2(31 downto 0)));	
					end if;	
				end loop;	 			
			--Signed Integer Multiply-Subtract High with Saturation
			elsif(instruction_in(22 downto 20) = "011") then  
				for i in 0 to 3 loop   
					--compute at the respective 32-bit field  
					temp_signed1(31 downto 0) := std_logic_vector(signed(rs_3((32*i)+31 downto (32*i)+16))*signed(rs_2((32*i)+31 downto (32*i)+16)));	  
					temp_signed2(31 downto 0) := std_logic_vector(signed(rs_1((32*i)+31 downto (32*i))));
					--check if the 32-bit field is at saturation
					if(signed(temp_signed1(31 downto 0)) < 0 and signed(temp_signed1(31 downto 0)) - signed(temp_signed2(31 downto 0)) > 0) then
						result(((32*i)+31) downto (32*i)) := intMin;
					elsif(signed(temp_signed1(31 downto 0)) > 0 and signed(temp_signed1(31 downto 0)) - signed(temp_signed2(31 downto 0)) < 0) then
						result(((32*i)+31) downto (32*i)) := intMax;	
					else
						result(((32*i)+31) downto (32*i)) := std_logic_vector(signed(temp_signed1(31 downto 0)) - signed(temp_signed2(31 downto 0)));	
					end if;	
				end loop;					
			--Signed Long Integer Multiply-Add Low with Saturation
			elsif(instruction_in(22 downto 20) = "100") then		   
				for i in 0 to 1 loop	 
					--compute at the respective 64-bit field  
					temp_signed1(63 downto 0) := std_logic_vector(signed(rs_3((64*i)+31 downto (64*i)))*signed(rs_2((64*i)+31 downto (64*i))));	  
					temp_signed2(63 downto 0) := std_logic_vector(signed(rs_1((64*i)+63 downto (64*i))));
					--check if the 64-bit field is at saturation
					if(signed(temp_signed1(63 downto 0)) < 0 and signed(temp_signed1(63 downto 0)) + signed(temp_signed2(63 downto 0)) > 0) then
						result(((64*i)+63) downto (64*i)) := longMin;
					elsif(signed(temp_signed1(63 downto 0)) > 0 and signed(temp_signed1(63 downto 0)) + signed(temp_signed2(63 downto 0)) < 0) then
						result(((64*i)+63) downto (64*i)) := longMax;	
					else
						result(((64*i)+63) downto (64*i)) := std_logic_vector(signed(temp_signed1(63 downto 0)) + signed(temp_signed2(63 downto 0)));	
					end if;		 
				end loop;	 											
			--Signed Long Integer Multiply-Add High with Saturation
			elsif(instruction_in(22 downto 20) = "101") then	   
				for i in 0 to 1 loop	 
					--compute at the respective 64-bit field  
					temp_signed1(63 downto 0) := std_logic_vector(signed(rs_3((64*i)+63 downto (64*i)+31))*signed(rs_2((64*i)+63 downto (64*i)+31)));	  
					temp_signed2(63 downto 0) := std_logic_vector(signed(rs_1((64*i)+63 downto (64*i))));
					--check if the 64-bit field is at saturation
					if(signed(temp_signed1(63 downto 0)) < 0 and signed(temp_signed1(63 downto 0)) + signed(temp_signed2(63 downto 0)) > 0) then
						result(((64*i)+63) downto (64*i)) := longMin;
					elsif(signed(temp_signed1(63 downto 0)) > 0 and signed(temp_signed1(63 downto 0)) + signed(temp_signed2(63 downto 0)) < 0) then
						result(((64*i)+63) downto (64*i)) := longMax;	
					else
						result(((64*i)+63) downto (64*i)) := std_logic_vector(signed(temp_signed1(63 downto 0)) + signed(temp_signed2(63 downto 0)));	
					end if;		 
				end loop;	 
			--Signed Long Integer Multiply-Subtract Low with Saturation
			elsif(instruction_in(22 downto 20) = "110") then		  
				for i in 0 to 1 loop   
					--compute at the respective 64-bit field  
					temp_signed1(63 downto 0) := std_logic_vector(signed(rs_3((64*i)+31 downto (64*i)))*signed(rs_2((64*i)+31 downto (64*i))));	  
					temp_signed2(63 downto 0) := std_logic_vector(signed(rs_1((64*i)+63 downto (64*i))));
					--check if the 64-bit field is at saturation
					if(signed(temp_signed1(63 downto 0)) < 0 and signed(temp_signed1(63 downto 0)) - signed(temp_signed2(63 downto 0)) > 0) then
						result(((64*i)+63) downto (64*i)) := longMin;
					elsif(signed(temp_signed1(63 downto 0)) > 0 and signed(temp_signed1(63 downto 0)) - signed(temp_signed2(63 downto 0)) < 0) then
						result(((64*i)+63) downto (64*i)) := longMax;	
					else
						result(((64*i)+63) downto (64*i)) := std_logic_vector(signed(temp_signed1(63 downto 0)) - signed(temp_signed2(63 downto 0)));	
					end if;			 
				end loop;	 				 
			--Signed Long Integer Multiply-Subtract High with Saturation
			elsif(instruction_in(22 downto 20) = "111") then
				for i in 0 to 1 loop
					--compute at the respective 64-bit field  
					temp_signed1(63 downto 0) := std_logic_vector(signed(rs_3((64*i)+63 downto (64*i)+31))*signed(rs_2((64*i)+63 downto (64*i)+31)));	  
					temp_signed2(63 downto 0) := std_logic_vector(signed(rs_1((64*i)+63 downto (64*i))));
					--check if the 64-bit field is at saturation
					if(signed(temp_signed1(63 downto 0)) < 0 and signed(temp_signed1(63 downto 0)) - signed(temp_signed2(63 downto 0)) > 0) then
						result(((64*i)+63) downto (64*i)) := longMin;
					elsif(signed(temp_signed1(63 downto 0)) > 0 and signed(temp_signed1(63 downto 0)) - signed(temp_signed2(63 downto 0)) < 0) then
						result(((64*i)+63) downto (64*i)) := longMax;	
					else
						result(((64*i)+63) downto (64*i)) := std_logic_vector(signed(temp_signed1(63 downto 0)) - signed(temp_signed2(63 downto 0)));	
					end if;		
				end loop;	  
			end if;		 
			--rd gets the results of the 4.2 instructions into
			rd <= result;
		end if;		 
		
		
		--4.3 instructions	
		--R3-Instruction Format
		if(instruction_in(24 downto 23) = "11") then
			if(instruction_in(18 downto 15) = "0000") then
				-- nop
			
			elsif(instruction_in(18 downto 15) = "0001") then
				--AH: add halfword block
				for index in 0 to 7 loop
					temp_int := to_integer(unsigned(rs_1(16*index+15 downto index*16))) + to_integer(unsigned(rs_2(16*index+15 downto index*16)));
					if(temp_int > 65535) then
						temp_int := temp_int - 65535;
					end if;
					rd(16*index+15 downto index*16) <= std_logic_vector(to_unsigned(temp_int,16));
				end loop;
			
				
			elsif(instruction_in(18 downto 15) = "0010") then
				--AHS: add halfword saturated block
				for index in 0 to 7 loop
					temp_int := to_integer(signed(rs_1(16*index+15 downto index*16))) + to_integer(signed(rs_2(16*index+15 downto index*16)));
					if(temp_int > 32767) then
						temp_int := 32767;
					elsif(temp_int < -32768) then
						temp_int := -32768;
					end if;
					rd(16*index+15 downto index*16) <= std_logic_vector(to_unsigned(temp_int,16));
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "0011") then
				--BCW: broadcast word block
				temp_vector := rs_1(31 downto 0);
				for index in 0 to 3 loop
					rd(index*32+31 downto index*32) <= temp_vector;
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "0100") then
				--CGH: carry generate halfword block
				for index in 0 to 7 loop
					temp_int := to_integer(unsigned(rs_1(16*index+15 downto index*16))) + to_integer(unsigned(rs_2(16*index+15 downto index*16)));
					if(temp_int > 32767) then
						rd(16*index+15 downto index*16) <= std_logic_vector(to_unsigned(1,16));
					else
						rd(16*index+15 downto index*16) <= std_logic_vector(to_unsigned(0,16));
					end if;
					
				end loop;
				
					
			elsif(instruction_in(18 downto 15) = "0101") then
				--CLZ: count leading zeros in word block
				for segment in 0 to 3 loop
					temp_vector := rs_1(segment*32+31 downto segment*32);
					temp_int := 0;
					for index in 31 downto 0 loop
						exit when temp_vector(index) = '1';
						temp_int := temp_int + 1;
					end loop;
					rd(segment*32+31 downto segment*32) <= std_logic_vector(to_unsigned(temp_int, 32));
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "0110") then
				--MAX: max signed word block
				for index in 0 to 3 loop
					if(signed(rs_1(index*32+31 downto index*32)) >= signed(rs_2(index*32+31 downto index*32))) then
						temp_vector := rs_1(index*32+31 downto index*32);
					else
						temp_vector := rs_2(index*32+31 downto index*32);
					end if;
					
					rd(index*32+31 downto index*32) <= temp_vector;
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "0111") then
				--MIN: min signed word block
				for index in 0 to 3 loop
					if(signed(rs_1(index*32+31 downto index*32)) <= signed(rs_2(index*32+31 downto index*32))) then
						temp_vector := rs_1(index*32+31 downto index*32);
					else
						temp_vector := rs_2(index*32+31 downto index*32);
					end if;
					
					rd(index*32+31 downto index*32) <= temp_vector;
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "1000") then
				--MSGN: multiply sign block
				for index in 0 to 3 loop
					if(signed(rs_2(index*32+31 downto index*32)) < 0) then
						temp_int := to_integer(signed( rs_1(index*32+31 downto index*32) ))*(-1);
						temp_vector(index*32+31 downto index*32) := std_logic_vector(to_signed(temp_int, 32) );
					else
						temp_vector(index*32+31 downto index*32) := rs_1(index*32+31 downto index*32);
					end if;
					
					rd(index*32+31 downto index*32) <= temp_vector(index*32+31 downto index*32);
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "1001") then
				--POPCNTH: count ones in halfwords block
				for segment in 0 to 7 loop
					temp_vector := rs_1(segment*16+15 downto segment*16);
					temp_int := 0;
					for index in 15 downto 0 loop
						exit when temp_vector(index) = '0';
						temp_int := temp_int + 1;
					end loop;
					rd(segment*16+15 downto segment*16) <= std_logic_vector(to_unsigned(temp_int, 16));
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "1010") then
				--ROT: rotate bits right block
				temp_int := to_integer(signed(rs_2(6 downto 0)));
				temp_vector2 := rs_1;
				if(temp_int >= 0) then
					for index in 0 to temp_int loop
						temp_vector2 := temp_vector2(0) & temp_vector2(127 downto 1);
					end loop;
				else
					temp_int := temp_int*(-1);
					for index in 0 to temp_int loop
						temp_vector2 := temp_vector2(126 downto 0) & temp_vector2(127);
					end loop;
				end if;
				
				
				rd <= temp_vector2;
				
				
			elsif(instruction_in(18 downto 15) = "1011") then
				--ROTW: rotate bits in word block
				temp_int := to_integer(signed(rs_2(5 downto 0)));
				for index in 0 to 3 loop
					temp_vector := rs_1(index*32+31 downto index*32);
					if(temp_int >= 0) then
						for rot in 0 to temp_int loop
							temp_vector := temp_vector(0) & temp_vector(31 downto 1);
						end loop;
					else
						temp_int := temp_int*(-1);
						for rot in 0 to temp_int loop
							temp_vector := temp_vector(30 downto 0) & temp_vector(31);
						end loop;
					end if;
					
					
					rd(index*32+31 downto index*32) <= temp_vector;
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "1100") then
					--can the immediate value be negative?
					--what does it mean for the immediate value to be coming from the instruction? 
				--SHLHI: shift left halfword immediate block
				temp_int := to_integer(unsigned(rs_2(4 downto 0)));
				for index in 0 to 7 loop
					temp_vector3 := rs_1(index*16+15 downto index*16);
					for	shft in 0 to temp_int loop
						temp_vector3 := temp_vector3(14 downto 0) & '0';
					end loop;
					rd(index*16+15 downto index*16) <= temp_vector3;
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "1101") then
				--SFH: subtract from halfword block
				for index in 0 to 7 loop
					temp_int := to_integer(unsigned(rs_2(index*16+15 downto index*16))) - to_integer(unsigned(rs_1(index*16+15 downto index*16)));
					if(temp_int < 0) then
						temp_int := 32768 - temp_int;
					end if;
				end loop;
				
			elsif(instruction_in(18 downto 15) = "1110") then
				--SFHS: subtract from halfword saturated block
				for index in 0 to 7 loop
					temp_int := to_integer(signed(rs_2(index*16+15 downto index*16))) - to_integer(signed(rs_1(index*16+15 downto index*16)));
					if(temp_int < -32768) then
						temp_int :=	-32768;
					elsif(temp_int > 32767) then
						temp_int := 32767;
					end if;
					rd(index*16+15 downto index*16) <= std_logic_vector(to_signed(temp_int, 16));
				end loop;
				
				
			elsif(instruction_in(18 downto 15) = "1111") then
				--XOR: bitwise logical exclusive-or block
				rd <= rs_1 xor rs_2;
			end if;
			
			
		end if;
	end process alu;
	
end alu_arch;