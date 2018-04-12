
library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity shift_16 is
  port (
    inp        : in std_logic_vector(31 downto 0);
    shift_type : in std_logic_vector(1 downto 0);

    c_out : out std_logic;
    slct  : in  std_logic;
    oup   : out std_logic_vector(31 downto 0));
end entity shift_16;

architecture arch_1 of shift_16 is

  signal t_i : std_logic_vector(15 downto 0);
begin



  with slct select oup <=
    t_i & inp(31 downto 16) when '1',
    inp(31 downto 0)        when others;


  with shift_type select t_i <=
    "0000000000000000"                                                                                                              when "00",
    "0000000000000000"                                                                                                              when "01",
    inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31)&inp(31) when "10",
    inp (15)&inp(14)&inp (13)&inp(12)&inp (11)&inp(10)&inp (9)&inp(8)&inp (7)&inp(6)&inp (5)&inp(4)&inp (3)&inp(2)&inp (1)&inp(0)   when others;

--c_out<=inp(15);
  with slct select c_out <=
    inp(15) when '1',
--      c_in when others;
    '0'     when others;


end architecture arch_1;
