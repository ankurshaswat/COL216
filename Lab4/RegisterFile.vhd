
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity RegFile is
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
end RegFile;

architecture struc of RegFile is

TYPE filereg is array (0 to 15) of std_logic_vector(31 downto 0);
SIGNAL registerFile : filereg;

 SIGNAL readAdd1,readAdd2,writeAdd : integer ;
-- SIGNAL Carry_out : std_logic;
-- SIGNAL C31: std_logic;

BEGIN

readAdd1 <= to_integer(unsigned(ReadAddr1));
readAdd2 <= to_integer(unsigned(ReadAddr2));
writeAdd <= to_integer(unsigned(WriteAddr));
PC <= registerFile(15);

ReadOut1 <= registerFile(readAdd1);
ReadOut2 <= registerFile(readAdd2);

with reset select registerFile(15) <=
  "00000000000000000000000000000000"             when '1',
    registerFile(15)               when '0';

process(clock)
begin
	if(rising_edge(clock)) then
		if(WriteEnable='1') then
			registerFile(writeAdd)<=Data;
	end if;


end if;

end process;
end struc;
