
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity Single_clock_cycle is
  port (
    clock     : in  std_logic := '0';
    button    : in  std_logic := '0';
    out_pulse : out std_logic := '0');
end Single_clock_cycle;

architecture struc of Single_clock_cycle is
  signal count : integer := 0;


  signal sig                               : std_logic := '0';
  signal clr_flag, prev_sig, prev_prev_sig : std_logic := '0';

begin


  process(clock)
    variable idle : boolean;
  begin
    if rising_edge(clock) then
      out_pulse <= '0';                 -- default action
      if idle then
        if button = '1' then
          out_pulse <= '1';  -- overrides default FOR THIS CYCLE ONLY
          idle      := false;
        end if;
      else
        if button = '0' then
          idle := true;
        end if;
      end if;
    end if;
  end process;
--  process(clock)                        --- Sequential Writing
--  begin
--    if(rising_edge(button)) then
--      if (clock = '1') then

--        if(sig = '1') then
--          sig <= '0';
--        else
--          sig <= '1';
--        end if;

--        prev_sig <= sig;
--        prev_prev_sig<=prev_sig;

--      end if;

--    end if;

--    out_pulse <= sig and not(prev_prev_sig);

--  end process;
end struc;
