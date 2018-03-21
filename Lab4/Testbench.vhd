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
      clock, reset : in  std_logic                    := '0';
      ins_out      : out std_logic_vector(31 downto 0);
      F            : out std_logic_vector(3 downto 0);
      IorD         : in  std_logic                    := '0';
      --MR: in std_logic:='0';
      MW           : in  std_logic                    := '0';
      IW           : in  std_logic                    := '0';
      DW           : in  std_logic                    := '0';
      Rsrc         : in  std_logic                    := '0';
      M2R          : in  std_logic_vector(1 downto 0) := "00";  --
      RW           : in  std_logic                    := '0';
      AW           : in  std_logic                    := '0';
      BW           : in  std_logic                    := '0';
      mulSel       : in  std_logic                    := '0';
      Asrc1        : in  std_logic                    := '0';   --
      Asrc2        : in  std_logic_vector(1 downto 0) := "00";
      Fset         : in  std_logic                    := '0';
      op           : in  std_logic_vector(3 downto 0) := "0000";
      ReW          : in  std_logic                    := '0';

      WadSrc      : in std_logic_vector(1 downto 0) := "00";
      R1src       : in std_logic_vector(1 downto 0) := "00";
      op1sel      : in std_logic                    := '0';
      SType       : in std_logic_vector(1 downto 0) := "00";
      ShiftAmtSel : in std_logic                    := '0';
      Shift       : in std_logic                    := '0';
      MulW        : in std_logic                    := '0';
      ShiftW      : in std_logic                    := '0';
      op1update   : in std_logic                    := '0';
      --carry: in std_logic



      ALUout_sig   : out std_logic_vector(31 downto 0);
      ALUoutp_sig  : out std_logic_vector(31 downto 0);
      op1f_sig     : out std_logic_vector(31 downto 0);
      op2f_sig     : out std_logic_vector(31 downto 0);
      shifted_sig  : out std_logic_vector(31 downto 0);
      shiftedp_sig : out std_logic_vector(31 downto 0);
      rd1p_sig     : out std_logic_vector(31 downto 0);
      rd2p_sig     : out std_logic_vector(31 downto 0);
      PC_sig       : out std_logic_vector(31 downto 0);
      rad1_sig     : out std_logic_vector(31 downto 0);
      rad2_sig     : out std_logic_vector(31 downto 0);
      wad_sig      : out std_logic_vector(31 downto 0);
      wd_sig       : out std_logic_vector(31 downto 0);
      ad2_sig      : out std_logic_vector(31 downto 0);
      rd2p2_sig    : out std_logic_vector(31 downto 0)
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
    --      PW    => dout_mem(0),
    IorD    => dout_mem(0),
    --      MR    => dout_mem(1),
    MW      => dout_mem(1),
    IW      => dout_mem(2),
    DW      => dout_mem(3),

    Rsrc    => dout_mem(4),
    M2R     => dout_mem(6 downto 5),
    RW      => dout_mem(7),

    AW      => dout_mem(8),
    BW      => dout_mem(9),
    mulSel  => dout_mem(10),
    Asrc1   => dout_mem(11),

    Asrc2   => dout_mem(13 downto 12),
    Fset    => dout_mem(14),
    op      => dout_mem(18 downto 15),
    ReW     => dout_mem(19),

    WadSrc      => dout_mem(21 downto 20),
    R1src       => dout_mem(23 downto 22),
    
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
      &"00"    --              R1src => dout_mem(23 downto 22),
      &"00"    --              WadSrc => dout_mem(21 downto 20),
      &'0'                              --              ReW   => dout_mem(19),
      &"0000"  --              op    => dout_mem(18 downto 15),
      &'0'                              --              Fset  => dout_mem(14),
      &"00"    --              Asrc2 => dout_mem(13 downto 12),
      &"00"    --              Asrc1 => dout_mem(11 downto 10),
      &'0'                              --              BW    => dout_mem(9),
      &'0'                              --              AW    => dout_mem(8),
      &'0'                              --              RW    => dout_mem(7),
      &"00"    --              M2R   => dout_mem(6 downto 5),
      &'0'                              --              Rsrc  => dout_mem(4),
      &'0'                              --              DW    => dout_mem(3),
      &'1'                              --              IW    => dout_mem(2),
      &'0'                              --              MW    => dout_mem(1),
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
      &"00"    --              R1src => dout_mem(23 downto 22),
      &"00"    --              WadSrc => dout_mem(21 downto 20),
      &'1'                              --              ReW   => dout_mem(19),
      &"0000"  --              op    => dout_mem(18 downto 15),
      &'0'                              --              Fset  => dout_mem(14),
      &"01"    --              Asrc2 => dout_mem(13 downto 12),
      &"00"    --              Asrc1 => dout_mem(11 downto 10),
      &'0'                              --              BW    => dout_mem(9),
      &'0'                              --              AW    => dout_mem(8),
      &'0'                              --              RW    => dout_mem(7),
      &"00"    --              M2R   => dout_mem(6 downto 5),
      &'0'                              --              Rsrc  => dout_mem(4),
      &'0'                              --              DW    => dout_mem(3),
      &'0'                              --              IW    => dout_mem(2),
      &'0'                              --              MW    => dout_mem(1),
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
      &"00"    --              R1src => dout_mem(23 downto 22),
      &"10"    --              WadSrc => dout_mem(21 downto 20),
      &'0'                              --              ReW   => dout_mem(19),
      &"0000"  --              op    => dout_mem(18 downto 15),
      &'0'                              --              Fset  => dout_mem(14),
      &"01"    --              Asrc2 => dout_mem(13 downto 12),
      &"00"    --              Asrc1 => dout_mem(11 downto 10),
      &'0'                              --              BW    => dout_mem(9),
      &'0'                              --              AW    => dout_mem(8),
      &'1'                              --              RW    => dout_mem(7),
      &"01"    --              M2R   => dout_mem(6 downto 5),
      &'0'                              --              Rsrc  => dout_mem(4),
      &'0'                              --              DW    => dout_mem(3),
      &'0'                              --              IW    => dout_mem(2),
      &'0'                              --              MW    => dout_mem(1),
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
