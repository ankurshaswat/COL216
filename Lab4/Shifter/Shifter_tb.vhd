LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Shifter_tb IS
END Shifter_tb;

ARCHITECTURE behavior OF Shifter_tb IS 

component shifter is
port (
    inp : in std_logic_vector(31 downto 0);
    shift_type : in std_logic_vector(1 downto 0);
    shift_amount : in std_logic_vector(4 downto 0);
    carry : out std_logic;
    out1  : out std_logic_vector(31 downto 0));
end component;


   --Inputs
   signal op2 : std_logic_vector(31 downto 0) := (others => '0');
   signal SType : std_logic_vector(1 downto 0) := (others => '0');
   signal Samt : std_logic_vector(4 downto 0) := (others => '0');
   signal clk : std_logic := '0';

   -- Outputs
   signal shifted : std_logic_vector(31 downto 0) ;
   signal carry_out : std_logic;
    constant clk_period : time := 10 ns;
	signal err_cnt_signal : integer := 0;


BEGIN 
	uut: shifter
	PORT MAP(inp=>op2,shift_type=>SType,shift_amount=>Samt,carry=>carry_out,out1=>shifted);

   -- Clock process definitions

  clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;


    stim_proc: process
		variable err_cnt : INTEGER := 0;
   begin		
   	------------------------------------------------------------
      --------------------- pre-case 0 ---------------------------
		------------------------------------------------------------
		
		-- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication
	
		-- Set inputs
		op2 <= "00000000000000000000000000000001";
		SType <= "00";
		Samt <= "00001"; 
		wait for clk_period;
		
      -------------------------------------------------------------
		---------------------  case 0 -------------------------------
		-------------------------------------------------------------
		
		
		assert (shifted = "00000000000000000000000000000010") report "Error:  Shift by the shifter00  is wrong";
		if (shifted /= "00000000000000000000000000000010") then
			err_cnt := err_cnt + 1;
		end if;

		assert (carry_out = '0') report "Error:  Shift by the shifter0  is wrong";
		if (carry_out /= '0') then
			err_cnt := err_cnt + 1;
		end if;
    
 	------------------------------------------------------------
      --------------------- pre-case 1 ---------------------------
		------------------------------------------------------------
		
		-- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication
	
		-- Set inputs
		op2 <= "00000000000000000000000000000001";
		SType <= "01";
		Samt <= "00001"; 
		wait for clk_period;
		
      -------------------------------------------------------------
		---------------------  case 1 -------------------------------
		-------------------------------------------------------------
		
		
		assert (shifted = "00000000000000000000000000000000") report "Error:  Shift by the shifter 01 is wrong";
		if (shifted /= "00000000000000000000000000000000") then
			err_cnt := err_cnt + 1;
		end if;

		assert (carry_out = '1') report "Error:  Shift by the shifter1  is wrong";
		if (carry_out /= '1') then
			err_cnt := err_cnt + 1;
		end if;	

		 	------------------------------------------------------------
      --------------------- pre-case 2 ---------------------------
		------------------------------------------------------------
		
		-- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication
	
		-- Set inputs
		op2 <= "10000000000000000000000000000001";
		SType <= "10";
		Samt <= "00010"; 
		wait for clk_period;
		
      -------------------------------------------------------------
		---------------------  case 2 -------------------------------
		-------------------------------------------------------------
		
		
		assert (shifted = "11100000000000000000000000000000") report "Error:  Shift by the shifter02  is wrong";
		if (shifted /=    "11100000000000000000000000000000") then
			err_cnt := err_cnt + 1;
		end if;

		assert (carry_out = '0') report "Error:  Shift by the shifter2  is wrong";
		if (carry_out /= '0') then
			err_cnt := err_cnt + 1;
		end if;


		 	------------------------------------------------------------
      --------------------- pre-case 3 ---------------------------
		------------------------------------------------------------
		
		-- Set clock to be fast, initialize in1=01,in2=23 and initiate multiplication
	
		-- Set inputs
		op2 <= "10000000000000000000000000000001";
		SType <= "11";
		Samt <= "11111"; 
		wait for clk_period;
		
      -------------------------------------------------------------
		---------------------  case 3 -------------------------------
		-------------------------------------------------------------
		
		
		assert (shifted = "00000000000000000000000000000011") report "Error:  Shift by the shifter03  is wrong";
		if (shifted /=    "00000000000000000000000000000011") then
			err_cnt := err_cnt + 1;
		end if;

		assert (carry_out = '0') report "Error:  Shift by the shifter3  is wrong";
		if (carry_out /= '0') then
			err_cnt := err_cnt + 1;
		end if;
		-------------------------add more test cases---------------------------------------------
		
		err_cnt_signal <= err_cnt;		
		-- summary of all the tests
		if (err_cnt=0) then
			 assert false
			 report "Testbench of Shifter completed successfully!"
			 severity note;
		else
			 assert false
			 report "Something wrong, try again"
			 severity error;
		end if;

      -- end of tb 
		wait for clk_period*100;

      wait;


   end process;

END ARCHITECTURE;