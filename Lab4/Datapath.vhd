
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
M2R: in std_logic;
Asrc1: in std_logic;
Fset: in std_logic;
ReW: in std_logic;
clock: in std_logic;
op: in std_logic_vector(3 downto 0);
Asrc2: in std_logic_vector(1 downto 0));
--	Op1 : IN std_logic_vector(31 downto 0);
--	Op2 : IN std_logic_vector(31 downto 0);
--	clock : IN std_logic ;
--	Result : OUT std_logic_vector(31 downto 0));
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


--component Multiplier is
--PORT (
--	Op1 : IN std_logic_vector(31 downto 0);
--	Op2 : IN std_logic_vector(31 downto 0);
--	Result : OUT std_logic_vector(31 downto 0));
--end component;


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

--component IM is
--PORT( Address:IN std_logic_vector(31 downto 0);
--    outer:OUT std_logic_vector(31 downto 0));
--   end component;

component Memory is
PORT( Address:IN std_logic_vector(31 downto 0);
 writeData:IN std_logic_vector(31 downto 0);
    outer:OUT std_logic_vector(31 downto 0));
   end component;


--signal PC,ins,rd1,rd,wd,rd2,PCout,op2input,ALUout,branched_offset,PCnew,pc_plus4:std_logic_vector(31 downto 0);
--signal rad2:std_logic_vector(3 downto 0);
--signal flagC,flagZ,flagN,flagV,carry,writeEnable,reset:std_logic;
--signal control_signal1,control_signal2,control_signal3,control_signal4:std_logic;

signal PC,rd,ins,ad,ALUp,wd,rdp,op1,op2,rd1p,rd1,rd2,PCout,ioffset,boffset,ALUout:std_logic_vector(31 downto 0);
signal rad2:std_logic_vector(3 downto 0);
signal carry,flagTempN,flagTempZ,flagTempV,flagTempC,Z,V,N,C,reset:std_logic;

BEGIN

with IorD select ad<=
PC when '0',
ALUp when '1';

with Rsrc select rad2<=
ins(3 downto 0) when '0',
ins(15 downto 12) when '1';

with M2R select wd<=
rdp when '0',
ALUp when '1';

with Asrc1 select op1<=
PC when '0',
rd1p when '1';

with Asrc2 select op2<=
wd when "00",
"00000000000000000000000000000100" when "01",
ioffset when "10",
boffset when "11";


--with control_signal1 select rad2 <=
--ins(3 downto 0) when '0',
--ins(15 downto 12) when '1';

--with control_signal2 select op2input <=
--rd2 when '0',
--"00000000000000000000"&ins(11 downto 0) when '1';

--with control_signal3 select wd<=
--rd when '1',
--ALUout when '0';

boffset<= (ins(23)&ins(23)&ins(23)&ins(23)&ins(23)&ins(23)&ins(23 downto 0) &"00")+4;
ioffset<="00000000000000000000"&ins(11 downto 0);
--with control_signal4 select PCnew<=
--branched_offset when '1',
--pc_plus4 when '0';


Alu11 :  ALU 
PORT MAP(
	Op1 => op1,
	Op2 => op2,
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
--Mul : Multiplier
--PORT MAP(
--	Op1 => ,
--	Op2 => ,
--	Result => );



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
	ReadAddr1 => ins(19 downto 16),	
	ReadAddr2 => rad2,
	WriteAddr => ins(15 downto 12),
	Data => wd,
  clock  => clock,
  reset  => reset,
  WriteEnable  => RW,
	ReadOut1 => rd1,
	ReadOut2 => rd2,
	PC => PCout);



--IM11 : IM Port map(address=>pc,outer=>ins);
--DM11 : DM Port map(address=>ALUout,writeData=>rd2,outer=>rd);
	Mem :Memory Port map(address=>ad,writeData=>wd,outer=>rd);
	
--pc_plus4<=PC + "0100";	

process(clock)
begin
if(rising_edge(clock)) then

    if(PW='0') then 
        PC <= PC;
       else
    PC <= ALUout;
    end if;
    
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
                rdp <= rd1;
                end if;
                
    if(BW='0') then 
                        wd <= wd;
                       else
                    wd <= rd2;
                    end if;
    
        if(ReW='0') then 
            ALUp <= ALUp;
           else
        ALUp <= ALUout;
        end if;
    
    end if;
end process;


end struc;
