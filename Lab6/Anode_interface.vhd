library IEEE;
use IEEE.std_logic_1164.all;


entity Anode_interface is
 port (
     HTRANS     : in  std_logic  := '0';
     PortSelect : in  std_logic := '0';
     HWRITE     : in  std_logic := '0';
      HREADYIN    : in std_logic := '0';
                HREADYOUT    : out std_logic; := '0'
      clk       : in  std_logic := '0';
     HWDATA     : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
     Anodes     : out std_logic_vector(1 downto 0):= "00"

     );
end entity Anode_interface;

architecture arch of Anode_interface is


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
          Anodes <= HWDATA(1 downto 0);
          state <= Initial;
         
      end case;
    end if;
end process;

end architecture;