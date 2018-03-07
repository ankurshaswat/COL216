
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity Datapath is
PORT (
clock,reset : in std_logic:='0';
ins_out : out std_logic_vector(31 downto 0);
F : out std_logic_vector(3 downto 0);
IorD: in std_logic:='0';
MR: in std_logic:='0';
MW: in std_logic:='0';
IW: in std_logic:='0';
DW: in std_logic:='0';
Rsrc: in std_logic:='0';
M2R: in std_logic_vector(1 downto 0):="00";--
RW: in std_logic:='0';
AW: in std_logic:='0';
BW: in std_logic:='0';
Asrc1: in std_logic_vector(1 downto 0):="00";--
Asrc2: in std_logic_vector(1 downto 0):="00";
Fset: in std_logic:='0';
op: in std_logic_vector(3 downto 0):="0000";
ReW: in std_logic:='0';

WadSrc: in std_logic_vector(1 downto 0):="00";
R1src: in std_logic:='0';
op1sel: in std_logic:='0';
SType: in std_logic_vector(1 downto 0):="00";
ShiftAmtSel: in std_logic:='0';
Shift: in std_logic:='0';
MulW: in std_logic:='0';
ShiftW: in std_logic:='0';
op1update: in std_logic:='0'
--carry: in std_logic

);
end Datapath;

architecture struc of Datapath is

component ALU is
PORT (
	Op1 : IN std_logic_vector(31 downto 0);
	Op2 : IN std_logic_vector(31 downto 0);
  opcode : IN std_logic_vector(3 downto 0);
  carry_in  : IN std_logic;
  output1 : OUT std_logic_vector(31 downto 0);
  Z : OUT std_logic;
  N : OUT std_logic;
  C : OUT std_logic;
  V : OUT std_logic);

end component;


component Multiplier is
PORT (
	Op1 : IN std_logic_vector(31 downto 0);
	Op2 : IN std_logic_vector(31 downto 0);
	Result : OUT std_logic_vector(31 downto 0));
end component;


component shifter is
port (
    inp : in std_logic_vector(31 downto 0);
    shift_type : in std_logic_vector(1 downto 0);
    shift_amount : in std_logic_vector(4 downto 0);
    carry : out std_logic;
    out1  : out std_logic_vector(31 downto 0));
end component;

component ProcessorMemoryPath is
PORT (
	FromProcessor : IN std_logic_vector(31 downto 0);
	FromMemory : IN std_logic_vector(31 downto 0);
	DTType : IN std_logic_vector(2 downto 0); -- last 2 bits tell type of tranfer 00 for word 01 for half 10 for byte
	-- bit index 3 tells     0 for zero extension and 1 for sign extension
	ByteOffset : IN std_logic_vector(1 downto 0);
	ToProcessor : OUT std_logic_vector(31 downto 0);
	ToMemory : OUT std_logic_vector(31 downto 0);
	WriteEnable : OUT std_logic_vector(3 downto 0));
end component;


component RegFile is
PORT (
	ReadAddr1 : IN std_logic_vector(3 downto 0);
	ReadAddr2 : IN std_logic_vector(3 downto 0);
	WriteAddr : IN std_logic_vector(3 downto 0);
	Data : IN std_logic_vector(31 downto 0);
  clock  : IN std_logic;
  reset  : IN std_logic;
  WriteEnable  : IN std_logic;
	ReadOut1 : OUT std_logic_vector(31 downto 0);
	ReadOut2 : OUT std_logic_vector(31 downto 0);
	PC : OUT std_logic_vector(31 downto 0));
end component;

component Memory is
PORT( Address:IN std_logic_vector(31 downto 0);
 writeData:IN std_logic_vector(31 downto 0);
  clock : IN std_logic;
    outer:OUT std_logic_vector(31 downto 0);
		MR:IN std_logic;
		reset:in std_logic;
		MW:IN std_logic;
		WriteEnable: in std_logic_vector(3 downto 0));
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
        wd,rdp,op1,op2,rd1p,rd2p,rd1,rd2,ioffset,boffset,ALUout:std_logic_vector(31 downto 0):="00000000000000000000000000000000";
        
        
signal ad:std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal rad1:std_logic_vector(3 downto 0):="0001";
signal rad2:std_logic_vector(3 downto 0):="0010";

signal wad,write_enable_modified:std_logic_vector(3 downto 0):="0000";

signal dttyper:std_logic_vector(2 downto 0):="000";
signal byte_offset:std_logic_vector(1 downto 0):="00";
signal Samt:std_logic_vector(4 downto 0):="00000";


signal carry_out,
        flagTempN,
        flagTempZ,
        flagTempV,
        flagTempC,
        Z,
        V,
        N,
        car_temp,
        C:std_logic:='0';

BEGIN

car_temp<='0';
--zero<='0';

ins_out<=ins;

with IorD select ad<=
PC when '0',
ALUoutp when others;

