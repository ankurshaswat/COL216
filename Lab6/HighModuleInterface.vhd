library IEEE;
use IEEE.std_logic_1164.all;


entity HighModuleInterface is
  port(
    clk:in std_logic;

--    HWDATA        : in  std_logic_vector (31 downto 0);
--    HADDR         : in  std_logic_vector (15 downto 0);
--    MemSelect     : out std_logic;
--    CathodeSelect : out std_logic;
--    AnodeSelect   : out std_logic;
--    SwitchSelect  : out std_logic;

--    SwitchData : in std_logic_vector(31 downto 0);
--    MemoryData : in std_logic_vector(31 downto 0);

--    ReadySwitch  : in std_logic;
--    ReadyMemory  : in std_logic;
--    ReadyCathode : in std_logic;
--    ReadyAnode   : in std_logic;

--    HWRITE : in  std_logic;
--    HRDATA : out std_logic_vector(31 downto 0);
--    HREADY : out std_logic;
--    HTRANS : in  std_logic

Switches : in std_logic_vector(15 downto 0);

LEDs : out std_logic_vector(15 downto 0)
    );
end entity HighModuleInterface;

architecture arch of HighModuleInterface is


  component LEDs_interface is
    port (
      HTRANS     : in  std_logic;
      PortSelect : in  std_logic;
      HWRITE     : in  std_logic;
       clk       : in  std_logic;
        HREADYIN    : in std_logic;
                  HREADYOUT    : out std_logic;
      HWDATA     : in  std_logic_vector(31 downto 0);
      LEDs       : out std_logic_vector(15 downto 0)

      );
  end component;

  component Anode_interface is
    port (
      HTRANS     : in  std_logic;
      PortSelect : in  std_logic;
      HWRITE     : in  std_logic;
       HREADYIN    : in std_logic;
                 HREADYOUT    : out std_logic;
       clk       : in  std_logic;
      HWDATA     : in  std_logic_vector(31 downto 0);
      Anodes     : out std_logic_vector(1 downto 0)

      );
  end component;


  component Switches_interface is
    port (
      HTRANS     : in  std_logic;
      PortSelect : in  std_logic;
       HREADYIN    : in std_logic;
                 HREADYOUT    : out std_logic;
      HWRITE     : in  std_logic;
       clk       : in  std_logic;
      HRDATA     : out std_logic_vector(31 downto 0);
      Switches   : in  std_logic_vector(15 downto 0)

      );
  end component;



  component Cathode_interface is
    port (
    Position : in std_logic_vector(1 downto 0);
      HTRANS     : in  std_logic;
      PortSelect : in  std_logic;
      HWRITE     : in  std_logic;
        clk       : in  std_logic;
          HREADYIN    : in std_logic;
            HREADYOUT    : out std_logic;
      HWDATA     : in  std_logic_vector(31 downto 0);
      Cathodes   : out std_logic_vector(31 downto 0)

      );
  end component;



  component Memory_Interface is
    port (
      HTRANS    : in  std_logic;
      MemSelect : in  std_logic;
      HADDR     : in  std_logic_vector (11 downto 0);
      HWRITE    : in  std_logic;
      HWDATA    : in  std_logic_vector (31 downto 0);
      clk       : in  std_logic;
      HREADYIN    : in std_logic;
      HREADYOUT    : out std_logic;
      HRDATA    : out std_logic_vector(31 downto 0)
      );
  end component;

    signal ReadyLED,HREADY,HTRANS,HWRITE,LEDSelect_temp,ReadyAnode,ReadySwitch,ReadyMemory,ReadyCathode,HREADY_temp,MemSelect_temp,AnodeSelect_temp,SwitchSelect_temp,CathodeSelect_temp:std_logic;
    signal Cathodes,HRDATA,HWDATA,MemoryData:std_logic_vector(31 downto 0);
    signal SwitchData,HADDR:std_logic_vector(15 downto 0);
    signal Anodes:std_logic_vector(1 downto 0);

begin

  mi : Memory_Interface port map(
    HTRANS    => HTRANS,
    MemSelect => MemSelect_temp,
    HADDR     => HADDR,
    HWRITE    => HWRITE,
    HWDATA    => HWDATA,
    clk       => clk,
    HREADYIN  => HREADY_temp,
    HREADYOUT => ReadyMemory,
    HRDATA    => MemoryData
    );

  Pattern: Cathode_interface port map(
    Position => Anodes,
    HTRANS     => HTRANS,
    PortSelect => CathodeSelect_temp,
    HWRITE     => HWRITE,
    clk        => clk,
    HREADYIN   => HREADY_temp,
    HREADYOUT  => ReadyCathode,
    HWDATA     => HWDATA,
    Cathodes => Cathodes
    );

  si : Switches_interface port map(
    HTRANS     => HTRANS,
    PortSelect => SwitchSelect_temp,
    clk        => clk,
    HREADYIN   => HREADY_temp,
    HREADYOUT  => ReadySwitch,
    HRDATA     => SwitchData,
    HWRITE => HWRITE,
    Switches => Switches
    );

  Position : Anode_interface port map(
    HTRANS     => HTRANS,
    PortSelect => AnodeSelect_temp,
    HWRITE     => HWRITE,
    clk        => clk,
    HREADYIN   => HREADY_temp,
    HREADYOUT  => ReadyAnode,
    HWDATA     => HWDATA,
    Anodes => Anodes
    );

  li : LEDs_interface port map(
    HTRANS     => HTRANS,
    PortSelect => LEDSelect_temp,
    HWRITE     => HWRITE,
    clk        => clk,
    HREADYIN   => HREADY_temp,
    HREADYOUT  => ReadyCathode,
    HWDATA     => HWDATA,
    LEDs => LEDs
    );


  with HADDR select HRDATA <=
    SwitchData                         when "1111111111111100" ,
    "00000000000000000000000000000000" when "1111111111111101" ,
    "00000000000000000000000000000000" when "1111111111111110" ,
    "00000000000000000000000000000000" when "1111111111111111" ,
    MemoryData when others;

  with HADDR select HREADY_temp <=
    ReadySwitch  when "1111111111111100" ,
    ReadyLED     when "1111111111111101" ,
    ReadyAnode   when "1111111111111110" ,
    ReadyCathode when "1111111111111111" ,
    ReadyMemory when others;

  MemSelect_temp     <= '0' when HADDR(15 downto 2) = "11111111111111" else '1';
  SwitchSelect_temp  <= '1' when HADDR = "1111111111111100"            else '0';
  AnodeSelect_temp   <= '1' when HADDR = "1111111111111110"            else '0';
  CathodeSelect_temp <= '1' when HADDR = "1111111111111111"            else '0';
  LEDSelect_temp     <= '1' when HADDR = "1111111111111101"            else '0';

end architecture;
