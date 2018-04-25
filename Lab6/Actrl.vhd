library IEEE;
use IEEE.std_logic_1164.all;


entity Actrl is
  port (
    ins        : in  std_logic_vector(27 downto 0) := "0000000000000000000000000000";
    class      : in  std_logic_vector(1 downto 0) := "00";
    sub_class  : in  std_logic_vector(3 downto 0) := "0000";
    variant    : in  std_logic_vector(1 downto 0)  := "00";
    ins_status : in  std_logic_vector(1 downto 0) := "00";
    op         : out std_logic_vector(3 downto 0):= "0000");
end entity Actrl;

architecture arch of Actrl is

begin

  -- i1 : instructionDecoder port map(ins => ins, class => class, sub_class => sub_class, ins_status => ins_status);
  -- ins <= "0000" & ins_27_0;

  op <= "0100" when (class = "01" and ins(23) = '1') or (class = "11") or (class = "10" and sub_class = "0001") else
        "0010" when (class = "01" and ins(23) = '0') else
        "1101" when (class = "10" and sub_class = "0000") else
        ins(24 downto 21);

end architecture;
