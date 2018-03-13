library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity ALU_tb is
end ALU_tb;

architecture behavior of ALU_tb is
  component ALU is
    port (
      Op1      : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
      Op2      : in  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
      opcode   : in  std_logic_vector(3 downto 0)  := "0000";
      carry_in : in  std_logic                     := '0';
      output1  : out std_logic_vector(31 downto 0);
      Z        : out std_logic                     := '0';
      N        : out std_logic                     := '0';
      C        : out std_logic                     := '0';
      V        : out std_logic                     := '0');
  end component;


  --Inputs
  signal op1f : std_logic_vector(31 downto 0) := (others => '0');
  signal op2f : std_logic_vector(31 downto 0) := (others => '0');
  signal op   : std_logic_vector(3 downto 0)  := (others => '0');
  signal clk  : std_logic                     := '0';

  -- Outputs
  signal ALUout                                               : std_logic_vector(31 downto 0);
  signal car_temp, flagTempZ, flagTempV, flagTempN, flagTempC : std_logic;

  constant clk_period   : time    := 10 ns;
  signal err_cnt_signal : integer := 1;


begin
  uut : ALU
    port map(
      Op1      => op1f,
      Op2      => op2f,
      opcode   => op,
      carry_in => car_temp,
      output1  => ALUout,
      Z        => flagTempZ,
      N        => flagTempN,
      C        => flagTempC,
      V        => flagTempV);

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
    op1f     <= "00000000000000000000000000000011";
    op2f     <= "00000000000000000000000000000001";
    op       <= "0000";
    car_temp <= '0';



    wait for clk_period;

    -------------------------------------------------------------
    ---------------------  case 0 -------------------------------
    -------------------------------------------------------------


    assert (ALUout = "00000000000000000000000000000001") report "Error:  calculation by ALU  is wrong";
    if (ALUout /= "00000000000000000000000000000001") then
      err_cnt := err_cnt + 1;
    end if;


    assert (flagTempV = '0') report "Error:  calculation by ALU  is wrong";
    if (flagTempV /= '0') then
      err_cnt := err_cnt + 1;
    end if;


    ------------------------------------------------------------
    --------------------- pre-case 1 ---------------------------
    ------------------------------------------------------------

    -- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication

    -- Set inputs
    op1f     <= "10101010101010101010101010101010";
    op2f     <= "00000000000000000000000000000000";
    op       <= "0001";
    car_temp <= '0';



    wait for clk_period;

    -------------------------------------------------------------
    ---------------------  case 1 -------------------------------
    -------------------------------------------------------------


    assert (ALUout = "10101010101010101010101010101010") report "Error:  calculation by ALU  is wrong";
    if (ALUout /= "10101010101010101010101010101010") then
      err_cnt := err_cnt + 1;
    end if;


    assert (flagTempV = '0') report "Error:  calculation by ALU  is wrong";
    if (flagTempV /= '0') then
      err_cnt := err_cnt + 1;
    end if;


                                        ------------------------------------------------------------
    --------------------- pre-case 2 ---------------------------
    ------------------------------------------------------------

    -- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication

    -- Set inputs
    op1f     <= "10101010101010101010101010101010";
    op2f     <= "00000000000000000000000000000000";
    op       <= "0010";
    car_temp <= '0';



    wait for clk_period;

    -------------------------------------------------------------
    ---------------------  case 2 -------------------------------
    -------------------------------------------------------------


    assert (ALUout = "10101010101010101010101010101010") report "Error:  calculation by ALU  is wrong";
    if (ALUout /= "10101010101010101010101010101010") then
      err_cnt := err_cnt + 1;
    end if;


    assert (flagTempC = '0') report "Error:  calculation by ALU  is wrong";
    if (flagTempC /= '0') then
      err_cnt := err_cnt + 1;
    end if;

                                        ------------------------------------------------------------
    --------------------- pre-case 3 ---------------------------
    ------------------------------------------------------------

    -- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication

    -- Set inputs
    op1f     <= "10101010101010101010101010101010";
    op2f     <= "00000000000000000000000000000000";
    op       <= "0101";
    car_temp <= '1';



    wait for clk_period;

    -------------------------------------------------------------
    ---------------------  case 3 -------------------------------
    -------------------------------------------------------------


    assert (ALUout = "10101010101010101010101010101011") report "Error:  calculation by ALU  is wrong";
    if (ALUout /= "10101010101010101010101010101011") then
      err_cnt := err_cnt + 1;
    end if;


    assert (flagTempV = '0') report "Error:  calculation by ALU  is wrong";
    if (flagTempV /= '0') then
      err_cnt := err_cnt + 1;
    end if;
    -------------------------add more test cases---------------------------------------------

    err_cnt_signal <= err_cnt;
    -- summary of all the tests
    if (err_cnt = 0) then
      assert false
        report "Testbench of ALU completed successfully!"
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
