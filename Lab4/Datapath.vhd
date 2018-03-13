
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity Datapath is
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
    Asrc1        : in  std_logic_vector(1 downto 0) := "00";  --
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
end Datapath;

architecture struc of Datapath is

  component ALU is
    port (
      Op1      : in  std_logic_vector(31 downto 0);
      Op2      : in  std_logic_vector(31 downto 0);
      opcode   : in  std_logic_vector(3 downto 0);
      carry_in : in  std_logic;
      output1  : out std_logic_vector(31 downto 0);
      Z        : out std_logic;
      N        : out std_logic;
      C        : out std_logic;
      V        : out std_logic);

  end component;


  component Multiplier is
    port (
      Op1    : in  std_logic_vector(31 downto 0);
      Op2    : in  std_logic_vector(31 downto 0);
      Result : out std_logic_vector(31 downto 0));
  end component;


  component shifter is
    port (
      inp          : in  std_logic_vector(31 downto 0);
      shift_type   : in  std_logic_vector(1 downto 0);
      shift_amount : in  std_logic_vector(4 downto 0);
      carry        : out std_logic;
      out1         : out std_logic_vector(31 downto 0));
  end component;

  component ProcessorMemoryPath is
    port (
      FromProcessor : in  std_logic_vector(31 downto 0);
      FromMemory    : in  std_logic_vector(31 downto 0);
      DTType        : in  std_logic_vector(2 downto 0);  -- last 2 bits tell type of tranfer 00 for word 01 for half 10 for byte
      -- bit index 3 tells     0 for zero extension and 1 for sign extension
      ByteOffset    : in  std_logic_vector(1 downto 0);
      ToProcessor   : out std_logic_vector(31 downto 0);
      ToMemory      : out std_logic_vector(31 downto 0);
      WriteEnable   : out std_logic_vector(3 downto 0));
  end component;


  component RegFile is
    port (
      ReadAddr1   : in  std_logic_vector(3 downto 0);
      ReadAddr2   : in  std_logic_vector(3 downto 0);
      WriteAddr   : in  std_logic_vector(3 downto 0);
      Data        : in  std_logic_vector(31 downto 0);
      clock       : in  std_logic;
      reset       : in  std_logic;
      WriteEnable : in  std_logic;
      ReadOut1    : out std_logic_vector(31 downto 0);
      ReadOut2    : out std_logic_vector(31 downto 0);
      PC          : out std_logic_vector(31 downto 0));
  end component;

  component Memory is
    port(Address     : in  std_logic_vector(31 downto 0);
         writeData   : in  std_logic_vector(31 downto 0);
         clock       : in  std_logic;
         outer       : out std_logic_vector(31 downto 0);
         MR          : in  std_logic;
         reset       : in  std_logic;
         MW          : in  std_logic;
         WriteEnable : in  std_logic_vector(3 downto 0));
  end component;

  signal mul,
    mulp,
    op1f,
    op2f,
    shifted,
    shiftedp,
    op1p,
    rd1p2,
    rd2p2,
    PC,
    rd,
    rd_temp,
    ad2,
    ins,
    ALUoutp,
    wd, rdp, op1, op2, rd1p, rd2p, rd1, rd2, ioffset, boffset, ALUout : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";


  signal ad   : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal rad1 : std_logic_vector(3 downto 0)  := "0001";
  signal rad2 : std_logic_vector(3 downto 0)  := "0010";

  signal wad, write_enable_modified : std_logic_vector(3 downto 0) := "0000";

  signal dttyper     : std_logic_vector(2 downto 0) := "000";
  signal byte_offset : std_logic_vector(1 downto 0) := "00";
  signal Samt        : std_logic_vector(4 downto 0) := "00000";


  signal carry_out,
    flagTempN,
    flagTempZ,
    flagTempV,
    flagTempC,
    Z,
    V,
    N,
    car_temp,
    C :std_logic := '0';

