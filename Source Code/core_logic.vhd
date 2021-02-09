library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity core_logic is
    Port (
    in0, in1, in2, in3 : in std_logic;
    out0 : out std_logic
    );
end core_logic;

architecture Behavioral of core_logic is

begin

out0 <= in0 and in1 and in2 and in3;

end Behavioral;
