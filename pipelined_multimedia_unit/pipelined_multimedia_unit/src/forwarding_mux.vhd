--
-- Entity Name : forwarding_mux
-- Entity Description: 
-- Architecture Name : forwarding_mux_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;

entity forwarding_mux is
	
	port(
		instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed		 
		rs_1 : in std_logic_vector(127 downto 0);   
		rs_2 : in std_logic_vector(127 downto 0);
		rs_3 : in std_logic_vector(127 downto 0); 
		updated_rd : in std_logic_vector(127 downto 0);
		updated_rd_address : in std_logic_vector(4 downto 0); 
		cont_WB_in : in std_logic;
		
		rs_1_out : out std_logic_vector(127 downto 0);
		rs_2_out : out std_logic_vector(127 downto 0);
		rs_3_out : out std_logic_vector(127 downto 0)
	);
	
end forwarding_mux;


architecture forwarding_mux_arch of forwarding_mux is

begin
	
	forwarding_mux: process(instruction_in, rs_1, rs_2, rs_3, updated_rd)
	--variables to save 3 register addresses within instruction_in:
	variable req_rs_1: std_logic_vector(4 downto 0) := "-----";
	variable req_rs_2: std_logic_vector(4 downto 0) := "-----";
	variable req_rs_3: std_logic_vector(4 downto 0) := "-----";		  
	
	begin
		--if the instruction is a load immediate
		if(instruction_in(24) = '0') then
			req_rs_1 := instruction_in(4 downto 0);
			req_rs_2 := "-----";
			req_rs_3 := "-----";
		
		--if the instruction is an R4 instruction
		elsif(instruction_in(24 downto 23) = "10") then
			req_rs_1 := instruction_in(9 downto 5);
			req_rs_2 := instruction_in(14 downto 10);
			req_rs_3 := instruction_in(19 downto 15);
		
		--if the instruction is an R3 instruction
		elsif(instruction_in(24 downto 23) = "11") then
			--if the R3 instruction is a NOP:
			if(instruction_in(18 downto 15) = "0000") then
				req_rs_1 := "-----";
				req_rs_2 := "-----";
				req_rs_3 := "-----";
			--in all other cases:
			else
				req_rs_1 := instruction_in(9 downto 5);
				req_rs_2 := instruction_in(14 downto 10);
				req_rs_3 := "-----";
			end if;
			
			
		end if;
		
		
		--check if there is a write back occuring	 
		--if it is, check if forwarding needs to occur
		--if not, do not forward rd from ALU
		if(cont_WB_in = '1') then
			--if updated rd has the same address as requested rs1
			if(updated_rd_address = req_rs_1) then
				rs_1_out <= updated_rd;	
			else
				rs_1_out <= rs_1;
			end if;
			--if updated rd has the same address as requested rs2
			if(updated_rd_address = req_rs_2) then
				rs_2_out <= updated_rd;	
			else
				rs_2_out <= rs_2;
			end if;	
			--if updated rd has the same address as requested rs3
			if(updated_rd_address = req_rs_3) then
				rs_3_out <= updated_rd;		
			else
				rs_3_out <= rs_3;
			end if;	  
		else				
			--if there has been no instructions that require write back, pass register information wthout forwarding
			rs_1_out <= rs_1;
			rs_2_out <= rs_2;
			rs_3_out <= rs_3;
		end if;	 
	
	
	end process forwarding_mux;

	
end forwarding_mux_arch;


