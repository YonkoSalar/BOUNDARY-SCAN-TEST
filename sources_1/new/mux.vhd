

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux is
port(in0 : in std_logic;
    in1 : in std_logic;
    sel : in std_logic;
    dout : out std_logic

);
end mux;

architecture Behavioral of mux is

begin

dout <= in0 when sel='0' else
        in1 when sel='1';


end Behavioral;
