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

entity pipelined_multimedia_unit is	  
	port(
	clk : in std_logic;
	pc_reset : in std_logic;
	load_enable : in std_logic;
	load_instruction : in std_logic_vector(24 downto 0)
	);
	
end pipelined_multimedia_unit;	





architecture pipelined_multimedia_unit_arch of pipelined_multimedia_unit is

component IF_stage	   
	port(
		pc_in : in std_logic_vector(5 downto 0);
		pc_reset : in std_logic;
		load_enable : in std_logic;
		load_instruction : in std_logic_vector(24 downto 0);
		instruction_out : out std_logic_vector(24 downto 0);-- instruction being executed
		pc_out : out std_logic_vector(5 downto 0)
	);
end component IF_stage;

--signals to transfer information FROM IF_stage: to IF/ID register	 
signal IF_instr : std_logic_vector(24 downto 0);--(IF_stage -> IF_ID_Reg)
signal IF_pc : std_logic_vector(5 downto 0);--(IF_stage -> IF_ID_Reg)





component IF_ID_Reg
	port(
		clk : in std_logic;
		instruction_in: in std_logic_vector(24 downto 0);
		pc_in : in std_logic_vector(5 downto 0);
		pc_reset : in std_logic;
		instruction_out: out std_logic_vector(24 downto 0);
		pc_out : out std_logic_vector(5 downto 0)
	);	
end component IF_ID_Reg;

--signals to transfer information FROM IF_ID_Reg: to ID stage & ID_IF register	& IF stage
signal IF_ID_Reg_instr : std_logic_vector(24 downto 0);--(IF_ID_Reg -> ID_stage & IF_ID_Reg -> ID_EX_Reg)
signal IF_ID_Reg_pc : std_logic_vector(5 downto 0);--(IF_ID_Reg -> IF_stage)





component ID_stage	   
	port(
		i_fetch : in std_logic_vector(24 downto 0);-- instruction being executed	
		i_wb : in std_logic_vector(24 downto 0);-- instruction of the write back data 		 
		wr_enabled : in std_logic;-- write enable signal
		rd : in std_logic_vector(127 downto 0);	
		rs_1 : out std_logic_vector(127 downto 0);   
		rs_2 : out std_logic_vector(127 downto 0);
		rs_3 : out std_logic_vector(127 downto 0)
	);
end component ID_stage;	

--signals to transfer information FROM ID_stage: to ID_EX register	  
signal ID_stage_rs_1 : std_logic_vector(127 downto 0);--(ID_stage -> ID_EX_Reg)   
signal ID_stage_rs_2 : std_logic_vector(127 downto 0);--(ID_stage -> ID_EX_Reg) 
signal ID_stage_rs_3 : std_logic_vector(127 downto 0);--(ID_stage -> ID_EX_Reg) 





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

--signals to transfer information FROM ID_EX_stage: to EX_stage and EX_WB register	  
signal ID_EX_Reg_instr : std_logic_vector(24 downto 0);--(ID_EX_Reg -> EX_stage & ID_EX_Reg -> EX_WB_Reg)
signal ID_EX_Reg_rs_1 : std_logic_vector(127 downto 0);--(ID_EX_Reg -> EX_stage)   
signal ID_EX_Reg_rs_2 : std_logic_vector(127 downto 0);--(ID_EX_Reg -> EX_stage) 
signal ID_EX_Reg_rs_3 : std_logic_vector(127 downto 0);--(ID_EX_Reg -> EX_stage) 





component EX_stage	   
	port(
		--inputs for the forwarding_mux entity:
		instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed		 
		rs_1 : in std_logic_vector(127 downto 0);   
		rs_2 : in std_logic_vector(127 downto 0);
		rs_3 : in std_logic_vector(127 downto 0); 
		rd_in : in std_logic_vector(127 downto 0);
		rd_address_in : in std_logic_vector(4 downto 0);
		
		--outputs from the alu:
		rd_out : out std_logic_vector(127 downto 0);
		rd_address_out : out std_logic_vector(4 downto 0) 
	);
end component EX_stage; 	   

