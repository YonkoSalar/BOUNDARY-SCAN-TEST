library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bs_cell is
port( rst, clk : in std_logic;
      sin, pin: in std_logic;
      sout, pout : out std_logic;
      mic, moc : in std_logic;
      mcsc, mlc : in std_logic
);
end bs_cell;

architecture Behavioral of bs_cell is
signal mio : std_logic;
signal cs_nxt, cs_reg : std_logic;
signal l_nxt, l_reg : std_logic;

signal inv_clk : std_logic;

begin

--Capture/Shift stage--
mux_in : entity work.mux
port map(in0 => pin, in1 => sin, sel => mic, dout => mio);

mux_cs : entity work.mux
port map(in0 => cs_reg, in1 => mio, sel => mcsc, dout => cs_nxt);

flip_flop: entity work.d_ff
port map(clk => clk, D => cs_nxt, Q => cs_reg, rst => rst);

sout <= cs_reg;

--LATCH stage--


mux_l: entity work.mux
port map(in0 => l_reg, in1 => cs_reg, sel => mlc, dout => l_nxt);

inv_clk <= not clk;

latch: entity work.d_ff
port map(clk => inv_clk, D => l_nxt, Q => l_reg, rst => rst);

mux_out: entity work.mux
port map(in0 => pin, in1 => l_reg, sel => moc, dout => pout);

end Behavioral;