begin



  ALUout_sig   <= ALUout;
  ALUoutp_sig  <= ALUoutp;
  op1f_sig     <= op1f;
  op2f_sig     <= op2f;
  shifted_sig  <= shifted;
  shiftedp_sig <= shiftedp;
  rd1p_sig     <= rd1p;
  rd2p_sig     <= rd2p;
  PC_sig       <= PC;
  rad1_sig     <= rad1;
  rad2_sig     <= rad2;
  wad_sig      <= wad;
  wd_sig       <= wd;
  ad2_sig      <= ad2;
  rd2p2_sig    <= rd2p2;

  car_temp <= '0';

  ins_out <= ins;

  boffset <= (ins(23)&ins(23)&ins(23)&ins(23)&ins(23)&ins(23)&ins(23 downto 0) &"00") + 4;
  ioffset <= "00000000000000000000"&ins(11 downto 0);

  F <= Z & N & V & C;

  dttyper     <= ins(6) & ins(6 downto 5);
  byte_offset <= ad(1 downto 0);
  ad2         <= ad(31 downto 2) & "00";

  with IorD select ad <=
    PC      when '0',
    ALUoutp when others;

  with Rsrc select rad2 <=
    ins(3 downto 0)   when '0',
    ins(15 downto 12) when others;

  with M2R select wd <=
    rdp     when "00",
    ALUoutp when "01",
    ALUout  when others;

  with Asrc1 select op1 <=
    PC   when "00",
    rd1p when "01",
    mulp when others;

  with Asrc2 select op2 <=
    rd1p2                              when "00",
    "00000000000000000000000000000100" when "01",
    ioffset                            when "10",
    boffset                            when others;

  with R1src select rad1 <=
    ins(19 downto 16) when "00",
    ins(11 downto 8)  when "01",
    ins(15 downto 12) when others;

  with WadSrc select wad <=
    ins(15 downto 12)  when "00",
    ins (19 downto 16) when "01",
    "1111"             when others;

  with op1sel select op1f <=
    op1p when '1',
    op1  when others;

  with shift select op2f <=
    op2      when '0',
    shiftedp when others;

  with ShiftAmtSel select Samt <=
    op1p(4 downto 0) when '0',
    ins(8 downto 4)  when others;

  Alu11 : ALU
    port map(
      Op1      => op1f,
      Op2      => op2f,
      opcode   => op,
      carry_in => C,
      output1  => ALUout,
      Z        => flagTempZ,
      N        => flagTempN,
      C        => flagTempC,
      V        => flagTempV);

  with Fset select Z <=
    Z when '0',
    flagTempZ when others;
  with Fset select C <=
    C when '0',
    flagTempC when others;
  with Fset select N <=
    N when '0',
    flagTempN when others;
  with Fset select V <=
    V when '0',
    flagTempV when others;

  Mult : Multiplier
    port map(
      Op1    => op1,
      Op2    => op2,
      Result => mul);

  Reg : RegFile
    port map(
      ReadAddr1   => rad1,
      ReadAddr2   => rad2,
      WriteAddr   => wad,
      Data        => wd,
      clock       => clock,
      reset       => reset,
      WriteEnable => RW,
      ReadOut1    => rd1,
      ReadOut2    => rd2,
      PC          => PC);

  Mem : Memory port map(address => ad2, writeData => rd2p2, outer => rd_temp, MR => '1', MW => MW, clock => clock, reset => reset, WriteEnable => write_enable_modified);

  PMPath : ProcessorMemoryPath port map(
    FromProcessor => rd2p,
    FromMemory    => rd_temp,
    DTType        => dttyper,               --
    ByteOffset    => byte_offset,           --
    ToProcessor   => rd,
    ToMemory      => rd2p2,
    WriteEnable   => write_enable_modified  --
    );

  shif : shifter
    port map(inp => op2, shift_type => SType, shift_amount => Samt, carry => carry_out, out1 => shifted);

  process(clock)
  begin
    if(rising_edge(clock)) then

      if(IW = '0') then
        ins <= ins;
      else
        ins <= rd;
      end if;

      if(DW = '0') then
        rdp <= rdp;
      else
        rdp <= rd;
      end if;

      if(AW = '0') then
        rd1p <= rd1p;
      else
        rd1p <= rd1;
      end if;

      if(BW = '0') then
        rd2p <= rd2p;
      else
        rd2p <= rd2;
      end if;

      if(ReW = '0') then
        ALUoutp <= ALUoutp;
      else
        ALUoutp <= ALUout;
      end if;

      if(MulW = '0') then
        mulp <= mulp;
      else
        mulp <= mul;
      end if;

      if(op1update = '0') then
        op1p <= op1p;
      else
        op1p <= op1;
      end if;

      if (shiftW = '0') then
        shiftedp <= shiftedp;
      else
        shiftedp <= shifted;
      end if;
    end if;
  end process;


end struc;
