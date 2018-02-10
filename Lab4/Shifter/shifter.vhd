library IEEE;
use IEEE.std_logic_1164.all;

entity shifter is
  port ( 
    inp : in std_logic_vector(31 downto 0);
    shift_type : in std_logic_vector(1 downto 0);
    shift_amount : in std_logic_vector(4 downto 0);
    carry : in std_logic;
    out1  : out std_logic_vector(31 downto 0));
end entity shifter;

architecture arch of shifter is

signal to_reverse: in std_logic;
signal t_shift: in std_logic;
begin 

--with 

end architecture arch;