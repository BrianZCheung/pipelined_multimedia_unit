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
use work.ID_package.all;

entity pipelined_multimedia_unit is	  
	port(
	clk : in std_logic;	   
	index : in std_logic_vector(31 downto 0);
	pc_reset : in std_logic;
	load_enable : in std_logic;
	load_instruction : in std_logic_vector(24 downto 0);
	
				  
	IF_instr_tb : out std_logic_vector(24 downto 0);	
	IF_pc_tb : out std_logic_vector(31 downto 0);
	IF_cont_EX_tb : out std_logic;
	IF_cont_WB_tb : out std_logic;
	
	IF_ID_Reg_instr_tb : out std_logic_vector(24 downto 0);
	IF_ID_Reg_pc_tb : out std_logic_vector(31 downto 0);
	
	ID_stage_rs_1_tb : out std_logic_vector(127 downto 0);
	ID_stage_rs_2_tb : out std_logic_vector(127 downto 0);
	ID_stage_rs_3_tb : out std_logic_vector(127 downto 0);
	
	ID_EX_Reg_instr_tb : out std_logic_vector(24 downto 0);
	ID_EX_Reg_rs_1_tb : out std_logic_vector(127 downto 0);
	ID_EX_Reg_rs_2_tb : out std_logic_vector(127 downto 0);
	ID_EX_Reg_rs_3_tb : out std_logic_vector(127 downto 0);
	ID_EX_Reg_cont_EX_tb : out std_logic;
	ID_EX_Reg_cont_WB_tb : out std_logic;
	
	EX_stage_rd_tb : out std_logic_vector(127 downto 0);
	EX_Stage_rd_address_tb : out std_logic_vector(4 downto 0); 
	EX_WB_Reg_instr_tb : out std_logic_vector(24 downto 0);
	EX_WB_Reg_cont_WB_tb : out std_logic;
	
	ID_registers_tb : out REG
	);
	
end pipelined_multimedia_unit;	





architecture pipelined_multimedia_unit_arch of pipelined_multimedia_unit is

component IF_stage	   
	port(	
		index : in std_logic_vector(31 downto 0);
		pc_in : in std_logic_vector(31 downto 0);
		pc_reset : in std_logic;
		load_enable : in std_logic;
		load_instruction : in std_logic_vector(24 downto 0);
		instruction_out : out std_logic_vector(24 downto 0);-- instruction being executed
		pc_out : out std_logic_vector(31 downto 0);
		cont_EX_out : out std_logic;
		cont_WB_out	: out std_logic
	);
end component IF_stage;

--signals to transfer information FROM IF_stage: to IF/ID register	 
signal IF_instr : std_logic_vector(24 downto 0);--(IF_stage -> IF_ID_Reg)
signal IF_pc : std_logic_vector(31 downto 0);--(IF_stage -> IF_ID_Reg)
signal IF_cont_EX : std_logic;
signal IF_cont_WB : std_logic;


component IF_ID_Reg
	port(
		clk : in std_logic;
		instruction_in: in std_logic_vector(24 downto 0);
		pc_in : in std_logic_vector(31 downto 0);
		pc_reset : in std_logic;
		instruction_out: out std_logic_vector(24 downto 0);
		pc_out : out std_logic_vector(31 downto 0);	
		cont_EX_in : in std_logic;
		cont_WB_in : in std_logic;
		cont_EX_out : out std_logic;
		cont_WB_out	: out std_logic
	);	
end component IF_ID_Reg;

--signals to transfer information FROM IF_ID_Reg: to ID stage & ID_IF register	& IF stage
signal IF_ID_Reg_instr : std_logic_vector(24 downto 0);--(IF_ID_Reg -> ID_stage & IF_ID_Reg -> ID_EX_Reg)
signal IF_ID_Reg_pc : std_logic_vector(31 downto 0);--(IF_ID_Reg -> IF_stage)  
signal IF_ID_Reg_cont_EX : std_logic;
signal IF_ID_Reg_cont_WB : std_logic;





component ID_stage	   
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
		instruction_out: out std_logic_vector(24 downto 0); 
		cont_EX_in : in std_logic;
		cont_WB_in : in std_logic;
		cont_EX_out : out std_logic;
		cont_WB_out	: out std_logic
	);	
end component ID_EX_Reg;

--signals to transfer information FROM ID_EX_stage: to EX_stage and EX_WB register	  
signal ID_EX_Reg_instr : std_logic_vector(24 downto 0);--(ID_EX_Reg -> EX_stage & ID_EX_Reg -> EX_WB_Reg)
signal ID_EX_Reg_rs_1 : std_logic_vector(127 downto 0);--(ID_EX_Reg -> EX_stage)   
signal ID_EX_Reg_rs_2 : std_logic_vector(127 downto 0);--(ID_EX_Reg -> EX_stage) 
signal ID_EX_Reg_rs_3 : std_logic_vector(127 downto 0);--(ID_EX_Reg -> EX_stage) 
signal ID_EX_Reg_cont_EX : std_logic;
signal ID_EX_Reg_cont_WB : std_logic;




