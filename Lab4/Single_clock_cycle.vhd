
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity Single_clock_cycle is
  port (
    clock       : in  std_logic;
    reset       : in  std_logic;                     
    button      : in  std_logic;                    
    out_pulse          : out std_logic);
end Single_clock_cycle;

architecture struc of Single_clock_cycle is
signal count : integer :=0;
begin



  process(clock)                        --- Sequential Writing
  begin
    if(falling_edge(clock)) then
      if (button='1') then 
        if (count=0) then
          out_pulse <= clock;
        else 
          out_pulse<= 0;
        end if;
        
          
      end if;
    end if;

  end process;
end struc;
