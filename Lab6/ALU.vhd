
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ALU is
  port (
    Op1      : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    Op2      : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    opcode   : in  std_logic_vector(3 downto 0)  := "0000";
    carry_in : in  std_logic                     := '0';
    output1  : out std_logic_vector(31 downto 0):="00000000000000000000000000000000";
    Z        : out std_logic                     := '0';
    N        : out std_logic                     := '0';
    C        : out std_logic                     := '0';
    V        : out std_logic                     := '0');
end ALU;

architecture struc of ALU is

  signal S         : std_logic_vector (31 downto 0);
  signal Carry_out : std_logic;
  signal C31       : std_logic;

begin

  with opcode select S <=
    Op1 and Op2              when "0000",
    Op1 xor Op2              when "0001",
    Op1 + not Op2 + 1        when "0010",
    not Op1 + Op2 + 1        when "0011",
    Op1 + Op2                when "0100",
    Op1 + Op2 + carry_in     when "0101",
    Op1 + not Op2 + carry_in when "0110",
    not Op1 + Op2 + carry_in when "0111",
    Op1 and Op2              when "1000",
    Op1 xor Op2              when "1001",
    Op1 + not Op2 +1         when "1010",
    Op1 + Op2                when "1011",
    Op1 or Op2               when "1100",
    Op2                      when "1101",
    Op1 and not Op2          when "1110",
    not Op2                  when others;


  output1 <= S;

  C31 <= Op1(31) xor Op2(31) xor S(31);

  Carry_out <= (Op1(31) and Op2(31)) or (Op1(31) and C31) or (Op1(31) and C31);
  C         <= Carry_out;

  N <= S(31);

  Z <= '1' when S = "00000000000000000000000000000000" else '0';

  V <= Carry_out xor C31;

end struc;
