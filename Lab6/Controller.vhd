library IEEE;
use IEEE.std_logic_1164.all;


entity Controller is
  port (
    ins         : in  std_logic_vector(31 downto 0):="00000000000000000000000000000000";
    clk         : in  std_logic:='0';
    IorD        : out std_logic:='0';
    MW          : out std_logic:='0';
    IW          : out std_logic:='0';
    DW          : out std_logic:='0';
    Rsrc        : out std_logic:='0';
    M2R         : out std_logic_vector(1 downto 0):="00";  --
    RW          : out std_logic:='0';
    AW          : out std_logic:='0';
    BW          : out std_logic:='0';
    mulSel      : out std_logic:='0';
    Asrc1       : out std_logic:='0';                     --
    Asrc2       : out std_logic_vector(1 downto 0):="00";
    Fset        : out std_logic:='0';
    op          : out std_logic_vector(3 downto 0):="0000";
    ReW         : out std_logic:='0';
    WadSrc      : out std_logic_vector(1 downto 0):="00";
    R1src       : out std_logic_vector(1 downto 0):="00";
    op1sel      : out std_logic:='0';
    SType       : out std_logic_vector(1 downto 0):="00";
    ShiftAmtSel : out std_logic:='0';
    Shift       : out std_logic:='0';
    MulW        : out std_logic:='0';
    ShiftW      : out std_logic:='0';
    op1update   : out std_logic:='0';
        HTRANS : out std_logic:='0';
    HWRITE : out std_logic:='0';
    HREADY:in std_logic:='0');
end entity Controller;

architecture arch of Controller is

  component instructionDecoder is

    port (
      ins        : in  std_logic_vector(27 downto 0);
      class      : out std_logic_vector(1 downto 0);
      sub_class  : out std_logic_vector(3 downto 0);
      variant    : out std_logic_vector(1 downto 0);
      ins_status : out std_logic_vector(1 downto 0));

  end component;


  component Bctrl is
    port (
      ins_31_28 : in  std_logic_vector(3 downto 0);
      F         : in  std_logic_vector(3 downto 0);  -- (Flags : Z & N & V & C )
      p         : out std_logic);
  end component;

  component Actrl is
    port (
      ins        : in  std_logic_vector(27 downto 0);
      class      : in  std_logic_vector(1 downto 0);
      sub_class  : in  std_logic_vector(3 downto 0);
      variant    : in  std_logic_vector(1 downto 0);
      ins_status : in  std_logic_vector(1 downto 0);
      op         : out std_logic_vector(3 downto 0));
  end component;

  component Main_Controller is
    port (
      decoded_op : in std_logic_vector;
      ins_20     : in std_logic;
      ins_31_28  : in std_logic_vector(3 downto 0);
      ins_27_26  : in std_logic_vector(1 downto 0);
      ins_27_20  : in std_logic_vector(7 downto 0);
      ins_7_4    : in std_logic_vector(3 downto 0);
      F          : in std_logic_vector(3 downto 0);  -- (Flags : Z & N & V & C )
      p          : in std_logic;
      clk        : in std_logic;
      class      : in std_logic_vector(1 downto 0);
      sub_class  : in std_logic_vector(3 downto 0);
      variant    : in std_logic_vector(1 downto 0);
      ins_status : in std_logic_vector(1 downto 0);
      --CONTROL SIGNALS
      --------------

      IorD   : out std_logic;
      --MR: out std_logic:='0';
      MW     : out std_logic;
      IW     : out std_logic;
      DW     : out std_logic;
      Rsrc   : out std_logic;
      M2R    : out std_logic_vector(1 downto 0);  --
      RW     : out std_logic;
      AW     : out std_logic;
      BW     : out std_logic;
      mulSel : out std_logic;
      Asrc1  : out std_logic;                     --
      Asrc2  : out std_logic_vector(1 downto 0);
      Fset   : out std_logic;
      op     : out std_logic_vector(3 downto 0);
      ReW    : out std_logic;

      WadSrc      : out std_logic_vector(1 downto 0);
      R1src       : out std_logic_vector(1 downto 0);
      op1sel      : out std_logic;
      SType       : out std_logic_vector(1 downto 0);
      ShiftAmtSel : out std_logic;
      Shift       : out std_logic;
      MulW        : out std_logic;
      ShiftW      : out std_logic;
      op1update   : out std_logic;
          HTRANS : out std_logic;
      HWRITE : out std_logic;
      HREADY:in std_logic
      );
  end component;

  signal class      : std_logic_vector(1 downto 0):="00";
  signal sub_class  : std_logic_vector(3 downto 0):="0000";
  signal variant    : std_logic_vector(1 downto 0):="00";
  signal ins_status : std_logic_vector(1 downto 0):="00";



--    signal ins:std_logic_vector(31 downto 0);
--    signal op:std_logic_vector(3 downto 0);
  signal F          : std_logic_vector(3 downto 0):="0000";
  signal p_received : std_logic:='0';
  -- signal Z, N, V, C :  std_logic;
  signal op_temp    : std_logic_vector(3 downto 0):="0000";
begin

  id : instructionDecoder port map(ins => ins(27 downto 0), class => class, sub_class => sub_class, ins_status => ins_status, variant => variant);

  a1 : Actrl port map(ins => ins(27 downto 0), op => op_temp, class => class, sub_class => sub_class, ins_status => ins_status, variant => variant);

  b1 : Bctrl port map(ins_31_28 => ins(31 downto 28), F => F, p => p_received);

  mc : Main_Controller port map(
    class       => class, sub_class => sub_class, ins_status => ins_status, variant => variant,
    decoded_op  => op_temp,
    ins_20      => ins(20),
    ins_31_28   => ins(31 downto 28),
    ins_27_26   => ins(27 downto 26),
    ins_27_20   => ins(27 downto 20),
    ins_7_4     => ins(7 downto 4),
    F           => F,
    p           => p_received,
    clk         => clk,
    IorD        => IorD,
    MW          => MW,
    IW          => IW,
    DW          => DW,
    Rsrc        => Rsrc,
    M2R         => M2R,
    RW          => RW,
    AW          => AW,
    BW          => BW,
    mulSel      => mulSel,
    Asrc1       => Asrc1,
    Asrc2       => Asrc2,
    Fset        => Fset,
    op          => op,
    ReW         => ReW,
    WadSrc      => WadSrc,
    R1src       => R1src,
    op1sel      => op1sel,
    SType       => SType,
    ShiftAmtSel => ShiftAmtSel,
    Shift       => Shift,
    MulW        => MulW,
    ShiftW      => ShiftW,
    op1update   => op1update,
        HTRANS => HTRANS,
    HWRITE =>HWRITE,
    HREADY => HREADY
    );

end architecture;
