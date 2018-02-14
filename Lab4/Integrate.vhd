
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity Integrate is
PORT (
	Op1 : IN std_logic_vector(31 downto 0);
	Op2 : IN std_logic_vector(31 downto 0);
	Result : OUT std_logic_vector(31 downto 0));
end Integrate;

architecture struc of Integrate is

component ALU is
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


component Multiplier is
PORT (
	Op1 : IN std_logic_vector(31 downto 0);
	Op2 : IN std_logic_vector(31 downto 0);
	Result : OUT std_logic_vector(31 downto 0));
end component;


component ProcessorMemoryPath is
PORT (
	FromProcessor : IN std_logic_vector(31 downto 0);
	FromMemory : IN std_logic_vector(31 downto 0);
	DTType : IN std_logic_vector(2 downto 0); -- last 2 bits tell type of tranfer 00 for word 01 for half 10 for byte 
	-- bit index 3 tells     0 for zero extension and 1 for sign extension 
	ByteOffset : IN std_logic_vector(1 downto 0);
	ToProcessor : OUT std_logic_vector(31 downto 0);
	ToMemory : OUT std_logic_vector(31 downto 0);
	WriteEnable : OUT std_logic_vector(3 downto 0));
end component;


component RegFile is
PORT (
	ReadAddr1 : IN std_logic_vector(3 downto 0);
	ReadAddr2 : IN std_logic_vector(3 downto 0);
	WriteAddr : IN std_logic_vector(3 downto 0);
	Data : IN std_logic_vector(31 downto 0);
  clock  : IN std_logic;
  reset  : IN std_logic;
  WriteEnable  : IN std_logic;
	ReadOut1 : OUT std_logic_vector(31 downto 0);
	ReadOut2 : OUT std_logic_vector(31 downto 0);
	PC : OUT std_logic_vector(31 downto 0));
end component;


BEGIN

Alu :  ALU 
PORT (
	Op1 : ,
	Op2 : ,
  opcode : ,
  carry_in  : ,
  output1 : ,
  Z : ,
  N : ,
  C : ,
  V : );


Mul : Multiplier
PORT (
	Op1 : ,
	Op2 : ,
	Result : );



ProcMem :  ProcessorMemoryPath 
PORT MAP (
	FromProcessor : ,
	FromMemory : ,
	DTType : , 
	ByteOffset : ,
	ToProcessor : ,
	ToMemory : ,
	WriteEnable : );



Reg :  RegFile 
PORT MAP(
	ReadAddr1 : ,	
	ReadAddr2 : ,
	WriteAddr : ,
	Data : ,
  c,lock  : ,
  reset  : ,
  WriteEnable  : ,
	ReadOut1 : ,
	ReadOut2 : ,
	PC : );


	
	


end struc;
