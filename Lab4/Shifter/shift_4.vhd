
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_4 is
port (
	inp:in std_logic_vector(31 downto 0);
		t_i: in std_logic;
	c_out : out std_logic;
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity shift_4;

architecture arch_1 of shift_4 is

signal t_i : std_logic_vector(3 downto 0);
begin

with slct select oup <=
	t_i & inp(31 downto 4) when '1',
	inp(31 downto 0) when '0';

with shift_type select t_i
	"0000" when "00";
	"0000" when "01";
	inp(31)&inp(31)&inp(31)&inp(31) when "10";
	inp (3)&inp(2)&inp (1)&inp(0) when "11";

c_out<=inp(3);

end architecture arch_1;
