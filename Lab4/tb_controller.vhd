library IEEE;
use IEEE.STD_LOGIC_1164.all;

--The IEEE.std_logic_unsigned contains definitions that allow
--std_logic_vector types to be used with the + operator to instantiate a
--counter.
use IEEE.std_logic_unsigned.all;

entity tb_controller is
  port (SW        : in    std_logic_vector (15 downto 0);
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
end tb_controller;

architecture Behavioral of tb_controller is

  component memory_uart
--  Port ( );
    port(
      CLK          : in  std_logic;
      RST          : in  std_logic;
      UART_TX      : out std_logic;
      UART_RX      : in  std_logic;
      LAST_DATA_RX : out std_logic_vector(7 downto 0);
      ENABLE_TX    : in  std_logic;
      ENABLE_RX    : in  std_logic;
      UART_RX_CNT  : out std_logic_vector(15 downto 0);
      CLK_MEM      : in  std_logic;
      ENA_MEM      : in  std_logic;
      WEA_MEM      : in  std_logic_vector(3 downto 0);
      ADDR_MEM     : in  std_logic_vector(11 downto 0);
      DIN_MEM      : in  std_logic_vector(31 downto 0);
      DOUT_MEM     : out std_logic_vector(31 downto 0)
      );
  end component;


  component Single_clock_cycle is
    port (
      clock     : in  std_logic;
      button    : in  std_logic;
      out_pulse : out std_logic);
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
      op1update   : out std_logic);
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
      rd2p2_sig    : out std_logic_vector(31 downto 0)

      );
  end component;


  signal temp                           : std_logic;
  signal btn_3_d                        : std_logic;
  signal UART_RX_CNT                    : std_logic_vector(15 downto 0);
  signal clk_mem                        : std_logic;
  signal ena_mem                        : std_logic;
  signal wea_mem                        : std_logic_vector(3 downto 0);
  signal addr_mem                       : std_logic_vector(11 downto 0);
  signal din_mem                        : std_logic_vector(31 downto 0);
  signal dout_mem, dout_mem_temp, dshow : std_logic_vector(31 downto 0);
  signal IR                             : std_logic_vector(31 downto 0);
  signal rx_uart                        : std_logic_vector(7 downto 0);
  signal switch_pair                    : std_logic_vector(1 downto 0);
  signal reset_mem                      : std_logic;
  signal Flags_out                      : std_logic_vector(3 downto 0);

  signal ALUout, ALUoutp, op1f, op2f, rd1p, rd2p, shifted, shiftedp, PC, wd, ad2, rd2p2 : std_logic_vector(31 downto 0);
  signal rad1, rad2, wad                                                                : std_logic_vector(3 downto 0);


  signal out_pulse, mulSel : std_logic;
begin


----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--instantiate the processor datapath (written by you) here and then connect the dout_mem signal(32 bits) to your datapath inputs.
--Reset as shown below is to be connected to BTN(4)
--Press BTN(3) for every next input set of signals from memory.
-- Sample connections are shown below
-- LEDs are currently connected to monitor the file transfer from uart to memory

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
    op1update   => dout_mem(31));

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
    rd2p2_sig    => rd2p2

    );




