library IEEE;
use IEEE.std_logic_1164.all;


entity Actrl is
  port (
    ins : in  std_logic_vector(27 downto 0);
    op  : out std_logic_vector(3 downto 0));
end entity Actrl;

architecture arch of Actrl is

  component instructionDecoder is

    port (
      ins        : in  std_logic_vector(27 downto 0);
      class      : out std_logic_vector(3 downto 0);
      sub_class  : out std_logic_vector(3 downto 0);
      -- variant  : out std_logic_vector(1 downto 0);
      ins_status : out std_logic_vector(3 downto 0));

  end component;

  signal class : std_logic_vector(1 downto 0);
  -- 00 = DP, 01 = DT, 10 = MUL, 11=B

  signal sub_class : std_logic_vector(3 downto 0);
  -- For DT 0000=ldr,0001=ldrh,0010=ldrb,0011=ldrsh,0100=ldrsb
  -- For DT 1000=str,1001=strh,1010=strb,1011=strsh,1100=strsb

  signal variant : std_logic_vector(1 downto 0);
  -- 00 = imm, 01 = reg_imm, others = reg_reg

  signal ins_status : std_logic_vector(1 downto 0);
  -- 00=undefined , 01=unimplemented , others = implemented

  -- signal ins : std_logic_vector(31 downto 0);

  signal ldr_str, mul, mla, b_bl : std_logic;

begin

  instructionDecoder port map(ins => ins, class => class, sub_class => sub_class, ins_status => ins_status);
  -- ins <= "0000" & ins_27_0;

  op <= "0100" when (class = "01" and ins(23) = '1') or (class = "11") or (class = "10" and sub_class = "001") else
        "0010" when (clas = "01" and ins(23) = '0') else
        "1101" when (class = "10" and sub_class = "000") else
        ins(24 downto 21);

end architecture;
