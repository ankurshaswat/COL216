library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reverse_2 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity reverse_2;

architecture arch_1 of reverse_2 is


begin

with slct select oup(31 downto 28) <=
	inp(29 downto 28)&inp(31 downto 30) when '1',
	inp(31 downto 28) when '0';
with slct select oup(27 downto 24) <=
	inp(25 downto 24)&inp(27 downto 26) when '1',
	inp(27 downto 24) when '0';

with slct select oup(23 downto 20) <=
	inp(21 downto 20)&inp(23 downto 22) when '1',
	inp(23 downto 20) when '0';
with slct select oup(19 downto 16) <=
	inp(17 downto 16)&inp(19 downto 18) when '1',
	inp(19 downto 16) when '0';

with slct select oup(15 downto 12) <=
	inp(13 downto 12)&inp(15 downto 14) when '1',
	inp(15 downto 12) when '0';
with slct select oup(11 downto 8) <=
	inp(9 downto 8)&inp(11 downto 10) when '1',
	inp(11 downto 8) when '0';

with slct select oup(7 downto 4) <=
	inp(5 downto 4)&inp(7 downto 6) when '1',
	inp(7 downto 4) when '0';
with slct select oup(3 downto 0) <=
	inp(1 downto 0)&inp(3 downto 2) when '1',
	inp(3 downto 0) when '0';

	
end architecture arch_1;