--signals to transfer information FROM EX_Stage: to EX_WB register	
signal EX_stage_rd : std_logic_vector(127 downto 0);--(EX_stage -> EX_WB_Reg) 
signal EX_stage_rd_address : std_logic_vector(4 downto 0);--(EX_stage -> EX_WB_Reg)





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

--signals to transfer information FROM EX_WB register: to WB_stage and EX_stage 
signal EX_WB_Reg_instr : std_logic_vector(24 downto 0);--(EX_WB_Reg -> WB_stage & EX_WB_Reg -> ID_stage)
signal EX_WB_Reg_rd : std_logic_vector(127 downto 0);--(EX_WB_Reg -> WB_stage & EX_WB_Reg -> EX_stage)
signal EX_WB_Reg_rd_address : std_logic_vector(4 downto 0);--(EX_WB_Reg -> EX_stage)





component WB_stage
	port(
		instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed	
		rd_in : in std_logic_vector(127 downto 0);	
		
		rd_out : out std_logic_vector(127 downto 0);   
		wr_enabled : out std_logic
	);
end component;

--signals to transfer information FROM WB_stage: to ID_stage
signal WB_stage_wr_enabled : std_logic;--(WB_stage -> ID_stage)
signal WB_stage_rd : std_logic_vector(127 downto 0);--(WB_stage -> ID_stage)



begin

	stage_1: IF_stage
	port map(
		pc_in => IF_ID_Reg_pc,
		pc_reset => pc_reset,
		load_enable => load_enable,
		load_instruction => load_instruction,
		instruction_out => 	IF_instr,
		pc_out => IF_pc
	);				  
	
	stage_1_to_2_reg: IF_ID_Reg
	port map(
		clk => clk,
		instruction_in => IF_instr,
		pc_in => IF_pc,
		pc_reset => pc_reset,
		instruction_out => IF_ID_Reg_instr,
		pc_out => IF_ID_Reg_pc
	);
	
	stage_2: ID_stage
	port map(
		i_fetch => IF_ID_Reg_instr,	 
		i_wb => EX_WB_Reg_instr,
		wr_enabled => WB_stage_wr_enabled,
		rd => WB_stage_rd,
		rs_1 =>	ID_stage_rs_1,
		rs_2 =>	ID_stage_rs_2,
		rs_3 => ID_stage_rs_3 
	);	
	
	stage_2_to_3_reg: ID_EX_Reg
	port map(
		clk => clk,
		rs_1_in => ID_stage_rs_1,  
		rs_2_in => ID_stage_rs_2,
		rs_3_in => ID_stage_rs_3,
		instruction_in => IF_ID_Reg_instr,
		rs_1_out => ID_EX_Reg_rs_1,   
		rs_2_out => ID_EX_Reg_rs_2,
		rs_3_out => ID_EX_Reg_rs_3,
		instruction_out => ID_EX_Reg_instr
	);
	
	stage_3: EX_stage
	port map(
		instruction_in => ID_EX_Reg_instr,
		rs_1 => ID_EX_Reg_rs_1,	   
		rs_2 => ID_EX_Reg_rs_2,
		rs_3 => ID_EX_Reg_rs_3,	 
		rd_in => EX_WB_Reg_rd,
		rd_address_in => EX_WB_Reg_rd_address,
		rd_out => EX_stage_rd,
		rd_address_out => EX_stage_rd_address
	);	   
	
	stage_3_to_4_reg: EX_WB_Reg
	port map(
		clk => clk,	 
		rd_in => EX_stage_rd,
		rd_address_in => EX_stage_rd_address,
		instruction_in => ID_EX_Reg_instr, 
		rd_out =>  EX_WB_Reg_rd,
		rd_address_out => EX_WB_Reg_rd_address,
		instruction_out => EX_WB_Reg_instr 	
	);
	
	stage_4: WB_stage
	port map(
		instruction_in => EX_WB_Reg_instr,
		rd_in => EX_WB_Reg_rd,	
		rd_out => WB_stage_rd,   
		wr_enabled => WB_stage_wr_enabled
	);
	
	
	
end pipelined_multimedia_unit_arch;