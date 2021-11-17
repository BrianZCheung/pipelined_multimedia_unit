--
-- Entity Name : stage3
-- Entity Description: 
-- Architecture Name : stage3_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;

entity stage3 is
	
	port(
	--inputs for the forwarding_mux entity:
	instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed		 
	rs_1 : in std_logic_vector(127 downto 0);   
	rs_2 : in std_logic_vector(127 downto 0);
	rs_3 : in std_logic_vector(127 downto 0); 
	updated_rd_in : in std_logic_vector(127 downto 0);
	updated_rd_address_in : in std_logic_vector(4 downto 0);
	
	--outputs from the alu:
	updated_rd_out : out std_logic_vector(127 downto 0);
	updated_rd_address_out : out std_logic_vector(4 downto 0)
	); 
	
end stage3;
	
architecture stage3_arch of stage3 is
	--signals that need to travel from forwarding_mux to alu:
	signal rs_1_frwd2alu : std_logic_vector(127 downto 0);
	signal rs_2_frwd2alu : std_logic_vector(127 downto 0);
	signal rs_3_frwd2alu : std_logic_vector(127 downto 0);

	component forwarding_mux
		port(
		instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed		 
		rs_1 : in std_logic_vector(127 downto 0);   
		rs_2 : in std_logic_vector(127 downto 0);
		rs_3 : in std_logic_vector(127 downto 0); 
		updated_rd : in std_logic_vector(127 downto 0);
		updated_rd_address : in std_logic_vector(4 downto 0);
		
		rs_1_out : out std_logic_vector(127 downto 0);
		rs_2_out : out std_logic_vector(127 downto 0);
		rs_3_out : out std_logic_vector(127 downto 0)
		);
	end component;
	
	component alu
		port(
		instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed		 
		rs_1 : in std_logic_vector(127 downto 0);   
		rs_2 : in std_logic_vector(127 downto 0);
		rs_3 : in std_logic_vector(127 downto 0);
		rd : out std_logic_vector(127 downto 0);
		rd_address : out std_logic_vector(4 downto 0)
		);
	end component;

begin
	part1: forwarding_mux
		port map(
			instruction_in => instruction_in,		 
			rs_1 => rs_1,  
			rs_2 =>	rs_2,
			rs_3 => rs_3,
			updated_rd => updated_rd_in,
			updated_rd_address => updated_rd_address_in,
			
			rs_1_out =>	rs_1_frwd2alu,
			rs_2_out =>	rs_2_frwd2alu,
			rs_3_out =>	rs_3_frwd2alu
		);
		
	part2: alu
		port map(
			instruction_in => instruction_in, --just takes in the same instruction input as forwarding_mux		 
			rs_1 => rs_1_frwd2alu,   
			rs_2 => rs_2_frwd2alu,
			rs_3 => rs_3_frwd2alu,
			rd => updated_rd_out,
			rd_address => updated_rd_address_out
		);
	
end stage3_arch;
