library IEEE;
use IEEE.std_logic_1164.all;

entity Memory is
 
PORT( Address:IN std_logic_vector(31 downto 0);
 writeData:IN std_logic_vector(31 downto 0);
 MR:IN std_logic;
 MW:IN std_logic;
    outer:OUT std_logic_vector(31 downto 0));

end entity Memory;

architecture arch of Memory is
begin

end architecture arch;