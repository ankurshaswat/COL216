library IEEE;
use IEEE.std_logic_1164.all;


entity HighModuleInterface is
  port(
    SW        : in    std_logic_vector (15 downto 0);
    BTN       : in    std_logic_vector (4 downto 0);
    CLK       : in    std_logic;
    LED       : out   std_logic_vector (15 downto 0);
    SSEG_CA   : out   std_logic_vector (7 downto 0);
    SSEG_AN   : out   std_logic_vector (3 downto 0);
    UART_TXD  : out   std_logic;
    UART_RXD  : in    std_logic;
    VGA_RED   : out   std_logic_vector (3 downto 0);
    VGA_BLUE  : out   std_logic_vector (3 downto 0);
    VGA_GREEN : out   std_logic_vector (3 downto 0);
    VGA_VS    : out   std_logic;
    VGA_HS    : out   std_logic;
    PS2_CLK   : inout std_logic;
    PS2_DATA  : inout std_logic
    );
end entity HighModuleInterface;

architecture arch of HighModuleInterface is


  component LEDs_interface is
    port (
      HTRANS     : in  std_logic;
      PortSelect : in  std_logic;
      HWRITE     : in  std_logic;
      clk        : in  std_logic;
      HREADYIN   : in  std_logic;
      HREADYOUT  : out std_logic;
      HWDATA     : in  std_logic_vector(31 downto 0);
      LEDs       : out std_logic_vector(15 downto 0)

      );
  end component;
  component Single_clock_cycle is
    port (
      clock     : in  std_logic;
      button    : in  std_logic;
      out_pulse : out std_logic);
  end component;

  component SevenSegmentDisplay is
  port(
  		clk : in std_logic;
  		Display_inp : in std_logic_vector(31 downto 0);

  		Anode : out std_logic_vector(3 downto 0);
  		Cathode : out std_logic_vector(7 downto 0)
  	);
  end component;


  component Anode_interface is
    port (
      HTRANS     : in  std_logic;
      PortSelect : in  std_logic;
      HWRITE     : in  std_logic;
      HREADYIN   : in  std_logic;
      HREADYOUT  : out std_logic;
      clk        : in  std_logic;
      HWDATA     : in  std_logic_vector(31 downto 0);
      Anodes     : out std_logic_vector(1 downto 0)

      );
  end component;


  component Switches_interface is
    port (
      HTRANS     : in  std_logic;
      PortSelect : in  std_logic;
      HREADYIN   : in  std_logic;
      HREADYOUT  : out std_logic;
      HWRITE     : in  std_logic;
      clk        : in  std_logic;
      HRDATA     : out std_logic_vector(31 downto 0);
      Switches   : in  std_logic_vector(15 downto 0)

      );
  end component;



  component Cathode_interface is
    port (
      Position   : in  std_logic_vector(1 downto 0);
      HTRANS     : in  std_logic;
      PortSelect : in  std_logic;
      HWRITE     : in  std_logic;
      clk        : in  std_logic;
      HREADYIN   : in  std_logic;
      HREADYOUT  : out std_logic;
      HWDATA     : in  std_logic_vector(31 downto 0);
      Cathodes   : out std_logic_vector(31 downto 0)

      );
  end component;



  component Memory_Interface is
    port (
      HTRANS    : in  std_logic;
      MemSelect : in  std_logic;
      HADDR     : in  std_logic_vector (31 downto 0);
      HWRITE    : in  std_logic;
      HWDATA    : in  std_logic_vector (31 downto 0);
      clk       : in  std_logic;
      HREADYIN  : in  std_logic;
      HREADYOUT : out std_logic;
      HRDATA    : out std_logic_vector(31 downto 0);
      HSIZE     : in  std_logic_vector(1 downto 0);
      reset     : in  std_logic;
      dttyper   : in  std_logic_vector(2 downto 0)
      );
  end component;


  component Controller is
    port (
      ins         : in  std_logic_vector(31 downto 0);
      clk         : in  std_logic;
      IorD        : out std_logic;
      MW          : out std_logic;
      IW          : out std_logic;
      DW          : out std_logic;
      Rsrc        : out std_logic;
      M2R         : out std_logic_vector(1 downto 0);  --
      RW          : out std_logic;
      AW          : out std_logic;
      BW          : out std_logic;
      mulSel      : out std_logic;
      Asrc1       : out std_logic;                     --
      Asrc2       : out std_logic_vector(1 downto 0);
      Fset        : out std_logic;
      op          : out std_logic_vector(3 downto 0);
      ReW         : out std_logic;
      WadSrc      : out std_logic_vector(1 downto 0);
      R1src       : out std_logic_vector(1 downto 0);
      op1sel      : out std_logic;
      SType       : out std_logic_vector(1 downto 0);
      ShiftAmtSel : out std_logic;
      Shift       : out std_logic;
      MulW        : out std_logic;
      ShiftW      : out std_logic;
      op1update   : out std_logic;
      HTRANS      : out std_logic;
      HWRITE      : out std_logic;
      HREADY      : in  std_logic);
  end component;

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


      HRDATA :in std_logic_vector(31 downto 0);
      HWDATA :out std_logic_vector(31 downto 0);
      HADDR :out std_logic_vector(31 downto 0);


      ALUout_sig   : out std_logic_vector(31 downto 0);
      ALUoutp_sig  : out std_logic_vector(31 downto 0);
      op1f_sig     : out std_logic_vector(31 downto 0);
      op2f_sig     : out std_logic_vector(31 downto 0);
      shifted_sig  : out std_logic_vector(31 downto 0);
      shiftedp_sig : out std_logic_vector(31 downto 0);
      rd1p_sig     : out std_logic_vector(31 downto 0);
      rd2p_sig     : out std_logic_vector(31 downto 0);
      PC_sig       : out std_logic_vector(31 downto 0);
      rad1_sig     : out std_logic_vector(3 downto 0);
      rad2_sig     : out std_logic_vector(3 downto 0);
      wad_sig      : out std_logic_vector(3 downto 0);
      wd_sig       : out std_logic_vector(31 downto 0);
      ad2_sig      : out std_logic_vector(31 downto 0);
      rd2p2_sig    : out std_logic_vector(31 downto 0);
      rd_temp_sig  : out std_logic_vector(31 downto 0);
      op1_sig      : out std_logic_vector(31 downto 0);
      op2_sig      : out std_logic_vector(31 downto 0);
      op1p_sig     : out std_logic_vector(31 downto 0);
      rd_sig       : out std_logic_vector(31 downto 0);
      Samt_sig     : out std_logic_vector(4 downto 0);
      mulp_sig     : out std_logic_vector(31 downto 0);
      mul_sig      : out std_logic_vector(31 downto 0)
      );
  end component;

  signal HSIZE : std_logic_vector(1 downto 0);
  signal reset : std_logic;
  signal ReadyLED, HTRANS, HWRITE, LEDSelect_temp, ReadyAnode, ReadySwitch, ReadyMemory, ReadyCathode, HREADY_temp,
    MemSelect_temp, AnodeSelect_temp, SwitchSelect_temp, CathodeSelect_temp : std_logic;
  signal Cathodes, HRDATA, HWDATA, MemoryData : std_logic_vector(31 downto 0);
  signal SwitchData                           : std_logic_vector(31 downto 0);
  signal HADDR                                : std_logic_vector(31 downto 0);
  signal Anodes                               : std_logic_vector(1 downto 0);
  signal temp                                 : std_logic;
  signal btn_3_d                              : std_logic;
  signal UART_RX_CNT                          : std_logic_vector(15 downto 0);
  signal clk_mem                              : std_logic;
  signal ena_mem                              : std_logic;
  signal wea_mem                              : std_logic_vector(3 downto 0);
  signal addr_mem                             : std_logic_vector(11 downto 0);
  signal din_mem                              : std_logic_vector(31 downto 0);
  signal dout_mem, dout_mem_temp, dshow       : std_logic_vector(31 downto 0);
  signal IR                                   : std_logic_vector(31 downto 0);
  signal rx_uart                              : std_logic_vector(7 downto 0);
  signal switch_pair                          : std_logic_vector(1 downto 0);
  signal reset_mem                            : std_logic;
  signal Flags_out                            : std_logic_vector(3 downto 0);

  signal op1p, op1, op2, ALUout, ALUoutp, op1f, op2f,
    rd1p, rd_temp, rd, rd2p, shifted, shiftedp, PC, wd, ad2, rd2p2, mulp, mul : std_logic_vector(31 downto 0);
  signal rad1, rad2, wad : std_logic_vector(3 downto 0);
  signal Samt            : std_logic_vector(4 downto 0);
  signal dttyper : std_logic_vector(2 downto 0);

  signal out_pulse, mulSel : std_logic;
