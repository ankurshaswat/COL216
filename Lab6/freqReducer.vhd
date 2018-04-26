library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_reducer is
Port (
        clk_in : in  STD_LOGIC;

        clk_out: out STD_LOGIC
    );
end entity clock_reducer;

architecture Behavioral of clock_reducer is
    signal temporal :std_logic :='0';
    signal counter : integer range 0 to 131075 := 0;
begin
    process ( clk_in) begin

        if rising_edge(clk_in) then
            if (counter = 131072) then
                temporal <= NOT(temporal);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= temporal;
end Behavioral;
------------------------------------
