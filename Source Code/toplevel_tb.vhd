--------------------------------------------------------------------------------
-- 
-- DFDS3200 2020/21
-- CCW1: test bench spec
-- josemmf
--
-- NB: You may have to adapt the input/output names below and the module/file  
-- names according to the names that you chose to use in your Vivado project
-- 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_top_level IS
END tb_top_level;
 
ARCHITECTURE behavior OF tb_top_level IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	-- ("clk" is the name used below for "TCK")
 
    
    component toplevel is
        Port (
        clk, rst, tdi, tms : in std_logic;
        in0, in1, in2, in3 : in std_logic;
        tdo, out0 : out std_logic
        );
    end component toplevel;
    
   

   --Inputs
   signal clk, rst : std_logic := '0';
   signal tdi, tms : std_logic := '0';
   signal in0, in1, in2, in3 : std_logic := '0';


 	--Outputs
   signal tdo : std_logic := '0';
   signal out0 : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: toplevel PORT MAP (
          clk => clk,
          rst => rst,
          tdi => tdi,
          tms => tms,
          in0 => in0,
          in1 => in1,
          in2 => in2,
		  in3 => in3,
          out0 => out0,
          tdo => tdo
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
        rst <= '1';
      wait for 100 ns;	
		rst <= '0';
		in0 <= '0';
		in1 <= '1';
		in2 <= '0';
		in3 <= '0';
		tdi <= '0';
		tms <= '1';				
      wait for clk_period*5;	-- Go to TLR
		tms <= '0';				
      wait for clk_period;		-- Go to RTI
		tms <= '1';		
      wait for clk_period;		-- Go to SEL-DR
		tms <= '1';		
      wait for clk_period;		-- Go to SEL-IR
		tms <= '0';		
      wait for clk_period;		-- Go to CAPT-IR
		tms <= '0';		
      wait for clk_period;		-- Go to SHIFT-IR
		tdi <= '0';				-- To shift in the EXTEST instruction
      wait for clk_period*3;	-- Remain in SHIFT-IR for 3 TCK cycles
		tms <= '1';		
      wait for clk_period;		-- Shift last bit into IR and go to EX1-IR
		tms <= '1';		
      wait for clk_period;		-- Go to UPDT-IR
		tms <= '1';		
      wait for clk_period;		-- Go to SEL-DR
		tms <= '0';		
      wait for clk_period;		-- Go to CAPT-DR
		tms <= '0';		
      wait for clk_period;		-- Go to SHIFT-DR
		tdi <= '1';
		tms <= '0';		
      wait for clk_period*4;	-- Remain in SHIFT-DR for 4 TCK cycles
		tms <= '1';		
      wait for clk_period;		-- Shift last bit into DR (BSR) and go to EX1-DR
		tms <= '1';		
      wait for clk_period;		-- Go to UPDT-DR
		
      wait;
   end process;

END;
