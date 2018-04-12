library IEEE;
use IEEE.std_logic_1164.all;


entity Cathode_interface is
  port (
        HTRANS : in std_logic_vector(1 downto 0);
        PortSelect : in std_logic_vector(3 downto 0);
        HWRITE : in std_logic;
        HWDATA : out std_logic_vector(31 downto 0);
        LEDs : in std_logic_vector(15 downto 0)

   );
end entity Cathode_interface;

architecture arch of Cathode_interface is


  type state_type is (Initial,TransferCheck,PortCheck,WriteCheck,WriteData);


 
begin
process (clk)
  begin
    if (rising_edge(clk)) then
      case state is
      ------------------------------
        when Initial => 
          state <= TransferCheck;
      ------------------------------
        when TransferCheck => 
          if (HTRANS = "00") then  -- IDLE
            state <= Initial;
          elsif (HTRANS = "10") then -- NONSEQ
            state <= PortCheck;
          end if;
      ------------------------------
        when PortCheck => 
          if (PortSelect = '1') then  
            state <= WriteCheck;
          else
              state <= Initial;
          end if;
      ------------------------------
        when WriteCheck => 
          if (HWRITE = '1') then  
            state <= WriteData;
          else
              state <= Initial;
          end if;

      ------------------------------
        when WriteData => 
          LEDs <= HWDATA;
          state <= Initial;
         
      end case;
    end if;
end process;

end architecture;