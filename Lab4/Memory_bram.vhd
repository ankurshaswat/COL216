
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity Memory is
 
PORT( Address:IN std_logic_vector(31 downto 0);
 writeData:IN std_logic_vector(31 downto 0);
 clock : IN std_logic;
 MR:IN std_logic;
 reset: in std_logic;
 MW:IN std_logic;
    outer:OUT std_logic_vector(31 downto 0));

end entity Memory;

architecture arch of Memory is

component design_1_wrapper is
  port (
    BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_clk : in STD_LOGIC;
    BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_en : in STD_LOGIC;
    BRAM_PORTA_rst : in STD_LOGIC;
    BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end component;



--TYPE filereg is array (0 to 1000) of std_logic_vector(31 downto 0) ;
--SIGNAL registerFile : filereg;
--signal outerTemp:std_logic_vector(31 downto 0);
-- SIGNAL Address_INFO : integer ;

signal ones:std_logic_vector(3 downto 0):="1111";


begin



ram: design_1_wrapper port map(
   BRAM_PORTA_addr =>Address,
    BRAM_PORTA_clk => clock,
    BRAM_PORTA_din =>writeData,
    BRAM_PORTA_dout => outer,
    BRAM_PORTA_en => MR,
    BRAM_PORTA_rst => reset,
    BRAM_PORTA_we => ones
);


---- Concurrent Address assignment;

--outer<= outerTemp;

--Address_INFO <= to_integer(unsigned(Address));
--with MR select outerTemp<=
--	registerFile(Address_INFO) when '1',
--	outerTemp when others;


--process(clock)						--- Sequential Writing
--begin
--	if(rising_edge(clock)) then
--		if(MW='1') then
--			registerFile(Address_INFO)<=writeData;
--		end if;

--	end if;
--end process;


end architecture arch;