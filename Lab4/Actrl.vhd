library IEEE;
use IEEE.std_logic_1164.all;


entity Actrl is
  port (
    ins : in  std_logic_vector(27 downto 0);
    op  : out std_logic_vector(3 downto 0));
end entity Actrl;

architecture arch of Actrl is


  -- signal ins : std_logic_vector(31 downto 0);

  signal ldr_str, mul, mla, b_bl : std_logic;

begin

  -- ins <= "0000" & ins_27_0;

  op <= "0100" when (ldr_str = '1' and ins(23) = '1') or (b_bl = '1') or (mla = '1') else
        "0010" when (ldr_str = '1' and ins(23) = '0') else
        "1101" when (mul = '1') else
        ins(24 downto 21);

  mul <= '1' when (ins(27 downto 25) = "000" and ins(7 downto 4) = "1001" and ins(21) = '0') else '0';
  mul <= '1' when (ins(27 downto 25) = "000" and ins(7 downto 4) = "1001" and ins(21) = '1') else '0';

  b_bl <= '1' when (ins(27 downto 25) = "101") else '0';

  ldr_str <= '1' when (ins(27 downto 26) = "01") or (ins (27 downto 25) = "000" and ins(7) = '1' and ins(4) = '1' and ins(6 downto 5) /= "00") else '0';

end architecture;
