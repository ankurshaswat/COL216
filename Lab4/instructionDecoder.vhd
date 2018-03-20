library IEEE;
use IEEE.std_logic_1164.all;

--needs ins 27-20 and 11-4
entity instructionDecoder is

  port (
    ins        : in  std_logic_vector(27 downto 0);
    class      : out std_logic_vector(3 downto 0);
    sub_class  : out std_logic_vector(3 downto 0);
    -- variant  : out std_logic_vector(1 downto 0);
    ins_status : out std_logic_vector(3 downto 0));

end entity instructionDecoder;

architecture arch of instructionDecoder is

  signal class_temp : std_logic_vector(1 downto 0);
  -- -- 00 = DP, 01 = DT, 10 = MUL, 11=B

  signal sub_class_MUL : std_logic_vector(3 downto 0) := "0000";
  --- 0=mul,others=mla

  signal sub_class_DP : std_logic_vector(3 downto 0) := "0000";
  -- -- For DP 0=arith,1=logic,others=test

  signal sub_class_DT : std_logic_vector(3 downto 0) := "0000";
  -- -- For DT 0000=ldr,0001=ldrh,0010=ldrb,0011=ldrsh,0100=ldrsb
  -- -- For DT 1000=str,1001=strh,1010=strb,1011=strsh,1100=others=strsb

  signal sub_class_B : std_logic_vector(3 downto 0) := "0000";
  -- 0=b , others= bl

  -- signal variant : std_logic_vector(1 downto 0);
  -- -- 00 = imm, 01 = reg_imm, others = reg_reg

  
  --  
  -- signal ins_status : std_logic_vector(1 downto 0);
  -- -- 00=undefined , 01=unimplemented , others = implemented



begin

  ins_status_temp <= "01" when ((ins(27 downto 26) = "11")
                                or (ins(27 downto 25) = "100")
                                or (ins(27 downto 25) = "000"
                                    and (ins(11 downto 7)&ins(4) = "111100"
                                         or (ins(7 downto 4) = "1001" and (ins (24) = '1' or ins(24 downto 23) = "01"))))) else
                     "00" when ins(27 downto 25)&ins(4) = "0111" else
                     "10";

  class      <= class_temp;
  class_temp <= "11" when (ins(27 downto 25) = "101") else
                "10" when (ins(27 downto 25) = "000" and ins(7 downto 4) = "1001") else
                "01" when (ins(27 downto 26) = "01") or (ins (27 downto 25) = "000" and ins(7) = '1' and ins(4) = '1' and ins(6 downto 5) /= "00") else
                "00";

  sub_class_DT(3)          <= ins(20);
  sub_class_DT(2 downto 0) <= "000" when (ins(27 downto 26) = "01" and ins(22) = '1') else
                              "010" when (ins(27 downto 26) = "01" and ins(22) = '0') else
                              "001" when (ins(27 downto 26) = "00" and ins(6) = '0' and ins(5) = '1') else
                              "011" when (ins(27 downto 26) = "00" and ins(6) = '1' and ins(5) = '1') else
                              "100";  -- "100" when (ins(27 downto 26) = "00" and ins(6) = '1' and ins(5) = '0') else


  sub_class_MUL <= "000" when ins(21) = '0' else
                   "001";

  sub_class_B <= "000" when ins(24) = '0' else
                 "001";

  with class_temp select sub_class <=
    sub_class_DP  when "00",
    sub_class_DT  when "01",
    sub_class_MUL when "10",
    sub_class_B   when others;

  -- variant <=

  -- sub_class_DP <=;

end architecture;
