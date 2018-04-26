
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity RegFile is
  port (
    ReadAddr1   : in  std_logic_vector(3 downto 0)  := "0000";
    ReadAddr2   : in  std_logic_vector(3 downto 0)  := "0000";
    WriteAddr   : in  std_logic_vector(3 downto 0)  := "0000";
    Data        : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    clock       : in  std_logic                     := '0';
    reset       : in  std_logic                     := '0';
    WriteEnable : in  std_logic                     := '0';
    ReadOut1    : out std_logic_vector(31 downto 0);
    ReadOut2    : out std_logic_vector(31 downto 0);
    PC          : out std_logic_vector(31 downto 0));
end RegFile;

architecture struc of RegFile is

  type filereg is array (0 to 15) of std_logic_vector(31 downto 0);
  signal registerFile : filereg := ("00000000000000000000000000000001",--0
                                    "00000000000000000000000000000010",--1
                                    "00000000000000000000000000000011",--2
                                    "00000000000000000000000000000000",--3
                                    "11111111111111111111111111111100",--4 location
                                    "00000000000000000000000000100000",--5 read data
                                    "00000000000000000000000000000000",--6 
                                    "00000000000000000000000010000111",--7 thousands
                                    "00000000000000000000000100001000",--8 hundreds
                                    "00000000000000000000001000001001",--9 tens
                                    "00000000000000000000001111101000",--10 thousand _value 
                                    "00000000000000000000000000000000",
                                    "00000000000000000000000000000000",
                                    "00000000000000000000000000000000",
                                    "00000000000000000000000000000000",
                                    "00000000000000000000000000000000");

  signal readAdd1, readAdd2, writeAdd : integer := 0;
-- SIGNAL Carry_out : std_logic;
-- SIGNAL C31: std_logic;

begin

-- Concurrent Address assignment;

  readAdd1 <= to_integer(unsigned(ReadAddr1));
  readAdd2 <= to_integer(unsigned(ReadAddr2));
  writeAdd <= to_integer(unsigned(WriteAddr));
  PC       <= registerFile(15);         -- Copy of PC

  ReadOut1 <= registerFile(readAdd1);   -- Reading done concurrently
  ReadOut2 <= registerFile(readAdd2);

--with reset select registerFile(16) <=  -- Initializing PC with 0 ;
--  "00000000000000000000000000000000"             when '1',
--    registerFile(15)               when others;

  process(clock)                        --- Sequential Writing
  begin
    if(rising_edge(clock)) then
      if(reset = '1') then
        registerFile(15) <= "00000000000000000000000000000000";
      elsif(WriteEnable = '1') then
        registerFile(writeAdd) <= Data;
      end if;


    end if;

  end process;
end struc;
