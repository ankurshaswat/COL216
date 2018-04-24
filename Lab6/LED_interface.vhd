library IEEE;
use IEEE.std_logic_1164.all;


entity LEDs_interface is
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
end entity LEDs_interface;

architecture arch of LEDs_interface is


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
          LEDs <= HWDATA(15 downto 0);
          state <= Initial;
         
      end case;
    end if;
end process;

end architecture;