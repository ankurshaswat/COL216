library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reverse_1 is
  port (
    inp  : in  std_logic_vector(31 downto 0);
    slct : in  std_logic;
    oup  : out std_logic_vector(31 downto 0));
end entity reverse_1;

architecture arch_1 of reverse_1 is
  signal mask         : std_logic_vector (31 downto 0) := "01010101010101010101010101010101";
  signal right        : std_logic_vector(31 downto 0);
  signal left         : std_logic_vector(31 downto 0);
  signal right_update : std_logic_vector(31 downto 0);
  signal left_update  : std_logic_vector(31 downto 0);
  signal out_temp     : std_logic_vector(31 downto 0);

begin

  left <= "0" & inp(31 downto 1);

  GEN : for i in 0 to 31 generate
    right(i)       <= inp(i) and mask(i);
    left_update(i) <= left(i) and mask(i);
  end generate GEN;


  right_update <= right(30 downto 0)& "0";

  GEN2 : for i in 0 to 31 generate
    out_temp(i) <= left_update(i) or right_update(i);
  end generate GEN2;

  with slct select oup <=
    out_temp when '1',
    inp      when others;

end architecture arch_1;
