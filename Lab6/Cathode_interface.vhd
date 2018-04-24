library IEEE;
use IEEE.std_logic_1164.all;


entity Cathode_interface is
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
end entity Cathode_interface;

architecture arch of Cathode_interface is


  type state_type is (Initial,WriteData);
signal state:state_type;

 
begin
process (clk)
  begin
    if (rising_edge(clk)) then
      case state is
      ------------------------------
        when Initial => 

          if (HTRANS = '0') then  -- IDLE
            state <= Initial;
          elsif (HTRANS = '1') then -- NONSEQ
            --state <= PortCheck;
              if (PortSelect = '1') then  
          if (HWRITE = '1') then  
                state <= WriteData;
              end if;
            end if;
          end if;
      ------------------------------

        when WriteData => 
        if(Position ="00") then
          Cathodes (7 downto 0) <= HWDATA;
          elsif (Position = "01") then
          Cathodes (15 downto 8) <= HWDATA;
           elsif (Position = "01") then
           Cathodes (23 downto 16) <= HWDATA;
          else
          Cathodes (31 downto 24) <= HWDATA;
          end if;
          state <= Initial;
         
      end case;
    end if;
end process;

end architecture;