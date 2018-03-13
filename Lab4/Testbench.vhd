library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use ieee.numeric_std.all;

entity Testbench is
  port (
--  SW                  : in  STD_LOGIC_VECTOR (15 downto 0);
--         BTN             : in  STD_LOGIC_VECTOR (4 downto 0);
--         CLK             : in  STD_LOGIC;
--         reset             : in  STD_LOGIC;
    Flags_out : out std_logic_vector(3 downto 0);
    IR        : out std_logic_vector(31 downto 0)
--         LED             : out  STD_LOGIC_VECTOR (15 downto 0);
--         SSEG_CA         : out  STD_LOGIC_VECTOR (7 downto 0);
--         SSEG_AN         : out  STD_LOGIC_VECTOR (3 downto 0);
--         UART_TXD     : out  STD_LOGIC;
--         UART_RXD     : in   STD_LOGIC;
--         VGA_RED      : out  STD_LOGIC_VECTOR (3 downto 0);
--         VGA_BLUE     : out  STD_LOGIC_VECTOR (3 downto 0);
--         VGA_GREEN    : out  STD_LOGIC_VECTOR (3 downto 0);
--         VGA_VS       : out  STD_LOGIC;
--         VGA_HS       : out  STD_LOGIC;
--         PS2_CLK      : inout STD_LOGIC;
--         PS2_DATA     : inout STD_LOGIC
    );
end Testbench;

architecture behavior of Testbench is

  -- Component Declaration for the Unit Under Test (UUT)

  component Datapath
    port (
      clock, reset : in  std_logic;
      ins_out      : out std_logic_vector(31 downto 0);
      F            : out std_logic_vector(3 downto 0);
      IorD         : in  std_logic;
      MR           : in  std_logic;
      MW           : in  std_logic;
      IW           : in  std_logic;
      DW           : in  std_logic;
      Rsrc         : in  std_logic;
      M2R          : in  std_logic_vector(1 downto 0);  --
      RW           : in  std_logic;
      AW           : in  std_logic;
      BW           : in  std_logic;
      Asrc1        : in  std_logic_vector(1 downto 0);  --
      Asrc2        : in  std_logic_vector(1 downto 0);
      Fset         : in  std_logic;
      op           : in  std_logic_vector(3 downto 0);
      ReW          : in  std_logic;

      WadSrc      : in std_logic_vector(1 downto 0);
      R1src       : in std_logic;
      op1sel      : in std_logic;
      SType       : in std_logic_vector(1 downto 0);
      ShiftAmtSel : in std_logic;
      Shift       : in std_logic;
      MulW        : in std_logic;
      ShiftW      : in std_logic;
      op1update   : in std_logic
--carry: in std_logic

      );
  end component;

  signal dout_mem     : std_logic_vector(31 downto 0);
  signal CLK, reset   : std_logic := '0';
  constant clk_period : time      := 10 ps;
begin

  -- Instantiate the Unit Under Test (UUT)
  DP_inst : Datapath port map(
    clock   => CLK,
    reset   => reset,
    ins_out => IR,
    F       => Flags_out,
    --    PW    => dout_mem(0),
    IorD    => dout_mem(0),
    MR      => dout_mem(1),
    MW      => dout_mem(2),
    IW      => dout_mem(3),
    DW      => dout_mem(4),
    Rsrc    => dout_mem(5),
    M2R     => dout_mem(7 downto 6),
    RW      => dout_mem(8),
    AW      => dout_mem(9),
    BW      => dout_mem(10),
    Asrc1   => dout_mem(12 downto 11),
    Asrc2   => dout_mem(14 downto 13),
    Fset    => dout_mem(15),
    op      => dout_mem(19 downto 16),
    ReW     => dout_mem(20),

    WadSrc      => dout_mem(22 downto 21),
    R1src       => dout_mem(23),
    op1sel      => dout_mem(24),
    SType       => dout_mem(26 downto 25),
    ShiftAmtSel => dout_mem(27),
    Shift       => dout_mem(28),
    MulW        => dout_mem(29),
    ShiftW      => dout_mem(30),
    op1update   => dout_mem(31)

    );


  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
--              dout_mem <= "00000000000000000000000000000000";
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;

  end process;



  -- Stimulus process
  stim_proc : process

--              type intArray is array(0 to 3) of integer;
--              variable cathodeGroundTruth : intArray := (0,1,0,1);
    variable err_cnt : integer := 0;
  begin

    ------------------------------------------------------------
    --------------------- TEST CASE 1 ---------------------------
    ------------------------------------------------------------

    reset    <= '1';
    dout_mem <= "00000000000000000000000000000000";

