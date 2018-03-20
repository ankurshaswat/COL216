
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity Single_clock_cycle is
  port (
    clock     : in  std_logic;
    reset     : in  std_logic;
    button    : in  std_logic;
    out_pulse : out std_logic);
end Single_clock_cycle;

architecture struc of Single_clock_cycle is
  signal count : integer := 0;


  signal sig      : std_logic;
  signal prev_sig : std_logic;

begin



  process(clock)                        --- Sequential Writing
  begin
    if(rising_edge(clock)) then
      if (button = '1') then
          if(sig='1') then
            sig<='0';
          else
            sig<='1'
          end if;
          prev_sig<=sig;
        else
          out_pulse <= 0;
        end if;


    end if;

  end process;
end struc;
