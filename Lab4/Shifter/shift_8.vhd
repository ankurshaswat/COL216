
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity shift_8 is
  port (
    inp        : in std_logic_vector(31 downto 0);
    shift_type : in std_logic_vector(1 downto 0);

    c_out : out std_logic;
    slct  : in  std_logic;
    oup   : out std_logic_vector(31 downto 0));
end entity shift_8;

architecture arch_1 of shift_8 is
  signal t_i : std_logic_vector(7 downto 0);

begin

  with slct select oup <=
    t_i & inp(31 downto 8) when '1',
    inp(31 downto 0)       when others;


  with shift_type select t_i <=
    "00000000"                                                      when "00",
    "00000000"                                                      when "01",
    inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31) when "10",
    inp (7)&inp(6)&inp (5)&inp(4)&inp (3)&inp(2)&inp (1)&inp(0)     when others;

--c_out<=inp(7);
  with slct select c_out <=
    inp(7) when '1',
--      c_in when others;
    '0'    when others;

end architecture arch_1;
