
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_1 is
port (
	inp:in std_logic_vector(31 downto 0);
	shift_type:in std_logic_vector(1 downto 0);
	slct:in std_logic;
	c_out:out std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity shift_1;

architecture arch_1 of shift_1 is

signal t_i : in std_logic;
begin

with shift_type select t_i
	'0' when "00";
	'0' when "01";
	inp(0) when "10";
	inp (31) when "11";

with slct select oup <=
	 t_i  & inp(31 downto 1) when '1',
	inp(31 downto 0) when '0';
with slct select c_out <=
	inp(0) when '1';
	c_in when '0';


end architecture arch_1;
