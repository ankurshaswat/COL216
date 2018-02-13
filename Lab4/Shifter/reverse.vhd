library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reverse is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end entity reverse;

architecture arch_1 of reverse is

component reverse_1 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end component ;

component reverse_2 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end component ;

component reverse_4 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end component ;

component reverse_8 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end component;
component reverse_16 is
port (
	inp:in std_logic_vector(31 downto 0);
	slct:in std_logic;
	oup: out std_logic_vector(31 downto 0));
end component ;

signal out_1: std_logic_vector(31 downto 0);
signal out_2: std_logic_vector(31 downto 0);
signal out_4: std_logic_vector(31 downto 0);
signal out_8: std_logic_vector(31 downto 0);


begin

rev_1: reverse_1
port map(inp=>inp,slct=>slct,oup=>out_1);

rev_2: reverse_2
port map(inp=>out_1,slct=>slct,oup=>out_2);

rev_4:  reverse_4
port map(inp=>out_2,slct=>slct,oup=>out_4);

rev_8: reverse_8
port map(inp=>out_4,slct=>slct,oup=>out_8);

rev_16: reverse_16
port map(inp=>out_8,slct=>slct,oup=>oup);



end architecture arch_1;
