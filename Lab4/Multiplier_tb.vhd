library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity multiplier_tb is
end multiplier_tb;

architecture behavior of multiplier_tb is

  component Multiplier is
    port (
      Op1    : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
      Op2    : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
      Result : out std_logic_vector(31 downto 0));
  end component;

  --Inputs
  signal op1 : std_logic_vector(31 downto 0) := (others => '0');
  signal op2 : std_logic_vector(31 downto 0) := (others => '0');
  signal clk : std_logic                     := '0';

  -- Outputs
  signal mul : std_logic_vector(31 downto 0);

  constant clk_period   : time    := 10 ns;
  signal err_cnt_signal : integer := 0;


begin
  uut : Multiplier
    port map(
      Op1    => op1,
      Op2    => op2,
      Result => mul);

  -- Clock process definitions

  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;


  stim_proc : process
    variable err_cnt : integer := 0;
  begin
    ------------------------------------------------------------
    --------------------- pre-case 0 ---------------------------
    ------------------------------------------------------------

    -- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication

    -- Set inputs
    op1 <= "00000000000000000000000000000011";
    op2 <= "00000000000000000000000000000001";

    wait for clk_period;

    -------------------------------------------------------------
    ---------------------  case 0 -------------------------------
    -------------------------------------------------------------


    assert (mul = "00000000000000000000000000000011") report "Error: product calculation by multiplier 00 is wrong";
    if (mul /= "00000000000000000000000000000011") then
      err_cnt := err_cnt + 1;
    end if;


    -------------------------add more test cases---------------------------------------------

    err_cnt_signal <= err_cnt;
    -- summary of all the tests
    if (err_cnt = 0) then
      assert false
        report "Testbench of Multiplier completed successfully!"
        severity note;
    else
      assert false
        report "Something wrong, try again"
        severity error;
    end if;

    -- end of tb
    wait for clk_period*100;

    wait;


  end process;

end architecture;
