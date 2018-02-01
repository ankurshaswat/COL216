entity shift_4_LSL is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity shift_4_LSL;

architecture arch_1 of shift_4_LSL is


begin

with slct select oup <=
	inp(31 downto 4)&"0000" when '1';
	inp(31 downto 0) when '0';

end architecture arch_1;
