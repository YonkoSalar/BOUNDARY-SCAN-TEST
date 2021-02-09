library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bp_cell is
port( rst, clk : in std_logic;
      sin, pin: in std_logic;
      sout : out std_logic;
      mic : in std_logic;
      mcsc : in std_logic
);
end bp_cell;

architecture Behavioral of bp_cell is
signal mio : std_logic;
signal cs_nxt, cs_reg : std_logic;
signal l_nxt, l_reg : std_logic;

begin

--Capture/Shift stage--
mux_in : entity work.mux
port map(in0 => pin, in1 => sin, sel => mic, dout => mio);

mux_cs : entity work.mux
port map(in0 => cs_reg, in1 => mio, sel => mcsc, dout => cs_nxt);

flip_flop: entity work.d_ff
port map(clk => clk, D => cs_nxt, Q => cs_reg, rst => rst);

sout <= cs_reg;

end Behavioral;