--      sim_mode<='1';
    wait for clk_period;
    reset <= '0';
    wait for 300*clk_period;

    wait for clk_period;

    dout_mem <=
      '0'      --              op1update => dout_mem(31)
      &'0'                              --              ShiftW => dout_mem(30),
      &'0'                              --              MulW => dout_mem(29),
      &'0'                              --              Shift => dout_mem(28),
      &'0'     --              ShiftAmtSel => dout_mem(27),
      &"00"    --              SType => dout_mem(26 downto 25),
      &'0'                              --              op1sel => dout_mem(24),
      &'0'                              --              R1src => dout_mem(23),
      &"00"    --              WadSrc => dout_mem(22 downto 21),
      &'0'                              --              ReW   => dout_mem(20),
      &"0000"  --              op    => dout_mem(19 downto 16),
      &'0'     --              Fset  => dout_mem(15),
      &"00"    --              Asrc2 => dout_mem(14 downto 13),
      &"00"    --              Asrc1 => dout_mem(12 downto 11),
      &'0'     --              BW    => dout_mem(10),
      &'0'     --              AW    => dout_mem(9),
      &'0'     --              RW    => dout_mem(8),
      &"00"    --              M2R   => dout_mem(7 downto 6),
      &'0'     --              Rsrc  => dout_mem(5),
      &'0'     --              DW    => dout_mem(4),
      &'1'     --              IW    => dout_mem(3),
      &'0'     --              MW    => dout_mem(2),
      &'0'     --              MR    => dout_mem(1),
      &'0'                              --   IorD  => dout_mem(0),
;
    wait for clk_period;
    dout_mem <=
      '0'      --              op1update => dout_mem(31)
      &'0'                              --              ShiftW => dout_mem(30),
      &'0'                              --              MulW => dout_mem(29),
      &'0'                              --              Shift => dout_mem(28),
      &'0'     --              ShiftAmtSel => dout_mem(27),
      &"00"    --              SType => dout_mem(26 downto 25),
      &'0'                              --              op1sel => dout_mem(24),
      &'0'                              --              R1src => dout_mem(23),
      &"00"    --              WadSrc => dout_mem(22 downto 21),
      &'1'                              --              ReW   => dout_mem(20),
      &"0100"  --              op    => dout_mem(19 downto 16),
      &'0'     --              Fset  => dout_mem(15),
      &"01"    --              Asrc2 => dout_mem(14 downto 13),
      &"00"    --              Asrc1 => dout_mem(12 downto 11),
      &'0'     --              BW    => dout_mem(10),
      &'0'     --              AW    => dout_mem(9),
      &'0'     --              RW    => dout_mem(8),
      &"00"    --              M2R   => dout_mem(7 downto 6),
      &'0'     --              Rsrc  => dout_mem(5),
      &'0'     --              DW    => dout_mem(4),
      &'0'     --              IW    => dout_mem(3),
      &'0'     --              MW    => dout_mem(2),
      &'0'     --              MR    => dout_mem(1),
      &'0'                              --   IorD  => dout_mem(0),
;

    wait for clk_period;

    dout_mem <=
      '0'      --              op1update => dout_mem(31)
      &'0'                              --              ShiftW => dout_mem(30),
      &'0'                              --              MulW => dout_mem(29),
      &'0'                              --              Shift => dout_mem(28),
      &'0'     --              ShiftAmtSel => dout_mem(27),
      &"00"    --              SType => dout_mem(26 downto 25),
      &'0'                              --              op1sel => dout_mem(24),
      &'0'                              --              R1src => dout_mem(23),
      &"10"    --              WadSrc => dout_mem(22 downto 21),
      &'0'                              --              ReW   => dout_mem(20),
      &"0000"  --              op    => dout_mem(19 downto 16),
      &'0'     --              Fset  => dout_mem(15),
      &"00"    --              Asrc2 => dout_mem(14 downto 13),
      &"00"    --              Asrc1 => dout_mem(12 downto 11),
      &'0'     --              BW    => dout_mem(10),
      &'0'     --              AW    => dout_mem(9),
      &'1'     --              RW    => dout_mem(8),
      &"01"    --              M2R   => dout_mem(7 downto 6),
      &'0'     --              Rsrc  => dout_mem(5),
      &'0'     --              DW    => dout_mem(4),
      &'0'     --              IW    => dout_mem(3),
      &'0'     --              MW    => dout_mem(2),
      &'0'     --              MR    => dout_mem(1),
      &'0'                              --   IorD  => dout_mem(0),
;

    wait for clk_period;

    ------------------------------------------------------------
    --------------------- TEST CASES COMPLETED ---------------------------
    ------------------------------------------------------------


    if (err_cnt = 0) then
--                       assert false
      report "Testbench of Datapath completed successfully!";
    --  severity note;
    else
--                       assert false
      report "Something wrong, try again";
    --   severity error;
    end if;
    --
    report "TEST BENCH MADE BY SHASHWAT SHIVAM (2016CS10328)";
    wait for clk_period*10;

    wait;
  end process;

end;
