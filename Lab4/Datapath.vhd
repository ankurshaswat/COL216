
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity Datapath is
PORT (
PW: in std_logic;
IorD: in std_logic;
MR: in std_logic;
MW: in std_logic;
RW: in std_logic;
AW: in std_logic;
BW: in std_logic;
DW: in std_logic;
IW: in std_logic;
Rsrc: in std_logic;
PrevW: in std_logic;
SType: in std_logic_vector(1 downto 0);
M2R: in std_logic;
shift_amount_select: in std_logic;
Shift: in std_logic;
Asrc1: in std_logic;
Fset: in std_logic;
ReW: in std_logic;
clock: in std_logic;
MulW: in std_logic;
shiftedForward: in std_logic;
mul_slct: in std_logic;
op: in std_logic_vector(3 downto 0);
Asrc2: in std_logic_vector(1 downto 0));
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

--component ProcessorMemoryPath is
--PORT (
--	FromProcessor : IN std_logic_vector(31 downto 0);
--	FromMemory : IN std_logic_vector(31 downto 0);
--	DTType : IN std_logic_vector(2 downto 0); -- last 2 bits tell type of tranfer 00 for word 01 for half 10 for byte 
--	-- bit index 3 tells     0 for zero extension and 1 for sign extension 
--	ByteOffset : IN std_logic_vector(1 downto 0);
--	ToProcessor : OUT std_logic_vector(31 downto 0);
--	ToMemory : OUT std_logic_vector(31 downto 0);
--	WriteEnable : OUT std_logic_vector(3 downto 0));
--end component;


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
    outer:OUT std_logic_vector(31 downto 0));
   end component;

signal shift_amount,op1f,op2f,shifted,shiftedp,op1p,rd1p2,mul_resultp,mul_result,wd_temp,PC,rd,ins,ad,wad,ALUp,wd,rdp,op1,op2,rd1p,rd2p,rd1,rd2,PCout,ioffset,boffset,ALUout:std_logic_vector(31 downto 0);
signal ins_write_add,rad2,mul_rd:std_logic_vector(3 downto 0);
signal carry,flagTempN,flagTempZ,flagTempV,flagTempC,Z,V,N,C,reset,zero:std_logic;

BEGIN

zero<='0';

with IorD select ad<=
PC when '0',
ALUp when '1';

with Rsrc select rad2<=
ins(3 downto 0) when '0',
ins(15 downto 12) when '1';

with M2R select wd_temp<=
rdp when '0',
ALUp when '1';

with Asrc1 select op1<=
PC when '0',
rd1p when '1';

with Asrc2 select op2<=
rd1p2 when "00",
"00000000000000000000000000000100" when "01",
ioffset when "10",
boffset when "11";

with mul_slct select mul_rd <=
	ins(19 downto 16) when '0',
	ins(11 downto 8) when '1';

with PW select wad <=
ins_write_add when '0',
"1111" when '1';

with mul_slct select ins_write_add<=
ins(15 downto 12) when '0',
ins (19 downto 16) when '1';

with mul_slct select rd1p2<=
rd1p when '0',
mul_resultp when '1';

with PW select wd<=
wd_temp when '0',
ALUout when '1';

with PrevW select op1f<=
op1p when '1',
op1 when '0';

with shift select op2f<=
op2 when '0',
shiftedp when '1';

with shift_amount_select select shift_amount<=
op1p when '0',
ins(11 downto 4) when '1';

boffset<= (ins(23)&ins(23)&ins(23)&ins(23)&ins(23)&ins(23)&ins(23 downto 0) &"00")+4;
ioffset<="00000000000000000000"&ins(11 downto 0);

Alu11 :  ALU 
PORT MAP(
	Op1 => op1f,
	Op2 => op2f,
  opcode => op,
  carry_in  => carry,
  output1 => ALUout,
  Z => flagTempZ,
  N => flagTempN,
  C => flagTempC,
  V => flagTempV);

with Fset select Z<=
Z when '0',
flagTempZ when '1';

Mul : Multiplier
PORT MAP(
	Op1 => rd1p,
	Op2 => rd2p,
	Result => mul_result);

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
	ReadAddr1 => mul_rd,	
	ReadAddr2 => rad2,
	WriteAddr => wad,
	Data => wd,
  clock  => clock,
  reset  => reset,
  WriteEnable  => RW,
	ReadOut1 => rd1,
	ReadOut2 => rd2,
	PC => PC);

	Mem :Memory Port map(address=>ad,writeData=>rd2p,outer=>rd);
	
	shif: shifter
	PORT MAP(inp=>op2,shift_type=>SType,shift_amount=>shift_amount,carry=>zero,out1=>shifted);
	
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
            ALUp <= ALUp;
           else
        ALUp <= ALUout;
        end if;
    
        if(MulW='0') then
                   mul_resultp<=mul_resultp;  
            else
       mul_resultp<=mul_result;  
        end if;
       
          if(PrevW='0') then
                        op1p<=op1p;  
                 else
            op1p<=op1;  
             end if;
        
        if (shiftedForward = '0') then 
            shiftedp<=shiftedp;
            else
                 shiftedp<=shifted;
            end if;
    end if;
end process;


end struc;
