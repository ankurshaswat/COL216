
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity Multiplier is
  port (
    Op1    : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    Op2    : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    Result : out std_logic_vector(31 downto 0));
end Multiplier;

architecture struc of Multiplier is
begin

  Result <= std_logic_vector(to_unsigned(to_integer(signed(Op1)) * to_integer(signed(Op2)), 32));
-- Result <= Op1 * Op2;

end struc;
