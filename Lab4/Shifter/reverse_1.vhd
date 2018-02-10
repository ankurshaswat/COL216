library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reverse_1 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity reverse_1;

architecture arch_1 of reverse_1 is
signal mask : std_logic_vector (31 downto 0):= "01010101010101010101010101010101";
signal right: std_logic_vector(31  downto 0);
signal left: std_logic_vector(31  downto 0);
signal right_update: std_logic_vector(31  downto 0);
signal left_update: std_logic_vector(31  downto 0);

begin 

left <= "0" & inp(31 downto 1) ; 
for i in 0 to 31 generate
  right(i) <= inp(i)&mask(i);
  left_update <= left(i) & mask(i);
end generate;
right_update <= right(31 downto 1 )& "0";
for i in 0 to 31 generate
   out(i) <= right_update(i)|| left_update(i);
end generate;


end architecture arch_1;
