library IEEE;
use IEEE.std_logic_1164.all;

entity shift is
  port ( 
    inp : in std_logic_vector(31 downto 0);
    shift_type : in std_logic_vector(1 downto 0);
    shift_amount : in std_logic_vector(4 downto 0);
    carry : out std_logic;
    out1  : out std_logic_vector(31 downto 0));
end entity shift;

architecture arch of shift is



component shift_16 is
port (
  inp:in std_logic_vector(31 downto 0);
    shift_type:in std_logic_vector(1 downto 0);

  c_out: out std_logic;
  slct:in std_logic;
  oup: out std_logic_vector(31 downto 0));
end component;

component shift_8 is
port (
  inp:in std_logic_vector(31 downto 0);
    shift_type:in std_logic_vector(1 downto 0);

  c_out: out std_logic;
  slct:in std_logic;
  oup: out std_logic_vector(31 downto 0));
end component;

component shift_4 is
port (
  inp:in std_logic_vector(31 downto 0);
    shift_type:in std_logic_vector(1 downto 0);

  c_out: out std_logic;
  slct:in std_logic;
  oup: out std_logic_vector(31 downto 0));
end component;

component shift_2 is
port (
  inp:in std_logic_vector(31 downto 0);
    shift_type:in std_logic_vector(1 downto 0);

  c_out: out std_logic;
  slct:in std_logic;
  oup: out std_logic_vector(31 downto 0));
end component;

component shift_1 is
port (
  inp:in std_logic_vector(31 downto 0);
    shift_type:in std_logic_vector(1 downto 0);

  c_out: out std_logic;
  slct:in std_logic;
  oup: out std_logic_vector(31 downto 0));
end component;
signal carry_16 :  std_logic;
signal carry_8 :  std_logic;
signal carry_4 :  std_logic;
signal carry_2 :  std_logic;
signal carry_1 :  std_logic;
signal out_1:std_logic_vector(31 downto 0);
signal out_2:std_logic_vector(31 downto 0);
signal out_4:std_logic_vector(31 downto 0);
signal out_8:std_logic_vector(31 downto 0);




begin

s_1: shift_1
  port map(
  inp        => inp,
  shift_type => shift_type,
  c_out      =>carry_1,
  slct       =>shift_amount(0),
  oup        =>out_1); 

s_2: shift_2
  port map(
  inp        => out_1,
  shift_type => shift_type,
  c_out      =>carry_2,
  slct       =>shift_amount(1),
  oup        =>out_2); 

s_4: shift_4
  port map(
  inp        => out_2,
  shift_type => shift_type,
  c_out      =>carry_4,
  slct       =>shift_amount(2),
  oup        =>out_4); 

s_8: shift_8
  port map(
  inp        => out_4,
  shift_type => shift_type,
  c_out      =>carry_8,
  slct       =>shift_amount(3),
  oup        =>out_8); 

s_16: shift_16
  port map(
  inp        => out_8,
  shift_type => shift_type,
  c_out      =>carry_16,
  slct       =>shift_amount(4),
  oup        =>out1);


carry <=  carry_16 when shift_amount(4) = '1' else
          carry_8   when shift_amount(3) = '1' else
          carry_4   when shift_amount(2) = '1' else
          carry_2   when shift_amount(1) = '1' else
          carry_1   when shift_amount(0) = '1' ; 
end architecture arch;