component EX_stage	   
	port(
		--inputs for the forwarding_mux entity:
		instruction_in : in std_logic_vector(24 downto 0);-- instruction being executed		 
		rs_1 : in std_logic_vector(127 downto 0);   
		rs_2 : in std_logic_vector(127 downto 0);
		rs_3 : in std_logic_vector(127 downto 0); 
		rd_in : in std_logic_vector(127 downto 0);
		rd_address_in : in std_logic_vector(4 downto 0);   
		cont_WB_in : in std_logic;
		
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
		instruction_out: out std_logic_vector(24 downto 0); 
		cont_WB_in : in std_logic;
		cont_WB_out	: out std_logic
	);	
end component EX_WB_Reg;	 

--signals to transfer information FROM EX_WB register: to WB_stage and EX_stage 
signal EX_WB_Reg_instr : std_logic_vector(24 downto 0);--(EX_WB_Reg -> WB_stage & EX_WB_Reg -> ID_stage)
signal EX_WB_Reg_rd : std_logic_vector(127 downto 0);--(EX_WB_Reg -> WB_stage & EX_WB_Reg -> EX_stage)
signal EX_WB_Reg_rd_address : std_logic_vector(4 downto 0);--(EX_WB_Reg -> EX_stage)
signal EX_WB_Reg_cont_WB : std_logic;



begin

	stage_1: IF_stage
	port map(  
		index => index,
		pc_in => IF_ID_Reg_pc,
		pc_reset => pc_reset,
		load_enable => load_enable,
		load_instruction => load_instruction,
		instruction_out => 	IF_instr,
		pc_out => IF_pc,
		
		cont_EX_out => IF_cont_EX,
		cont_WB_out => IF_cont_WB
	);				  
	
	stage_1_to_2_reg: IF_ID_Reg
	port map(
		clk => clk,
		instruction_in => IF_instr,
		pc_in => IF_pc,
		pc_reset => pc_reset,
		instruction_out => IF_ID_Reg_instr,
		pc_out => IF_ID_Reg_pc,	 
		
		cont_EX_in => IF_cont_EX,
		cont_WB_in => IF_cont_WB,
		
		cont_EX_out => IF_ID_Reg_cont_EX,
		cont_WB_out => IF_ID_Reg_cont_WB
	);
	
	stage_2: ID_stage
	port map(
		i_fetch => IF_ID_Reg_instr,	 
		i_wb => EX_WB_Reg_instr,
		wr_enabled => EX_WB_Reg_cont_WB,
		rd => EX_WB_Reg_rd,
		rs_1 =>	ID_stage_rs_1,
		rs_2 =>	ID_stage_rs_2,
		rs_3 => ID_stage_rs_3,
		
		ID_registers => ID_registers_tb
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
		instruction_out => ID_EX_Reg_instr,	 
		
		cont_EX_in => IF_ID_Reg_cont_EX,
		cont_WB_in => IF_ID_Reg_cont_WB,
		
		cont_EX_out => ID_EX_Reg_cont_EX,
		cont_WB_out => ID_EX_Reg_cont_WB
	);
	
	stage_3: EX_stage
	port map(
		instruction_in => ID_EX_Reg_instr,
		rs_1 => ID_EX_Reg_rs_1,	   
		rs_2 => ID_EX_Reg_rs_2,
		rs_3 => ID_EX_Reg_rs_3,	 
		rd_in => EX_WB_Reg_rd,
		rd_address_in => EX_WB_Reg_rd_address,	
		cont_WB_in => ID_EX_Reg_cont_WB,
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
		instruction_out => EX_WB_Reg_instr,
		
		cont_WB_in => ID_EX_Reg_cont_WB,
		
		cont_WB_out => EX_WB_Reg_cont_WB
	);				
	
	IF_instr_tb <= IF_instr;
	IF_pc_tb <= IF_pc;
	IF_cont_EX_tb <= IF_cont_EX;
	IF_cont_WB_tb <= IF_cont_WB;
	
	IF_ID_Reg_instr_tb <= IF_ID_Reg_instr;
	IF_ID_Reg_pc_tb <= IF_ID_Reg_pc;
	
	ID_stage_rs_1_tb <= ID_stage_rs_1;	
	ID_stage_rs_2_tb <= ID_stage_rs_2;
	ID_stage_rs_3_tb <= ID_stage_rs_3; 
	
	ID_EX_Reg_instr_tb <= ID_EX_Reg_instr;
	ID_EX_Reg_rs_1_tb <= ID_EX_Reg_rs_1;
	ID_EX_Reg_rs_2_tb <= ID_EX_Reg_rs_2;
	ID_EX_Reg_rs_3_tb <= ID_EX_Reg_rs_3;   
	ID_EX_Reg_cont_EX_tb <= ID_EX_Reg_cont_EX;		
	ID_EX_Reg_cont_WB_tb <= ID_EX_Reg_cont_WB;	
	
	EX_stage_rd_tb <= EX_stage_rd_tb;
	EX_stage_rd_address_tb <= EX_stage_rd_address; 
	
	EX_WB_Reg_instr_tb <= EX_WB_Reg_instr;
	EX_WB_Reg_cont_WB_tb <= EX_WB_Reg_cont_WB;
	
end pipelined_multimedia_unit_arch;