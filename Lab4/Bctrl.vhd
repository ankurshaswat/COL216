library IEEE;
use IEEE.std_logic_1164.all;


entity Bctrl is
  port ( 
    ins_31_28 : in std_logic_vector(3 downto 0);
    F: in std_logic_vector(3 downto 0);-- (Flags : Z & N & V & C )
    p : out std_logic);
end entity Bctrl;

architecture arch of Bctrl is

signal Z,N,V,C : in std_logic;

begin

Z <= ins_31_28(3);
N <= ins_31_28(2);
V <= ins_31_28(1);
C <= ins_31_28(0);

with ins_31_28 select p <=
	Z when "0000",
	NOT Z when "0001",
	C when "0010",
	NOT C when "0011",
	N when "0100",
	NOT N when "0101",
	V when "0110",
	NOT V when "0111",
	C AND (NOT Z) when "1000",
	(NOT C) OR Z when "1001",
	NOT (N XOR V) when "1010",
	(N XOR V) when "1011",
	(NOT Z) AND (NOT (N XOR V)) when "1100",
	Z OR (N XOR V) when "1101",
	'1' when others;
	
end architecture;