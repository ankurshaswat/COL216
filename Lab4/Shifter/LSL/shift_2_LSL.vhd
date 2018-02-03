
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_2_LSL is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity shift_2_LSL;

architecture arch_1 of shift_2_LSL is


begin

with slct select oup <=
	inp(31 downto 2)&"00" when '1',
	inp(31 downto 0) when '0';

end architecture arch_1;
