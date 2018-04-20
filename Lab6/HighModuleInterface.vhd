entity HighModuleInterface is
port(

);


architecture arch  of HighModuleInterface is


component Anode_interface 
  port (
        HTRANS : in std_logic_vector(1 downto 0);
        PortSelect : in std_logic_vector(3 downto 0);
        HWRITE : in std_logic;
        HWDATA : in std_logic_vector(31 downto 0);
        Anodes : out std_logic_vector(15 downto 0)

   );
end component;


component  LEDs_interface is
  port (
        HTRANS : in std_logic_vector(1 downto 0);
        PortSelect : in std_logic_vector(3 downto 0);
        HWRITE : in std_logic;
        HWDATA : in std_logic_vector(31 downto 0);
        LEDs : out std_logic_vector(15 downto 0)

   );
end component ;

component Switches_interface is
  port (
        HTRANS : in std_logic_vector(1 downto 0);
        PortSelect : in std_logic_vector(3 downto 0);
        HWRITE : in std_logic;
        HRDATA : out std_logic_vector(31 downto 0);
        Switches : in std_logic_vector(15 downto 0)

   );
end component ;



component  Cathode_interface is
  port (
        HTRANS : in std_logic_vector(1 downto 0);
        PortSelect : in std_logic_vector(3 downto 0);
        HWRITE : in std_logic;
        HWDATA : in std_logic_vector(31 downto 0);
        Cathodes : out std_logic_vector(15 downto 0)

   );
end component ;

begin

end architecture;