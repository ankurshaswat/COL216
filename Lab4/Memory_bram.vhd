
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity Memory is

  port(Address     : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000001";
       writeData   : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000001";
       clock       : in  std_logic                     := '0';
       MR          : in  std_logic                     := '1';
       reset       : in  std_logic                     := '0';
       MW          : in  std_logic                     := '0';
       WriteEnable : in  std_logic_vector(3 downto 0)  := "0000";
       outer       : out std_logic_vector(31 downto 0));

end entity Memory;

architecture arch of Memory is

  component design_1_wrapper is
    port (
      BRAM_PORTA_addr : in  std_logic_vector (31 downto 0);
      BRAM_PORTA_clk  : in  std_logic;
      BRAM_PORTA_din  : in  std_logic_vector (31 downto 0);
      BRAM_PORTA_dout : out std_logic_vector (31 downto 0);
--    BRAM_PORTA_en : in STD_LOGIC;
      BRAM_PORTA_rst  : in  std_logic;
      BRAM_PORTA_we   : in  std_logic_vector (3 downto 0)
      );
  end component;



--TYPE filereg is array (0 to 1000) of std_logic_vector(31 downto 0) ;
--SIGNAL registerFile : filereg;
--signal outerTemp:std_logic_vector(31 downto 0);
-- SIGNAL Address_INFO : integer ;

  signal write_enable_final : std_logic_vector(3 downto 0);


begin

  with MW select write_enable_final <=
    "0000"      when '0',
    WriteEnable when others;


  ram : design_1_wrapper port map(
    BRAM_PORTA_addr => Address,
    BRAM_PORTA_clk  => clock,
    BRAM_PORTA_din  => writeData,
    BRAM_PORTA_dout => outer,
--    BRAM_PORTA_en => MW,
    BRAM_PORTA_rst  => reset,
    BRAM_PORTA_we   => write_enable_final
    );


---- Concurrent Address assignment;

--outer<= outerTemp;

--Address_INFO <= to_integer(unsigned(Address));
--with MR select outerTemp<=
--      registerFile(Address_INFO) when '1',
--      outerTemp when others;


--process(clock)                                                --- Sequential Writing
--begin
--      if(rising_edge(clock)) then
--              if(MW='1') then
--                      registerFile(Address_INFO)<=writeData;
--              end if;

--      end if;
--end process;


end architecture arch;
