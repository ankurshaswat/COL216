library IEEE;
use IEEE.std_logic_1164.all;


entity bus is
  port (

    clk : in std_logic;

    HWDATA        : in  std_logic_vector (31 downto 0);
    HADDR         : in  std_logic_vector (11 downto 0);
    MemSelect     : out std_logic;
    CathodeSelect : out std_logic;
    AnodeSelect   : out std_logic;
    SwitchSelect  : out std_logic;

    SwitchData : in std_logic_vector(31 downto 0);
    MemoryData : in std_logic_vector(31 downto 0);

    ReadySwitch : in std_logic;
    ReadyMemory : in std_logic;
    ReadyCathode : in std_logic;
    ReadyAnode : in std_logic;

    HWRITE : in  std_logic;
    HRDATA : out std_logic_vector(31 downto 0);
    HREADY : out std_logic;
    HTRANS : in  std_logic

    );
end entity bus;

architecture arch of bus is

begin

  with HADDR select HRDATA <=
    SwitchData                         when "111111111100" else
    "00000000000000000000000000000000" when "111111111101" else
    "00000000000000000000000000000000" when "111111111110" else
    "00000000000000000000000000000000" when "111111111111" else
    MemoryData;

    with HADDR select HREADY <=
      ReadySwitch                         when "111111111100" else
      ReadyLED when "111111111101" else
      ReadyAnode when "111111111110" else
      ReadyCathode when "111111111111" else
      ReadyMemory;

end architecture;
