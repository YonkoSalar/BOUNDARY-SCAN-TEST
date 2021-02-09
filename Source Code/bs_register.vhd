library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bs_register is
    Port (
    clk, rst, tdi : in std_logic;
    pin: in std_logic_vector(4 downto 0);
    pout : out std_logic_vector(4 downto 0);
    mic, moc: in std_logic;
    mcsc, mlc : in std_logic;
    sout : out std_logic
    );
end bs_register;

architecture Behavioral of bs_register is

signal cell_0_out, cell_1_out, cell_2_out, cell_3_out: std_logic;

begin

cell0: entity work.bs_cell
port map(clk => clk, rst => rst, sin => tdi, pin => pin(0), sout => cell_0_out, 
    pout => pout(0), mic => mic, moc => moc, mcsc => mcsc, mlc => mlc);

cell1: entity work.bs_cell
port map(clk => clk, rst => rst, sin => cell_0_out, pin => pin(1), sout => cell_1_out, 
    pout => pout(1), mic => mic, moc => moc, mcsc => mcsc, mlc => mlc);
    
cell2: entity work.bs_cell
port map(clk => clk, rst => rst, sin => cell_1_out, pin => pin(2), sout => cell_2_out, 
    pout => pout(2), mic => mic, moc => moc, mcsc => mcsc, mlc => mlc);
    
cell3: entity work.bs_cell
port map(clk => clk, rst => rst, sin => cell_2_out, pin => pin(3), sout => cell_3_out, 
    pout => pout(3), mic => mic, moc => moc, mcsc => mcsc, mlc => mlc);
    
cell4: entity work.bs_cell
port map(clk => clk, rst => rst, sin => cell_3_out, pin => pin(4), sout => sout, 
    pout => pout(4), mic => mic, moc => moc, mcsc => mcsc, mlc => mlc);

end Behavioral;
