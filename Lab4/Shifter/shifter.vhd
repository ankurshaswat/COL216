library IEEE;
use IEEE.std_logic_1164.all;

entity shifter is
  port (
    inp          : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    shift_type   : in  std_logic_vector(1 downto 0)  := "00";
    shift_amount : in  std_logic_vector(4 downto 0)  := "00000";
    carry        : out std_logic;
    out1         : out std_logic_vector(31 downto 0));
end entity shifter;

architecture arch of shifter is

  signal to_reverse : std_logic;
  signal rev_out    : std_logic_vector(31 downto 0);
  signal shift_out  : std_logic_vector(31 downto 0);



  component reverse is
    port (
      inp  : in  std_logic_vector(31 downto 0);
      slct : in  std_logic;
      oup  : out std_logic_vector(31 downto 0));
  end component;


  component shift is
    port (
      inp          : in  std_logic_vector(31 downto 0);
      shift_type   : in  std_logic_vector(1 downto 0);
      shift_amount : in  std_logic_vector(4 downto 0);
      carry        : out std_logic;
      out1         : out std_logic_vector(31 downto 0));
  end component;

begin


  with shift_type select to_reverse <=
    '1' when "00",
    '0' when others;

  rev_one : reverse
    port map (
      inp  => inp,
      slct => to_reverse,
      oup  => rev_out);

  swift : shift
    port map(
      inp          => rev_out,
      shift_type   => shift_type,
      shift_amount => shift_amount,
      carry        => carry,
      out1         => shift_out);


  rev_two : reverse
    port map (
      inp  => shift_out,
      slct => to_reverse,
      oup  => out1);







end architecture arch;
