LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

ENTITY Testbench IS
  Port ( 
--  SW 			: in  STD_LOGIC_VECTOR (15 downto 0);
--         BTN             : in  STD_LOGIC_VECTOR (4 downto 0);
--         CLK             : in  STD_LOGIC;
--         reset             : in  STD_LOGIC;
         Flags_out:out std_logic_vector(3 downto 0);
         IR : out std_logic_vector(31 downto 0)
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
END Testbench;

ARCHITECTURE behavior OF Testbench IS

    -- Component Declaration for the Unit Under Test (UUT)

component Datapath
PORT (
clock,reset : in std_logic;
ins_out : out std_logic_vector(31 downto 0);
F : out std_logic_vector(3 downto 0);
IorD: in std_logic;
MR: in std_logic;
MW: in std_logic;
IW: in std_logic;
DW: in std_logic;
Rsrc: in std_logic;
M2R: in std_logic_vector(1 downto 0);--
RW: in std_logic;
AW: in std_logic;
BW: in std_logic;
Asrc1: in std_logic_vector(1 downto 0);--
Asrc2: in std_logic_vector(1 downto 0);
Fset: in std_logic;
op: in std_logic_vector(3 downto 0);
ReW: in std_logic;

WadSrc: in std_logic_vector(1 downto 0);
R1src: in std_logic;
op1sel: in std_logic;
SType: in std_logic_vector(1 downto 0);
ShiftAmtSel: in std_logic;
Shift: in std_logic;
MulW: in std_logic;
ShiftW: in std_logic;
op1update: in std_logic
--carry: in std_logic

);
    END COMPONENT;

	signal dout_mem:std_logic_vector(31 downto 0);
	signal CLK,reset :std_logic:='0';
   constant clk_period : time := 10 ps;
BEGIN

	-- Instantiate the Unit Under Test (UUT)
DP_inst : Datapath port map(
        clock => CLK,
        reset => reset,             
        ins_out   => IR,                 
        F     => Flags_out,          
    --    PW    => dout_mem(0),        
        IorD  => dout_mem(0),        
        MR    => dout_mem(1),        
        MW    => dout_mem(2),        
        IW    => dout_mem(3),        
        DW    => dout_mem(4),        
        Rsrc  => dout_mem(5),        
        M2R   => dout_mem(7 downto 6),        
        RW    => dout_mem(8),        
        AW    => dout_mem(9),        
        BW    => dout_mem(10),       
        Asrc1 => dout_mem(12 downto 11),       
        Asrc2 => dout_mem(14 downto 13),
        Fset  => dout_mem(15),        
        op    => dout_mem(19 downto 16),
        ReW   => dout_mem(20),
        
        WadSrc => dout_mem(22 downto 21),
        R1src => dout_mem(23),
        op1sel => dout_mem(24),
        SType => dout_mem(26 downto 25),
        ShiftAmtSel => dout_mem(27),
        Shift => dout_mem(28),
        MulW => dout_mem(29),
        ShiftW => dout_mem(30),
        op1update => dout_mem(31)
                
    );


   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
--		dout_mem <= "00000000000000000000000000000000";
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
		
   end process;
    
 

   -- Stimulus process
   stim_proc: process

--		type intArray is array(0 to 3) of integer;
--		variable cathodeGroundTruth : intArray := (0,1,0,1);
		variable err_cnt : INTEGER := 0;
   begin

		------------------------------------------------------------
      --------------------- TEST CASE 1 ---------------------------
		------------------------------------------------------------

	reset<='1';
	dout_mem <= "00000000000000000000000000000000";

--	sim_mode<='1';
	wait for clk_period;
	reset<='0';
			wait for 300*clk_period;

	wait for clk_period;

	dout_mem <= "00000000000000000000000000001000"; --(IW is high)
    	wait for clk_period;
   dout_mem <= "00010000000000100010000000000000";--(arsc2 = 01 shift=1)

    	wait for clk_period;

----    assert(data = '1') report "Stop bit error";
--    if(data /= '1') then
--       err_cnt := err_cnt +1;
--       report "Test Case 1: Stop bit error ";
--    end if;

--    send <= '0';
--    data_input <= "0000000100000001";

--    wait for 4*clk_period;
--    send <= '1';
--    wait for 2*clk_period;
--    send <= '0';

--    outData <= (others => '0');

----    assert(led="0000000100000001") report "LED outputs don't match";
--    if(led/="0000000100000001") then
--       err_cnt := err_cnt +1;
--       report "Test Case 1: LED outputs don't match";
--    end if;


----    assert(data = '0') report "Start bit error";
--    if(data /= '0') then
--       err_cnt := err_cnt +1;
--       report "Test Case 1: Start bit error before Packet:1";
--    end if;
--    wait for clk_period;

--    collector11 : for i in 0 to 7 loop
--      outData <=  (data) & outData(7 downto 1) ;
--      wait for clk_period;
--    end loop;

----    assert(outData="00000001") report "Incorrect output bits";
--    if(outData /= "00000001") then
--       err_cnt := err_cnt +1;
--       report "Test Case 1: Incorrect 8 output bits of Packet:1";
--    end if;

----    assert(data = '1') report "Incorrect stop bit";
--     if(data /= '1') then
--          err_cnt := err_cnt +1;
--          report "Test Case 1: Incorrect stop bit between Packets";
--     end if;

--    wait for clk_period;

--    outData <= (others => '0');

----    assert(data = '0') report "Start bit error";
--    if(data /= '0') then
--      err_cnt := err_cnt +1;
--      report "Test Case 1: Start bit error Packet:2";
--    end if;

--    wait for clk_period;
--    collector12 : for i in 0 to 7 loop
--      outData <=  (data) & outData(7 downto 1) ;
--      wait for clk_period;
--    end loop;


----    assert(outData="00000001") report "Incorrect output bits";
--    if(outData /= "00000001") then
--       err_cnt := err_cnt +1;
--       report "Test Case 1: Incorrect 8 output bits of Packet:2";
--    end if;

----    assert(data = '1') report "Incorrect stop bit";
--     if(data /= '1') then
--         err_cnt := err_cnt +1;
--         report "Test Case 1: Incorrect stop bit after both packets";
--        end if;

--    wait for 3*clk_period;

--    if((data='1')and(err_cnt=0)) then
--        report "Test Case 1 succesfully cleared";
--        success<='1';
--    else
--        err_cnt:=err_cnt +1;
--        report "Test Case 1: Incorrect stop bit sometime after";
--    end if;

--    wait for 3*clk_period;
--    success <= '0';











    
	------------------------------------------------------------
      --------------------- TEST CASES COMPLETED ---------------------------
        ------------------------------------------------------------

    
		if (err_cnt=0) then
--			 assert false
			 report "Testbench of Datapath completed successfully!";
			--  severity note;
		else
--			 assert false
			 report "Something wrong, try again";
		-- 	 severity error;
		end if;
    --
    report "TEST BENCH MADE BY SHASHWAT SHIVAM (2016CS10328)";
		 wait for clk_period*10;

       wait;
   end process;

END;
