--
-- Entity Name : ID_stage
-- Entity Description: 
-- Architecture Name : ID_stage_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;

package ID_package is
	constant MAX_REGSTER_SIZE : integer := 32;
	type REG is array ((MAX_REGSTER_SIZE-1) downto 0) of std_logic_vector(127 downto 0);
end package;

package body ID_package is
end package body;




library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use work.ID_package.all;

entity ID_stage is
	port(
	i_fetch : in std_logic_vector(24 downto 0);-- instruction being executed	
	i_wb : in std_logic_vector(24 downto 0);-- instruction of the write back data
	wr_enabled : in std_logic;-- write enable signal
	rd : in std_logic_vector(127 downto 0);
	
	rs_1 : out std_logic_vector(127 downto 0);   
	rs_2 : out std_logic_vector(127 downto 0);
	rs_3 : out std_logic_vector(127 downto 0);
	
	ID_registers : out REG
	);
end ID_stage;

architecture ID_stage_arch of ID_stage is	 	   

begin		  															
	
	ID_stage: process(i_fetch, i_wb, wr_enabled, rd)			 			
	
	variable registers : REG;
	variable valid_reg : std_logic_vector((MAX_REGSTER_SIZE-1) downto 0) := (others=>'0');
	
	begin 		
		
		--update rd given write back address specified in i_wb
		if(wr_enabled = '1') then
			registers(to_integer(unsigned(i_wb(4 downto 0)))) := rd;
			valid_reg(to_integer(unsigned(i_wb(4 downto 0)))) := '1';
			
			--send the array of registers out so tb can read:
			ID_registers <= registers;
		end if;
		
		
		--reads rs1 rs2 rs3 from register depending on instruction
		
		--4.1 instructions	 
		--Load Immediate
		if(i_fetch(24) = '0') then
			--assumes rs1 to be rd
			if(valid_reg(to_integer(unsigned(i_fetch(4 downto 0)))) = '1') then
				rs_1 <= registers(to_integer(unsigned(i_fetch(4 downto 0))));
			else
				rs_1 <= x"00000000000000000000000000000000";
			end if;
			
		--4.2 instructions 
		--Multiply-Add and Multiply-Subtract R4-Instruction Format
		elsif(i_fetch(24 downto 23) = "10") then	  
			if(valid_reg(to_integer(unsigned(i_fetch(19 downto 15)))) = '1') then
				rs_3 <= registers(to_integer(unsigned(i_fetch(19 downto 15))));
			else
				rs_3 <= x"00000000000000000000000000000000";
			end if;
			if(valid_reg(to_integer(unsigned(i_fetch(14 downto 10)))) = '1') then
				rs_2 <= registers(to_integer(unsigned(i_fetch(14 downto 10))));
			else
				rs_2 <= x"00000000000000000000000000000000";
			end if;
			if(valid_reg(to_integer(unsigned(i_fetch(9 downto 5)))) = '1') then
				rs_1 <= registers(to_integer(unsigned(i_fetch(9 downto 5))));
			else
				rs_1 <= x"00000000000000000000000000000000";
			end if;	 
			
		--4.3 instructions	
		--R3-Instruction Format
		elsif(i_fetch(24 downto 23) = "11") then	  
			if(valid_reg(to_integer(unsigned(i_fetch(14 downto 10)))) = '1') then
				rs_2 <= registers(to_integer(unsigned(i_fetch(14 downto 10))));
			else
				rs_2 <= x"00000000000000000000000000000000";
			end if;
			if(valid_reg(to_integer(unsigned(i_fetch(9 downto 5)))) = '1') then
				rs_1 <= registers(to_integer(unsigned(i_fetch(9 downto 5))));
			else
				rs_1 <= x"00000000000000000000000000000000";
			end if;	
		end if;
		
		
	end process ID_stage;
	
	
end ID_stage_arch;