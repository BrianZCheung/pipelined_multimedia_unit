--
-- Entity Name : ID_stage_tb
-- Entity Description: testbench for our ID_stage stage
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

entity ID_EX_Reg_tb is
end ID_EX_Reg_tb;

architecture tb_architecture of ID_EX_Reg_tb is
	
-- stimulus signals 
signal clk_tb: std_logic;
signal rs_1_in_tb : std_logic_vector(127 downto 0);
signal rs_2_in_tb : std_logic_vector(127 downto 0);
signal rs_3_in_tb : std_logic_vector(127 downto 0);	 
signal instruction_in_tb : std_logic_vector(24 downto 0);	 
signal cont_EX_in_tb : std_logic;	
signal cont_WB_in_tb : std_logic;

-- observed signals 
signal rs_1_out_tb : std_logic_vector(127 downto 0);
signal rs_2_out_tb : std_logic_vector(127 downto 0);
signal rs_3_out_tb : std_logic_vector(127 downto 0);   
signal instruction_out_tb : std_logic_vector(24 downto 0);	  
signal cont_EX_out_tb : std_logic;
signal cont_WB_out_tb : std_logic;
	
	
begin
	
	-- Unit Under Test port map
	UUT : entity ID_EX_Reg
	port map (
		clk => clk_tb,
		rs_1_in => rs_1_in_tb,
		rs_2_in => rs_2_in_tb,
		rs_3_in => rs_3_in_tb,
		instruction_in => instruction_in_tb,
		rs_1_out => rs_1_out_tb,
		rs_2_out => rs_2_out_tb,
		rs_3_out => rs_3_out_tb,
		instruction_out => instruction_out_tb,
		cont_EX_in => cont_EX_in_tb,	 
		cont_WB_in => cont_WB_in_tb,
		cont_EX_out => cont_EX_out_tb,  
		cont_WB_out => cont_EX_out_tb
		);
	
	stimlus: process	  
	begin
		
		clk_tb <= '0'; 
		wait for 100ns;
		rs_1_in_tb <= x"00000000000000000000000000000001";
		wait for 10ns;
		rs_2_in_tb <= x"00000000000000000000000000000010";	
		wait for 10ns;
		rs_3_in_tb <= x"00000000000000000000000000000011";
		wait for 10ns;			
		cont_EX_in_tb <= '1';	
		wait for 10ns;	
		cont_WB_in_tb <= '0';  
		wait for 10ns;	
		clk_tb <= '1';
		wait for 100ns;
		
		clk_tb <= '0'; 
		wait for 100ns;
		rs_1_in_tb <= x"10000000000000000000000000000001";	   
		wait for 10ns;
		rs_2_in_tb <= x"00000000000000000000000000000010";	
		wait for 10ns;
		rs_3_in_tb <= x"00000000000000000000000000000011";	 
		wait for 10ns;
		rs_1_in_tb <= x"00000000000000000000000000000100";	
		wait for 10ns; 
		cont_EX_in_tb <= '1';	
		wait for 10ns;	
		cont_WB_in_tb <= '1';  
		wait for 10ns;	
		clk_tb <= '1'; 
		wait for 100ns;
	
	std.env.finish;
	end process;	
	
	
	
end tb_architecture;
