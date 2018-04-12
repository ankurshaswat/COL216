library IEEE;
use IEEE.std_logic_1164.all;


entity Switches_interface is
  port (
        HTRANS : in std_logic_vector(1 downto 0);
        PortSelect : in std_logic_vector(3 downto 0);
        HWRITE : in std_logic;
        HRDATA : out std_logic_vector(31 downto 0);
        Switches : in std_logic_vector(15 downto 0)

   );
end entity Switches_interface;

architecture arch of Switches_interface is


type state_type is (Initial,ReadData);


 
begin
process (clk)
  begin
    if (rising_edge(clk)) then
      case state is
      ------------------------------
        when Initial => 

          if (HTRANS = "00") then  -- IDLE
            state <= Initial;
          elsif (HTRANS = "10") then -- NONSEQ
            --state <= PortCheck;
              if (PortSelect = '1') then  
          if (HWRITE = '1') then  
                state <= ReadData;
              end if;
            end if;
          end if;
      ------------------------------

        when WriteData => 
          HRDATA <= Switches;
          state <= Initial;
         
      end case;
    end if;
end process;

end architecture;