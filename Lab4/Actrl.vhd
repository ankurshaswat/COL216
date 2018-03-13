library IEEE;
use IEEE.std_logic_1164.all;


entity Actrl is
  port (
    ins_31_28 : in  std_logic_vector(3 downto 0);
    F         : in  std_logic_vector(3 downto 0);  -- (Flags : Z & N & V & C )
    p         : out std_logic);
end entity Actrl;

architecture arch of Actrl is

  signal Z, N, V, C : in std_logic;

begin



end architecture;
