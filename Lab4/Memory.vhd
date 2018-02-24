
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity Memory is
 
PORT( Address:IN std_logic_vector(31 downto 0);
 writeData:IN std_logic_vector(31 downto 0);
 clock : IN std_logic;
 MR:IN std_logic;
 MW:IN std_logic;
    outer:OUT std_logic_vector(31 downto 0));

end entity Memory;

architecture arch of Memory is

TYPE filereg is array (0 to 1000) of std_logic_vector(31 downto 0);
SIGNAL registerFile : filereg;
signal outerTemp:std_logic_vector(31 downto 0);
 SIGNAL Address_INFO : integer ;




begin

-- Concurrent Address assignment;

outer<= outerTemp;

Address_INFO <= to_integer(unsigned(Address));
with MR select outerTemp<=
	registerFile(Address_INFO) when '1',
	outerTemp when '0';


process(clock)						--- Sequential Writing
begin
	if(rising_edge(clock)) then
		if(MW='1') then
			registerFile(Address_INFO)<=writeData;
		end if;

	end if;
end process;


end architecture arch;