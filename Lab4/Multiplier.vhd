
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity Multiplier is
PORT (
	Op1 : IN std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	Op2 : IN std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	Result : OUT std_logic_vector(31 downto 0));
end Multiplier;

architecture struc of Multiplier is
BEGIN

Result <= std_logic_vector(to_unsigned(to_integer(signed(Op1)) * to_integer(signed(Op2)),32));
-- Result <= Op1 * Op2;

end struc;
