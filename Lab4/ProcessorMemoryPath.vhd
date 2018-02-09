
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity ProcessorMemoryPath is
PORT (
	FromProcessor : IN std_logic_vector(31 downto 0);
	FromMemory : IN std_logic_vector(31 downto 0);
	DTType : IN std_logic_vector(31 downto 0);
	ByteOffset : IN std_logic_vector(31 downto 0);
	ToProcessor : OUT std_logic_vector(31 downto 0);
	ToMemory : OUT std_logic_vector(31 downto 0);
	WriteEnable : OUT std_logic);
end ProcessorMemoryPath;

architecture struc of ProcessorMemoryPath is
BEGIN



end struc;
