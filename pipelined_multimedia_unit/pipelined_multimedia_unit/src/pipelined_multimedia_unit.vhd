--
-- Entity Name : piplined_multimedia_unit
-- Entity Description: 
-- Architecture Name : piplined_multimedia_unit_arch
-- Description :	   
-- 
-- Authored by : Brian Cheung and Ryuichi Lin
--  
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;		

entity piplined_multimedia_unit is	  
	port(
	  clk : in std_logic
	);
	
end piplined_multimedia_unit;	



architecture piplined_multimedia_unit_arch of piplined_multimedia_unit is

--signals for IF stage
signal pc : std_logic_vector(31 downto 0);

component IF_Stage	   
	port(
		pc : in std_logic_vector(31 downto 0);
		instruction_out : out std_logic_vector(24 downto 0)-- instruction being executed
	);
end component IF_Stage;

--signals to transfer information to IF/ID register	 
signal IF_instr : std_logic_vector(24 downto 0);

component IF_ID_Reg
	port(
		clk : in std_logic;
		instruction_in: in std_logic_vector(24 downto 0);
		instruction_out: out std_logic_vector(24 downto 0)
	);	
end component IF_ID_Reg;
		
--signals to transfer information to ID & register fetch stage
signal IF_ID_Reg_instr : std_logic_vector(24 downto 0);

component ID_Reg	   
	port(
		i_fetch : in std_logic_vector(24 downto 0);-- instruction being executed	
		i_wb : in std_logic_vector(24 downto 0);-- instruction of the write back data 		 
		rd : in std_logic_vector(127 downto 0);	
		rs_1 : out std_logic_vector(127 downto 0);   
		rs_2 : out std_logic_vector(127 downto 0);
		rs_3 : out std_logic_vector(127 downto 0)	
	);
end component ID_Reg;	

--signals to transfer information to ID_EX register	  
signal ID_Reg_instr : std_logic_vector(24 downto 0);
signal ID_Reg_rs_1 : std_logic_vector(127 downto 0);   
signal ID_Reg_rs_2 : std_logic_vector(127 downto 0); 
signal ID_Reg_rs_3 : std_logic_vector(127 downto 0); 

component ID_EX_Reg
	port(
		clk : in std_logic;
		rs_1_in : in std_logic_vector(127 downto 0);   
		rs_2_in : in std_logic_vector(127 downto 0);
		rs_3_in : in std_logic_vector(127 downto 0);
		instruction_in: in std_logic_vector(24 downto 0);
		rs_1_out : out std_logic_vector(127 downto 0);   
		rs_2_out : out std_logic_vector(127 downto 0);
		rs_3_out : out std_logic_vector(127 downto 0);
		instruction_out: out std_logic_vector(24 downto 0)
	);	
end component ID_EX_Reg;

--signals to transfer information to ALU stage	  
signal ID_EX_Reg_instr : std_logic_vector(24 downto 0);
signal ID_EX_Reg_rs_1 : std_logic_vector(127 downto 0);   
signal ID_EX_Reg_rs_2 : std_logic_vector(127 downto 0); 
signal ID_EX_Reg_rs_3 : std_logic_vector(127 downto 0); 

component stage3	   
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
end component stage3; 	   

--signals to transfer information to EX_WB register	
--signal stage3_instr : std_logic_vector(24 downto 0);
signal stage3_rd : std_logic_vector(127 downto 0); 
signal stage3_rd_address : std_logic_vector(4 downto 0);

component EX_WB_Reg
	port(
		clk : in std_logic;
		rd_in : in std_logic_vector(127 downto 0);   
		rd_address_in : in std_logic_vector(4 downto 0);
		instruction_in: in std_logic_vector(24 downto 0);
		rd_out : out std_logic_vector(127 downto 0);   
		rd_address_out : out std_logic_vector(4 downto 0);
		instruction_out: out std_logic_vector(24 downto 0)
	);	
end component EX_WB_Reg;	 

--signals for write back 
signal EX_WB_Reg_instr : std_logic_vector(24 downto 0);
signal EX_WB_Reg_rd : std_logic_vector(127 downto 0);
signal EX_WB_Reg_rd_address : std_logic_vector(4 downto 0);


begin

	stage_1: IF_Stage
	port map(
		pc => pc,
		instruction_out => 	IF_instr
	);				  
	
	stage_1_to_2_reg: IF_ID_Reg
	port map(
		clk => clk,
		instruction_in => IF_instr,
		instruction_out => IF_ID_Reg_instr
	);
	
	stage_2: ID_Reg
	port map(
	i_fetch => IF_ID_Reg_instr,	 
	i_wb => EX_WB_Reg_instr,
	rd => EX_WB_Reg_rd,
	rs_1 =>	ID_Reg_rs_1,
	rs_2 =>	ID_Reg_rs_2,
	rs_3 => ID_Reg_rs_3 
	);	
	
	stage_2_to_3_reg: IF_ID_Reg
	port map(
		clk => clk,  
		instruction_in => IF_ID_Reg_instr,
		instruction_out => ID_EX_Reg_instr
	);
	
	stage_3: stage3
	port map(
		instruction_in => ID_EX_Reg_instr,
		rs_1 => ID_EX_Reg_rs_1,	   
		rs_2 => ID_EX_Reg_rs_2,
		rs_3 => ID_EX_Reg_rs_3,	 
		updated_rd_in => EX_WB_Reg_rd,
		updated_rd_address_in => EX_WB_Reg_rd_address,
		updated_rd_out => stage3_rd,
		updated_rd_address_out => stage3_rd_address
	);	   
	
	stage_3_to_4_reg: EX_WB_Reg
	port map(
	clk => clk,	 
		rd_in => stage3_rd,
		rd_address_in => stage3_rd_address,
		instruction_in => ID_EX_Reg_instr, 
		rd_out =>  EX_WB_Reg_rd,
		rd_address_out => EX_WB_Reg_rd_address,
		instruction_out => EX_WB_Reg_instr 	
	);
	
	
	
end piplined_multimedia_unit_arch;