--------------------------------------------------------------------------------------------------------
--CAUTION: DO NOT TOUCH THE CODE PORTION BELOW. The appropriate signals have been already brought out and use them.
--------------------------------------------------------------------------------------------------------


  clk_mem <= CLK;
  ena_mem <= '1';

  btn_input : process(CLK, BTN(4))
  begin
    if (BTN(4) = '1') then
      btn_3_d <= '0';
    elsif (CLK'event and CLK = '1') then
      btn_3_d <= BTN(3);
    end if;
  end process;

--mem_read: process(CLK, BTN(4)) begin
--if (BTN(4) = '1') then
--    addr_mem <= (others => '0');
--    wea_mem <= (others=>'0');
--    din_mem <= (others=>'0');
--elsif (CLK'event and CLK = '1') then
--    if (BTN(3) = '1' and btn_3_d = '0') then
--        addr_mem <= addr_mem + 1;
--    end if;
--end if;
--end process;

  mem_reset : process(CLK, BTN(4))
  begin
    if (BTN(4) = '1') then
      reset_mem <= '1';
      addr_mem  <= "111111111111";
      wea_mem   <= (others => '0');
      din_mem   <= (others => '0');
    elsif (CLK'event and CLK = '1') then
      if(reset_mem = '1') then
        addr_mem <= addr_mem + '1';
        wea_mem  <= "1111";
        if(addr_mem = "111111111110") then
          reset_mem <= '0';
          wea_mem   <= (others => '0');
          addr_mem  <= (others => '0');
        end if;
      elsif (BTN(3) = '1' and btn_3_d = '0') then
        addr_mem <= addr_mem + 1;
      end if;
    end if;
  end process;

  mem_if : memory_uart port map(
    CLK          => CLK,
    RST          => BTN(4),
    UART_TX      => UART_TXD,
    UART_RX      => UART_RXD,
    LAST_DATA_RX => rx_uart,
    ENABLE_TX    => '0',
    ENABLE_RX    => SW(0),
    UART_RX_CNT  => UART_RX_CNT,
    CLK_MEM      => clk_mem,
    ENA_MEM      => ena_mem,
    WEA_MEM      => wea_mem,
    ADDR_MEM     => addr_mem,
    DIN_MEM      => din_mem,
    DOUT_MEM     => dout_mem_temp
    );
  dout_mem <= dout_mem_temp(7 downto 0) & dout_mem_temp(15 downto 8) & dout_mem_temp(23 downto 16) & dout_mem_temp(31 downto 24);


--  process(clk)
--  begin
--  if(rising_edge(clk)) then

--    case SW(15 downto 3) is
--      when "00000000000000" => dshow <= dout_mem;
--      when "00000000000001" => dshow <= ALUout;
--      when "00000000000010" =>dshow  <= ALUoutp;
--      when "00000000000011" => dshow <= op1f;
--      when "00000000000100" => dshow <= op2f;
--      when "00000000000101" => dshow <= shifted;
--      when "00000000000110" => dshow <= shiftedp;
--      when "00000000000111" => dshow <= rd1p;
--      when "00000000001000" => dshow <= rd2p;
--      when "00000000001001" => dshow <= PC;
--      when "00000000001010" => dshow <= "0000000000000000000000000000" & rad1;
--      when "00000000001011" => dshow <= "0000000000000000000000000000" & rad2;
--      when "00000000001100" => dshow <= "0000000000000000000000000000" & wad;
--      when "00000000001101" => dshow <= wd;
--      when "00000000001110" => dshow <= ad2;
--      when others           => dshow <= rd2p2;

--    end case;
--end if;


--  end process;


  with SW(15 downto 3) select dshow <=
    dout_mem                              when "00000000000000",
    ALUout                                when "00000000000001",
    ALUoutp                               when "00000000000010",
    op1f                                  when "00000000000011",
    op2f                                  when "00000000000100",
    shifted                               when "00000000000101",
    shiftedp                              when "00000000000110",
    rd1p                                  when "00000000000111",
    rd2p                                  when "00000000001000",
    PC                                    when "00000000001001",
    "0000000000000000000000000000" & rad1 when "00000000001010",
    "0000000000000000000000000000" & rad2 when "00000000001011",
    "0000000000000000000000000000" & wad  when "00000000001100",
    wd                                    when "00000000001101",
    ad2                                   when "00000000001110",
    IR                                    when "00000000001111",
    rd2p2                                 when others;

  switch_pair <= SW(1) & SW(2);
  with switch_pair select
    LED(7 downto 0) <= dshow(7 downto 0) when ("10"),
    dshow(23 downto 16)                  when ("11"),
    rx_uart                              when others;
  with switch_pair select
    LED(15 downto 8) <= dshow(15 downto 8) when ("10"),
    dshow(31 downto 24)                    when ("11"),
    "00000000"                             when others;



--below is self loopback for debug
--mem_if: memory port map(
--    CLK => CLK,
--    RST => BTN(4),
--    UART_TX => temp,
--    UART_RX => temp
--);
--UART_TXD <= temp;

end Behavioral;
