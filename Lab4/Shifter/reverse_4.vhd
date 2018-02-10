library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reverse_4 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity reverse_4;

architecture arch_1 of reverse_4 is


begin

with slct select oup(31 downto 24) <=
	inp(27 downto 24)&inp(31 downto 28)    when '1';
	inp(31 downto 24) when '0';

with slct select oup(23 downto 16) <=
	inp(19 downto 16)&inp(23 downto 20)   when '1';
	inp(23 downto 16) when '0';

with slct select oup(15 downto 8) <=
	inp(11 downto 8)&inp(15 downto 12)  when '1';
	inp(15 downto 8) when '0';

with slct select oup(7 downto 0) <=
	inp(3  downto 0)&inp(7 downto 4)  when '1';
	inp(7 downto 0) when '0';
end architecture arch_1;
