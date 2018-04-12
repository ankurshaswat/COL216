library IEEE;
use IEEE.std_logic_1164.all;


entity Bctrl is
  port (
    ins_31_28 : in  std_logic_vector(3 downto 0);
    F         : in  std_logic_vector(3 downto 0);  -- (Flags : Z & N & V & C )
    p         : out std_logic);
end entity Bctrl;

architecture arch of Bctrl is

  signal Z, N, V, C :  std_logic;

begin

  Z <= F(3);
  N <= F(2);
  V <= F(1);
  C <= F(0);

  with ins_31_28 select p <=
    Z when "0000",
    not Z                       when "0001",
    C when "0010",
    not C                       when "0011",
    N when "0100",
    not N                       when "0101",
    V when "0110",
    not V                       when "0111",
    C and (not Z)               when "1000",
    (not C) or Z                when "1001",
    not (N xor V)               when "1010",
    (N xor V)                   when "1011",
    (not Z) and (not (N xor V)) when "1100",
    Z or (N xor V)              when "1101",
    '1'                         when others;

end architecture;
