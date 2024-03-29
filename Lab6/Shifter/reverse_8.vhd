library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reverse_8 is
  port (
    inp  : in  std_logic_vector(31 downto 0);
    slct : in  std_logic;
    oup  : out std_logic_vector(31 downto 0));
end entity reverse_8;

architecture arch_1 of reverse_8 is


begin

  with slct select oup(15 downto 0) <=
    inp(7 downto 0)&inp(15 downto 8) when '1',
    inp(15 downto 0)                 when others;

  with slct select oup(31 downto 16) <=
    inp(23 downto 16)&inp(31 downto 24) when '1',
    inp(31 downto 16)                   when others;

end architecture arch_1;
