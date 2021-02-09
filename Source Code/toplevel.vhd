library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity toplevel is
  Port (
  clk, rst, tdi, tms : in std_logic;
  in0, in1, in2, in3 : in std_logic;
  tdo, out0 : out std_logic
  );
end toplevel;

architecture Behavioral of toplevel is

-- BS REGISTER --
signal bs_pin : std_logic_vector(4 downto 0);
signal bs_pout : std_logic_vector(4 downto 0);
signal bs_mic, bs_moc, bs_mcsc, bs_mlc, BS_REGISTER_OUT : std_logic;
-----------------

-- IR REGISTER --
signal ir_pin : std_logic_vector(3 downto 0);
signal ir_pout : std_logic_vector(3 downto 0);
signal ir_mic, ir_moc, ir_mcsc, ir_mlc, IR_REGISTER_OUT : std_logic;
-----------------

-- BP UNIT --
signal bp_out, bp_pin, bp_mic, bp_mcsc : std_logic;
-------------

-- TAP CONTROLLER --
signal cpdr_now, shdr_now, updr_now, cpir_now, shir_now, upir_now : std_logic;
--------------------

-- IR DECODER --
signal EXTEST, SAMPLE_AND_PRELOAD, BYPASS : std_logic;

-- OTHER --
signal data_mux_control, data_mux_out, data_instruction_mux_control: std_logic;
-----------

begin

-- BS REGISTER
bs_pin(0) <= in0;
bs_pin(1) <= in1;
bs_pin(2) <= in2;
bs_pin(3) <= in3;

BS_REGISTER: entity work.bs_register
port map(clk => clk, rst => rst, tdi => tdi, pin => bs_pin, pout => bs_pout, mic => bs_mic, 
    moc => bs_moc, mcsc => bs_mcsc, mlc => bs_mlc, sout => BS_REGISTER_OUT);
    
out0 <= bs_pout(4);

-- IR REGISTER
IR_REGISTER: entity work.ir_register
port map(clk => clk, rst => rst, tdi => tdi, pin => ir_pin, pout => ir_pout, mic => ir_mic, 
    mcsc => ir_mcsc, mlc => ir_mlc, tdo => IR_REGISTER_OUT);

-- BP UNIT
BP_UNIT: entity work.bp_cell
port map(clk => clk, rst => rst, sin => tdi, sout => bp_out, 
    pin => '0', mic => bp_mic, mcsc => bp_mcsc);

-- TAP CONTROLLER
TAP_CONTROLLER: entity work.tap
port map(clk => clk, rst => rst, tms => tms, cpdr_now => cpdr_now, shdr_now => shdr_now,
    updr_now => updr_now, cpir_now => cpir_now, shir_now => shir_now, upir_now => upir_now);
    
-- CORE LOGIC
CORE_LOGIC: entity work.core_logic
port map(in0 => bs_pout(0), in1 => bs_pout(1), in2 => bs_pout(2), in3 => bs_pout(3),
    out0 => bs_pin(4));


-- IR DECODER
-- csff_en = mcsc
-- cs_mux_ctr = mic
-- lff_en = mlc
-- l_mux_ctr = moc

bs_mcsc <= '1' when (EXTEST = '1' or SAMPLE_AND_PRELOAD = '1') 
    and (cpdr_now = '1' or shdr_now = '1') else '0';
bs_mlc <= '1' when (EXTEST = '1' or SAMPLE_AND_PRELOAD = '1') and updr_now = '1' else '0';
bs_mic <= '1' when shdr_now = '1' else '0';
bs_moc <= '1' when EXTEST = '1' else '0';

bp_mic <= '1' when shdr_now = '1' else '0';
bp_mcsc <= '1' when BYPASS = '1' and (cpdr_now = '1' or shdr_now = '1') else '0';

ir_mcsc <= '1' when cpir_now = '1' or shir_now = '1' else '0';
ir_mlc <= '1' when upir_now = '1' else '0';
ir_mic <= '1' when shir_now = '1' else '0';

-- BS INSTRUCTIONS
EXTEST <= '1' when ir_pout = "0000" else '0';
SAMPLE_AND_PRELOAD <= '1' when ir_pout = "1001" else '0';
BYPASS <= '1' when ir_pout = "1111" else '0';


-- DATA MUX
data_mux_control <= '1' when BYPASS = '1' else '0';
data_mux_out <= BS_REGISTER_OUT when data_mux_control = '0' else bp_out;


-- DATA INSTRUCTION MUX
data_instruction_mux_control <= '1' when shir_now = '1' else '0';
tdo <= data_mux_out when data_instruction_mux_control = '1' else IR_REGISTER_OUT;


end Behavioral;
 