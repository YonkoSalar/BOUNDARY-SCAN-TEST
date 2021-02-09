library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity ir_register is
    Port (
    clk, rst, tdi : in std_logic;
    pin : in std_logic_vector(3 downto 0);
    pout : out std_logic_vector(3 downto 0);
    tdo : out std_logic;
    mic : in std_logic;
    mcsc, mlc : in std_logic
    );
end ir_register;

architecture Behavioral of ir_register is

signal cell_0_out, cell_1_out, cell_2_out: std_logic;

begin

bit0: entity work.ir_cell
port map(sin => tdi, sout => cell_0_out, pin => pin(0), pout => pout(0), clk => clk, rst => rst, mic => mic, mcsc => mcsc, mlc => mlc);

bit1: entity work.ir_cell
port map(sin => cell_0_out, sout => cell_1_out, pin => pin(1), pout => pout(1), clk => clk, rst => rst, mic => mic, mcsc => mcsc, mlc => mlc);

bit2: entity work.ir_cell
port map(sin => cell_1_out, sout => cell_2_out, pin => pin(2), pout => pout(2), clk => clk, rst => rst, mic => mic, mcsc => mcsc, mlc => mlc);

bit3: entity work.ir_cell
port map(sin => cell_2_out, sout => tdo, pin => pin(3), pout => pout(3), clk => clk, rst => rst, mic => mic, mcsc => mcsc, mlc => mlc);

end Behavioral;