begin

  ssd : SevenSegmentDisplay port map(clk => CLK , Display_inp => Cathodes, Anode =>SSEG_AN, Cathode => SSEG_CA);

  sp : Single_clock_cycle port map(clock => CLK, button => BTN(2), out_pulse => out_pulse);

  cont : Controller port map(
    ins         => IR,
    clk         => out_pulse,
    IorD        => dout_mem(0),
    MW          => dout_mem(1),
    IW          => dout_mem(2),
    DW          => dout_mem(3),
    Rsrc        => dout_mem(4),
    M2R         => dout_mem(6 downto 5),
    RW          => dout_mem(7),
    AW          => dout_mem(8),
    BW          => dout_mem(9),
    mulSel      => dout_mem(10),
    Asrc1       => dout_mem(11),
    Asrc2       => dout_mem(13 downto 12),
    Fset        => dout_mem(14),
    op          => dout_mem(18 downto 15),
    ReW         => dout_mem(19),
    WadSrc      => dout_mem(21 downto 20),
    R1src       => dout_mem(23 downto 22),
    op1sel      => dout_mem(24),
    SType       => dout_mem(26 downto 25),
    ShiftAmtSel => dout_mem(27),
    Shift       => dout_mem(28),
    MulW        => dout_mem(29),
    ShiftW      => dout_mem(30),
    op1update   => dout_mem(31),
    HTRANS      => HTRANS,
    HWRITE      => HWRITE,
    HREADY      => HREADY_temp);

  DP_inst : Datapath port map(
    clock   => out_pulse,
    reset   => BTN(4),
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

    HWDATA => HWDATA,
    HRDATA => HRDATA,
    HADDR => HADDR,

    WadSrc      => dout_mem(21 downto 20),
    R1src       => dout_mem(23 downto 22),
    op1sel      => dout_mem(24),
    SType       => dout_mem(26 downto 25),
    ShiftAmtSel => dout_mem(27),
    Shift       => dout_mem(28),
    MulW        => dout_mem(29),
    ShiftW      => dout_mem(30),
    op1update   => dout_mem(31),



    ALUout_sig   => ALUout,
    ALUoutp_sig  => ALUoutp,
    op1f_sig     => op1f,
    op2f_sig     => op2f,
    shifted_sig  => shifted,
    shiftedp_sig => shiftedp,
    rd1p_sig     => rd1p,
    rd2p_sig     => rd2p,
    PC_sig       => PC,
    rad1_sig     => rad1,
    rad2_sig     => rad2,
    wad_sig      => wad,
    wd_sig       => wd,
    ad2_sig      => ad2,
    rd2p2_sig    => rd2p2,
    rd_temp_sig  => rd_temp,
    rd_sig       => rd,
    op1_sig      => op1,
    op2_sig      => op2,
    op1p_sig     => op1p,
    Samt_sig     => Samt,
    mulp_sig     => mulp,
    mul_sig      => mul);



  mi : Memory_Interface port map(
    HTRANS    => HTRANS,
    MemSelect => MemSelect_temp,
    HADDR     => HADDR,
    HWRITE    => HWRITE,
    HWDATA    => HWDATA,
    clk       => out_pulse,
    HREADYIN  => HREADY_temp,
    HREADYOUT => ReadyMemory,
    HRDATA    => MemoryData,
    HSIZE     => HSIZE,
    reset     => reset,
    dttyper   => dttyper
    );

  Pattern : Cathode_interface port map(
    Position   => Anodes,
    HTRANS     => HTRANS,
    PortSelect => CathodeSelect_temp,
    HWRITE     => HWRITE,
    clk        => out_pulse,
    HREADYIN   => HREADY_temp,
    HREADYOUT  => ReadyCathode,
    HWDATA     => HWDATA,
    Cathodes   => Cathodes
    );

  si : Switches_interface port map(
    HTRANS     => HTRANS,
    PortSelect => SwitchSelect_temp,
    clk        => out_pulse,
    HREADYIN   => HREADY_temp,
    HREADYOUT  => ReadySwitch,
    HRDATA     => SwitchData,
    HWRITE     => HWRITE,
    Switches   => SW
    );

  Position : Anode_interface port map(
    HTRANS     => HTRANS,
    PortSelect => AnodeSelect_temp,
    HWRITE     => HWRITE,
    clk        => out_pulse,
    HREADYIN   => HREADY_temp,
    HREADYOUT  => ReadyAnode,
    HWDATA     => HWDATA,
    Anodes     => Anodes
    );

  li : LEDs_interface port map(
    HTRANS     => HTRANS,
    PortSelect => LEDSelect_temp,
    HWRITE     => HWRITE,
    clk        => out_pulse,
    HREADYIN   => HREADY_temp,
    HREADYOUT  => ReadyCathode,
    HWDATA     => HWDATA,
    LEDs       => LED
    );

  dttyper <= IR(6) & IR(6 downto 5) when dout_mem(2) = '0' else "000";
  --dttyper <= '1' & HSIZE;

  with HADDR select HRDATA <=
    SwitchData                         when "11111111111111111111111111111100",
    "00000000000000000000000000000000" when "11111111111111111111111111111101",
    "00000000000000000000000000000000" when "11111111111111111111111111111110",
    "00000000000000000000000000000000" when "11111111111111111111111111111111",
    MemoryData                         when others;

  with HADDR select HREADY_temp <=
    ReadySwitch  when "11111111111111111111111111111100",
    ReadyLED     when "11111111111111111111111111111101",
    ReadyAnode   when "11111111111111111111111111111110",
    ReadyCathode when "11111111111111111111111111111111",
    ReadyMemory  when others;

  MemSelect_temp     <= '0' when HADDR(31 downto 2) = "111111111111111111111111111111" else '1';
  SwitchSelect_temp  <= '1' when HADDR = "11111111111111111111111111111100"            else '0';
  AnodeSelect_temp   <= '1' when HADDR = "11111111111111111111111111111110"            else '0';
  CathodeSelect_temp <= '1' when HADDR = "11111111111111111111111111111111"            else '0';
  LEDSelect_temp     <= '1' when HADDR = "11111111111111111111111111111101"            else '0';

end architecture;
