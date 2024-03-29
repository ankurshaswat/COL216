
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity ProcessorMemoryPath is
  port (
    FromProcessor : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    FromMemory    : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    DTType        : in  std_logic_vector(2 downto 0)  := "000";  -- last 2 bits tell type of tranfer 00 for word 01 for half 10 for byte
    -- bit index 3 tells     0 for zero extension and 1 for sign extension
    ByteOffset    : in  std_logic_vector(1 downto 0)  := "00";
    ToProcessor   : out std_logic_vector(31 downto 0);
    ToMemory      : out std_logic_vector(31 downto 0);
    WriteEnable   : out std_logic_vector(3 downto 0));
end ProcessorMemoryPath;

architecture struc of ProcessorMemoryPath is

--TYPE arr is array (0 to 15) of std_logic_vector(31 downto 0);
--SIGNAL memory : arr;

  signal half_word_duplicated : std_logic_vector(31 downto 0);
  signal byte_quadruplicate   : std_logic_vector(31 downto 0);

  signal half_word_sign_extended : std_logic_vector(31 downto 0);
  signal half_word_zero_extended : std_logic_vector(31 downto 0);
  signal byte_sign_extended      : std_logic_vector(31 downto 0);
  signal byte_zero_extended      : std_logic_vector(31 downto 0);
  signal selected_byte           : std_logic_vector(7 downto 0);
  signal selected_half_word      : std_logic_vector(15 downto 0);

  signal half_word_extended : std_logic_vector(31 downto 0);
  signal byte_extended      : std_logic_vector(31 downto 0);

  signal write_offset_half_word : std_logic_vector(3 downto 0);
  signal write_offset_byte      : std_logic_vector(3 downto 0);

begin

  with ByteOffset select selected_byte <=
    FromMemory(7 downto 0)   when "00",
    FromMemory(15 downto 8)  when "01",
    FromMemory(23 downto 16) when "10",
    FromMemory(31 downto 24) when others;

  with ByteOffset select write_offset_byte <=
    "0001" when "00",
    "0010" when "01",
    "0100" when "10",
    "1000" when others;


  with ByteOffset(1) select selected_half_word <=
    FromMemory(15 downto 0)  when '0',
    FromMemory(31 downto 16) when others;



  with ByteOffset(1) select write_offset_half_word <=
    "0011" when '0',
    "1100" when others;

  half_word_duplicated    <= FromProcessor(15 downto 0) & FromProcessor(15 downto 0);
  byte_quadruplicate      <= FromProcessor(7 downto 0) & FromProcessor(7 downto 0) & FromProcessor(7 downto 0) & FromProcessor(7 downto 0);
  half_word_zero_extended <= "0000000000000000" & selected_half_word;
  byte_zero_extended      <= "000000000000000000000000" & selected_byte;

  with selected_half_word(15) select half_word_sign_extended <=
    half_word_zero_extended                 when '0',
    "1111111111111111" & selected_half_word when others;

  with selected_byte(7) select byte_sign_extended <=
    byte_zero_extended                       when '0',
    "111111111111111111111111"&selected_byte when others;

  with DTType(2) select half_word_extended <=
    half_word_zero_extended when '0',
    half_word_sign_extended when others;

  with DTType(2) select byte_extended <=
    byte_zero_extended when '0',
    byte_sign_extended when others;

  with DTType(1 downto 0) select ToProcessor <=
    FromMemory         when "00",
    byte_extended      when "10",
    half_word_extended when others;

--ToProcessor <="";

  with DTType(1 downto 0) select ToMemory <=
    FromProcessor        when "00",
    byte_quadruplicate   when "10",
    half_word_duplicated when others;

  with DTType(1 downto 0) select WriteEnable <=
    "1111"                 when "00",
    write_offset_byte      when "10",
    write_offset_half_word when others;


end struc;
