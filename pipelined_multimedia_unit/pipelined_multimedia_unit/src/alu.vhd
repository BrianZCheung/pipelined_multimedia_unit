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
	
	li: process(instruction_in(24))				   
	variable result: std_logic_vector(127 downto 0);
	begin 
		if(instruction_in(24) = '0') then	  	
			result(((16*to_integer(unsigned(instruction_in(23 downto 21))))+15) downto (16*to_integer(unsigned(instruction_in(23 downto 21))))) := instruction_in(20 downto 5);	
		end if;	  
		rd <= result;
	end process li;
	
	r3: process(instruction_in(24 downto 23)) 
	variable longMin: integer := -(2**63);
	variable longMax: integer := (2**63) - 1;	 
	variable intMin: integer := -(2**31); 
	variable intMax: integer := (2**31) - 1;
	variable result: std_logic_vector(127 downto 0);
	
	begin  
		if(instruction_in(24 downto 23) = "10") then
			if(instruction_in(22 downto 20) = "000") then
				for i in 0 to 3 loop
					result(((32*i)+31) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((32*i)+15 downto 32*i)))*to_integer( signed(rs_2((32*i)+15 downto 32*i))) ) + to_integer( signed(rs_1((32*i)+31 downto (32*i)))) ),32));
				end loop;	 
				if(to_integer(signed(result)) < intMin) then
					result := std_logic_vector(to_signed(intMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(intMax,128));
				end if;
			elsif(instruction_in(22 downto 20) = "001") then	 
				for i in 0 to 3 loop
					result(((32*i)+31) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((32*i)+31 downto (32*i)+16)))*to_integer( signed(rs_2((32*i)+31 downto (32*i)+16))) ) + to_integer( signed(rs_1((32*i)+31 downto (32*i)))) ),32));
				end loop;	 
				if(to_integer(signed(result)) < intMin) then
					result := std_logic_vector(to_signed(intMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(intMax,128));
				end if;	
			elsif(instruction_in(22 downto 20) = "010") then   
				for i in 0 to 3 loop
					result(((32*i)+31) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((32*i)+15 downto 32*i)))*to_integer( signed(rs_2((32*i)+15 downto 32*i))) ) - to_integer( signed(rs_1((32*i)+31 downto (32*i)))) ),32));
				end loop;	 
				if(to_integer(signed(result)) < intMin) then
					result := std_logic_vector(to_signed(intMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(intMax,128));
				end if;
			elsif(instruction_in(22 downto 20) = "011") then  
				for i in 0 to 3 loop
					result(((32*i)+31) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((32*i)+31 downto (32*i)+16)))*to_integer( signed(rs_2((32*i)+31 downto (32*i)+16))) ) - to_integer( signed(rs_1((32*i)+31 downto (32*i)))) ),32));
				end loop;	 
				if(to_integer(signed(result)) < intMin) then
					result := std_logic_vector(to_signed(intMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(intMax,128));
				end if;	
			elsif(instruction_in(22 downto 20) = "100") then		   
				for i in 0 to 1 loop
					result(((64*i)+63) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((64*i)+31 downto 64*i)))*to_integer( signed(rs_2((64*i)+31 downto 64*i))) ) + to_integer( signed(rs_1((64*i)+63 downto (64*i)))) ),64));
				end loop;	 
				if(to_integer(signed(result)) < longMin) then
					result := std_logic_vector(to_signed(longMin,128));
				elsif(to_integer(signed(result)) > longMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;
			elsif(instruction_in(22 downto 20) = "101") then	   
				for i in 0 to 1 loop
					result(((64*i)+63) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((64*i)+63 downto (64*i)+32)))*to_integer( signed(rs_2((64*i)+63 downto (64*i)+32))) ) + to_integer( signed(rs_1((64*i)+63 downto (64*i)))) ),64));
				end loop;	 
				if(to_integer(signed(result)) < longMin) then
					result := std_logic_vector(to_signed(longMin,128));
				elsif(to_integer(signed(result)) > longMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;
			elsif(instruction_in(22 downto 20) = "110") then		  
				for i in 0 to 1 loop
					result(((64*i)+63) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((64*i)+31 downto 64*i)))*to_integer( signed(rs_2((64*i)+31 downto 64*i))) ) - to_integer( signed(rs_1((64*i)+63 downto (64*i)))) ),64));
				end loop;	 
				if(to_integer(signed(result)) < longMin) then
					result := std_logic_vector(to_signed(longMin,128));
				elsif(to_integer(signed(result)) > longMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;
			elsif(instruction_in(22 downto 20) = "111") then
				for i in 0 to 1 loop
					result(((64*i)+63) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((64*i)+63 downto (64*i)+32)))*to_integer( signed(rs_2((64*i)+63 downto (64*i)+32))) ) - to_integer( signed(rs_1((64*i)+63 downto (64*i)))) ),64));
				end loop;	 
				if(to_integer(signed(result)) < longMin) then
					result := std_logic_vector(to_signed(longMin,128));
				elsif(to_integer(signed(result)) > longMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;
			end if;
		end if;		 
		rd <= result;
	end process r3;
	
	r4: process(instruction_in(24 downto 23))
	variable temp_int: integer;
	--conversion notes: integer to std_logic_vector: std_logic_vector( to_unsigned([the int], [num of bits]) )
	--				std_logic_vector to integer:
	begin
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
				
			elsif(instruction_in(18 downto 15) = "0011") then
				--BCW: broadcast word block
				
			elsif(instruction_in(18 downto 15) = "0100") then
				--CGH: carry generate halfword block
				
			elsif(instruction_in(18 downto 15) = "0101") then
				--CLZ: count leading zeros in word block
				
			elsif(instruction_in(18 downto 15) = "0110") then
				--MAX: max signed word block
				
			elsif(instruction_in(18 downto 15) = "0111") then
				--MIN: min signed word block
				
			elsif(instruction_in(18 downto 15) = "1000") then
				--MSGN: multiply sign block
				
			elsif(instruction_in(18 downto 15) = "1001") then
				--POPCNTH: count ones in halfwords block
				
			elsif(instruction_in(18 downto 15) = "1010") then
				--ROT: rotate bits right block
				
			elsif(instruction_in(18 downto 15) = "1011") then
				--ROTW: rotate bits in word block
				
			elsif(instruction_in(18 downto 15) = "1100") then
				--SHLHI: shift left halfword immediate block
				
			elsif(instruction_in(18 downto 15) = "1101") then
				--SFH: subtract from halfword block
				
			elsif(instruction_in(18 downto 15) = "1110") then
				--SFHS: subtract from halfword saturated block
				
			elsif(instruction_in(18 downto 15) = "1111") then
				--XOR: bitwise logical exclusive-or block	
			end if;
			
			
			
			
		end if;
	end process r4;
	
end alu_arch;