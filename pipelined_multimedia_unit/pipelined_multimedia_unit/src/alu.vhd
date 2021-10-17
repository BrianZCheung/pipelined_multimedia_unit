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
	begin 
		if(instruction_in(24) = '0') then
			
		end if;
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
					result := std_logic_vector(to_signed(longMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;	
			elsif(instruction_in(22 downto 20) = "100") then		   
				for i in 0 to 1 loop
					result(((64*i)+63) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((64*i)+31 downto 64*i)))*to_integer( signed(rs_2((64*i)+31 downto 64*i))) ) + to_integer( signed(rs_1((64*i)+63 downto (64*i)))) ),64));
				end loop;	 
				if(to_integer(signed(result)) < intMin) then
					result := std_logic_vector(to_signed(longMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;
			elsif(instruction_in(22 downto 20) = "101") then	   
				for i in 0 to 1 loop
					result(((64*i)+63) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((64*i)+63 downto (64*i)+32)))*to_integer( signed(rs_2((64*i)+63 downto (64*i)+32))) ) + to_integer( signed(rs_1((64*i)+63 downto (64*i)))) ),64));
				end loop;	 
				if(to_integer(signed(result)) < intMin) then
					result := std_logic_vector(to_signed(longMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;
			elsif(instruction_in(22 downto 20) = "110") then		  
				for i in 0 to 1 loop
					result(((64*i)+63) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((64*i)+31 downto 64*i)))*to_integer( signed(rs_2((64*i)+31 downto 64*i))) ) - to_integer( signed(rs_1((64*i)+63 downto (64*i)))) ),64));
				end loop;	 
				if(to_integer(signed(result)) < intMin) then
					result := std_logic_vector(to_signed(longMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;
			elsif(instruction_in(22 downto 20) = "111") then
				for i in 0 to 1 loop
					result(((64*i)+63) downto (32*i)) := std_logic_vector(to_signed(( ( to_integer( signed(rs_3((64*i)+63 downto (64*i)+32)))*to_integer( signed(rs_2((64*i)+63 downto (64*i)+32))) ) - to_integer( signed(rs_1((64*i)+63 downto (64*i)))) ),64));
				end loop;	 
				if(to_integer(signed(result)) < intMin) then
					result := std_logic_vector(to_signed(intMin,128));
				elsif(to_integer(signed(result)) > intMax) then
					result := std_logic_vector(to_signed(longMax,128));
				end if;
			end if;
		end if;		 
		rd <= result;
	end process r3;
	
	r4: process(instruction_in(24 downto 23))
	begin
		if(instruction_in(24 downto 23) = "11") then
			
		end if;
	end process r4;
	
end alu_arch;