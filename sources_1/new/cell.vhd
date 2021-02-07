

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cell is
port( rst : std_logic;
      P_in, S_in : in std_logic;
      S_out, P_out : out std_logic
      
);
end cell;

architecture Behavioral of cell is
signal shift, mode : std_logic; --Sel for both MUX 
signal clock_MUX, update_clk : std_logic; --Clock
signal MUX_to_FF : std_logic; -- First MUX to first FF
signal FF_to_FF : std_logic; -- FF to FF (Serial Out)
signal FF_to_MUX : std_logic; --Second FF to MUX

begin

--Capture/Shift stage--
mux_1: entity work.mux
port map(in0 => P_in, in1 => S_in, sel => shift, dout => MUX_to_FF );

FF_1: entity work.d_ff
port map(clk => clock_MUX, D => MUX_to_FF, Q => FF_to_FF, rst => rst);


--LATCH stage--
FF_2: entity work.d_ff
port map(clk => update_clk, D => FF_to_FF, Q => FF_to_MUX, rst => rst);

mux_2: entity work.mux
port map(in0 => P_in, in1 => FF_to_MUX, sel => mode, dout => P_out);


end Behavioral;
