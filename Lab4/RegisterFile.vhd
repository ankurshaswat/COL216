
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
SIGNAL registerFile : filereg:=("00000000000000000000000010000000",
"00000000000000000000000000000001",
"00000000000000000000000000000010",
"00000000000000000000000000000011",
"00000000000000000000000000000100",
"00000000000000000000000000000101",
"00000000000000000000000000000110",
"00000000000000000000000000000111",
"00000000000000000000000000001000",
"00000000000000000000000000001001",
"00000000000000000000000000000000",
"00000000000000000000000000000000",
"00000000000000000000000000000000",
"00000000000000000000000000000000",
"00000000000000000000000000000000",
"00000000000000000000000000000000");

 SIGNAL readAdd1,readAdd2,writeAdd : integer ;
-- SIGNAL Carry_out : std_logic;
-- SIGNAL C31: std_logic;

BEGIN

-- Concurrent Address assignment;

readAdd1 <= to_integer(unsigned(ReadAddr1));
readAdd2 <= to_integer(unsigned(ReadAddr2));
writeAdd <= to_integer(unsigned(WriteAddr));
PC <= registerFile(15);     -- Copy of PC

ReadOut1 <= registerFile(readAdd1);   -- Reading done concurrently
ReadOut2 <= registerFile(readAdd2);

with reset select registerFile(15) <=  -- Initializing PC with 0 ;
  "00000000000000000000000000000000"             when '1',
    registerFile(15)               when others;

process(clock)						--- Sequential Writing
begin
	if(rising_edge(clock)) then
		if(WriteEnable='1') then
			registerFile(writeAdd)<=Data;
	end if;


end if;

end process;
end struc;
