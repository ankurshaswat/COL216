
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity Testbench is
PORT (
	instruction : IN std_logic_vector(31 downto 0);
	 : IN std_logic_vector(31 downto 0);
	Result : OUT std_logic_vector(31 downto 0));
end Testbench;

architecture struc of Testbench is

component ALU 
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
end component;

constant clk_period : time := 10 ns;
signal err_cnt_signal : integer := 1;

BEGIN


uut: ALU 
PORT (
	Op1 =>Op1 ,
	Op2 => Op2 ,
  opcode => opcode  ,
  carry_in => carry_in ,
  output1 => output1,
  Z => Z,
  N =>N ,
  C => C ,
  V => V );


-- Clock Process Definitions;;;
clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;



Op1 => ,
Op2 => ,
opcode => ,
carry_in  => ,

assert (output1 = *32 bit expected output* report "Error: Output1 is wrong";


end struc;