with Rsrc select rad2<=
ins(3 downto 0) when '0',
ins(15 downto 12) when others;

with M2R select wd<=
rdp when "00",
ALUoutp when "01",
ALUout when others;

with Asrc1 select op1<=
PC when "00",
rd1p when "01",
mulp when others;

with Asrc2 select op2<=
rd1p2 when "00",
"00000000000000000000000000000100" when "01",
ioffset when "10",
boffset when others;
-- 
-- with R1src select rad1 <=
-- 	ins(19 downto 16) when '0',
-- 	ins(11 downto 8) when '1';

-- with PW select wad <=
-- ins_write_add when '0',
-- "1111" when '1';
with R1src select rad1 <=
ins(19 downto 16) when '0',
ins(11 downto 8) when others;

with WadSrc select wad<=
ins(15 downto 12) when "00",
ins (19 downto 16) when "01",
"1111" when others;

-- with mul_slct select rd1p2<=
-- rd1p when '0',
-- mul_resultp when '1';

-- with PW select wd<=
-- wd_temp when '0',
-- ALUout when '1';

with op1sel select op1f<=
op1p when '1',
op1 when others;

with shift select op2f<=
op2 when '0',
shiftedp when others;

with ShiftAmtSel select Samt<=
op1p(4 downto 0) when '0',
ins(8 downto 4) when others;

boffset<= (ins(23)&ins(23)&ins(23)&ins(23)&ins(23)&ins(23)&ins(23 downto 0) &"00") + 4;
ioffset<="00000000000000000000"&ins(11 downto 0);

Alu11 :  ALU
PORT MAP(
	Op1 => op1f,
	Op2 => op2f,
  opcode => op,
  carry_in  => car_temp,
  output1 => ALUout,
  Z => flagTempZ,
  N => flagTempN,
  C => flagTempC,
  V => flagTempV);

--Z<= Ztemp;
--N<= Ntemp;
--V<= Vtemp;
--C<= Ctemp;
F<= Z & N & V & C;

with Fset select Z<=
Z when '0',
flagTempZ when others;
with Fset select C<=
C when '0',
flagTempC when others;
with Fset select N<=
N when '0',
flagTempN when others;
with Fset select V<=
V when '0',
flagTempV when others;

Mult : Multiplier
PORT MAP(
	Op1 => op1,
	Op2 => op2,
	Result => mul);

--ProcMem :  ProcessorMemoryPath
--PORT MAP (
--	FromProcessor => ,
--	FromMemory => ,
--	DTType => ,
--	ByteOffset => ,
--	ToProcessor => ,
--	ToMemory => ,
--	WriteEnable => );

Reg :  RegFile
PORT MAP(
	ReadAddr1 => rad1,
	ReadAddr2 => rad2,
	WriteAddr => wad,
	Data => wd,
  clock  => clock,
  reset  => reset,
  WriteEnable  => RW,
	ReadOut1 => rd1,
	ReadOut2 => rd2,
	PC => PC);

	Mem :Memory Port map(address=>ad2,writeData=>rd2p2,outer=>rd_temp,MR=>MR,MW=>MW,clock=>clock,reset=>reset,WriteEnable => write_enable_modified);

dttyper <= ins(6) & ins(6 downto 5);

--with ins(6 downto 5) select write_enable_modified <=
--"1111" when "00",
--"0101" when "01",
--"

byte_offset <= ad(1 downto 0);
ad2 <= ad(31 downto 2) & "00";


PMPath: ProcessorMemoryPath Port map(
	FromProcessor => rd2p,
	FromMemory => rd_temp,
	DTType => dttyper,--
	ByteOffset => byte_offset,--
	ToProcessor => rd,
	ToMemory => rd2p2,
	WriteEnable => write_enable_modified--
);

	shif: shifter
	PORT MAP(inp=>op2,shift_type=>SType,shift_amount=>Samt,carry=>carry_out,out1=>shifted);

process(clock)
begin
if(rising_edge(clock)) then

    if(IW='0') then
            ins <= ins;
           else
        ins <= rd;
        end if;

    if(DW='0') then
                rdp <= rdp;
               else
            rdp <= rd;
            end if;

    if(AW='0') then
                    rd1p <= rd1p;
                   else
                rd1p <= rd1;
                end if;

    if(BW='0') then
                        rd2p <= rd2p;
                       else
                    rd2p <= rd2;
                    end if;

        if(ReW='0') then
            ALUoutp <= ALUoutp;
           else
        ALUoutp <= ALUout;
        end if;

        if(MulW='0') then
                   mulp<=mulp;
            else
mulp<=mul;
        end if;

          if(op1update='0') then
                        op1p<=op1p;
                 else
            op1p<=op1;
             end if;

        if (shiftW = '0') then
            shiftedp<=shiftedp;
            else
                 shiftedp<=shifted;
            end if;
    end if;
end process;


end struc;
