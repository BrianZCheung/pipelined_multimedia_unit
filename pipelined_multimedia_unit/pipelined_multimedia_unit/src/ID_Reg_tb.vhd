--
-- Entity Name : ID_Reg_tb
-- Entity Description: testbench for our ID_Reg stage
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

entity ID_Reg_tb is
end ID_Reg_tb;

architecture tb_architecture of ID_Reg_tb is
	
-- stimulus signals 
signal i_fetch_tb : std_logic_vector(24 downto 0);		 
signal i_wb_tb : std_logic_vector(24 downto 0);
signal rd_tb : std_logic_vector(127 downto 0);	

-- observed signals 
signal rs_1_tb : std_logic_vector(127 downto 0);
signal rs_2_tb : std_logic_vector(127 downto 0);
signal rs_3_tb : std_logic_vector(127 downto 0);
	
	
begin
	
	-- Unit Under Test port map
	UUT : entity ID_Reg
	port map (
		i_fetch => i_fetch_tb,
		i_wb => i_wb_tb,
		rd => rd_tb,
		rs_1 => rs_1_tb,
		rs_2 => rs_2_tb,
		rs_3 => rs_3_tb
		);
	
	stimlus: process	  
	begin
		
		i_fetch_tb <= "0000000000000000000000000";
		i_wb_tb <= "0000000000000000000000000";
		rd_tb <= x"00000000000000000000000000000001";	   
		wait for 200ns;	
		
		i_fetch_tb <= "0000000000000000000000000";
		i_wb_tb <= "0000000000000000000000000";
		rd_tb <= x"00000000000000000000000000000001";	   
		wait for 200ns;
		
		i_fetch_tb <= "0000000000000000000000000";
		i_wb_tb <= "0000000000000000000000001";
		rd_tb <= x"00000000000000000000000000000010";	   
		wait for 200ns;	 
		
		i_fetch_tb <= "1000000000000000000100011";
		i_wb_tb <= "0000000000000000000000011";
		rd_tb <= x"00000000000000000000000000000111";	   
		wait for 200ns;
	
	std.env.finish;
	end process;	
	
	
	
end tb_architecture;
