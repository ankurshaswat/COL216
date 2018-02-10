library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reverse_16 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity reverse_16;

architecture arch_1 of reverse_16 is


begin

with slct select oup <=
	inp(15 downto 0)&inp(31 downto 16) when '1';
	inp(31 downto 0) when '0';
end architecture arch_1;
