library IEEE;
use IEEE.std_logic_1164.all;


entity Memory_Interface is
  port (
    HTRANS    : in  std_logic;
    MemSelect : in  std_logic;
    HADDR     : in  std_logic_vector (11 downto 0);
    HWRITE    : in  std_logic;
    HWDATA    : in  std_logic_vector (31 downto 0);
    clk       : in  std_logic;
    HREADY    : out std_logic;
    HRDATA    : out std_logic_vector(31 downto 0)
    );
end entity Memory_Interface;

architecture arch of Memory_Interface is


  type state_type is (init, assertAddress, wait1, wait2, wait3, ReadData, WriteData);
  signal state : state_type;
begin

  process (clk)
  begin
    if (falling_edge(clk)) then
      case state is

        when init =>
          if(HTRANS = '0') then
            state <= init;
          else
            if(HADDR = "111111111111" or HADDR = "111111111110" or HADDR = "111111111101" or HADDR = "111111111100") then
              state <= init;
            else
              state <= assertAddress;
            end if;
          end if;

        when assertAddress =>
          addr   <= HADDR;
          HREADY <= '0';
          W      <= HWRITE;
          state  <= wait1;

        when wait1 =>
          HREADY <= '0';
          state  <= wait2;

        when wait2 =>
          HREADY <= '0';
          state  <= wait3;

        when wait3 =>
          HREADY <= '1';
          if(W = '1') then
            state <= WriteData;
          else
            state <= ReadData;
          end if;

        when WriteData =>
          WriteEnable <= '1';
          state       <= init;

        when ReadData =>
          HRDATA <= mem_out;
          state  <= init;
      end case;
    end if;
  end process;

end architecture;