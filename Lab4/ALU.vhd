
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
PORT (
	Op1 : IN std_logic_vector(31 downto 0);
	Op2 : IN std_logic_vector(31 downto 0);
  opcode : IN std_logic_vector(3 downto 0);
  carry_in  : IN std_logic;
  output1 : OUT std_logic_vector(31 downto 0);
  Z : OUT std_logic;
  N : OUT std_logic;
  C : OUT std_logic;
  V : OUT std_logic);
end ALU;

architecture struc of ALU is

SIGNAL S : std_logic_vector (31 downto 0) ;
SIGNAL Carry_out : std_logic;
SIGNAL C31: std_logic;

BEGIN

with opcode select S <=
    Op1 AND Op2               when "0000",
    Op1 XOR Op2               when "0001",
    Op1 + NOT Op2 + 1         when "0010",
    NOT Op1 + Op2 + 1         when "0011",
    Op1 + Op2                 when "0100",
    Op1 + Op2 + carry_in            when "0101",
    Op1 + NOT Op2 + carry_in         when "0110",
    NOT Op1 + Op2 + carry_in         when "0111",
    Op1 AND Op2               when "1000",
    Op1 XOR Op2               when "1001",
    Op1 + NOT Op2 +1          when "1010",
    Op1 + Op2                 when "1011",
    Op1 OR Op2                when "1100",
    Op2                       when "1101",
    Op1 AND NOT Op2           when "1110",
    NOT Op2                   when others;


output1 <= S;

C31 <=  Op1(31) XOR Op2(31) XOR S(31);

Carry_out <=  (Op1(31) AND Op2(31)) OR (Op1(31) AND C31) OR (Op1(31) AND C31);
C <= Carry_out;

N <= S(31);

Z <= '1' when S = "00000000000000000000000000000000" else '0';

V <= Carry_out XOR C31;

end struc;
