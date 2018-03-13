library IEEE;
use IEEE.std_logic_1164.all;


entity Main_Controller is
  port (
    ins_31_28 : in  std_logic_vector(3 downto 0);
    ins_27_26 : in std_logic_vector(1 downto 0) ;
    F         : in  std_logic_vector(3 downto 0);  -- (Flags : Z & N & V & C )
    p         : in std_logic

    IorD         : out  std_logic                   ;
--MR: out std_logic:='0';
    MW           : out  std_logic                   ;
    IW           : out  std_logic                   ;
    DW           : out  std_logic                   ;
    Rsrc         : out  std_logic                   ;
    M2R          : out  std_logic_vector(1 downto 0) ;  --
    RW           : out  std_logic                   ;
    AW           : out  std_logic                   ;
    BW           : out  std_logic                   ;
    Asrc1        : out  std_logic_vector(1 downto 0) ;  --
    Asrc2        : out  std_logic_vector(1 downto 0) ;
    Fset         : out  std_logic                   ;
    op           : out  std_logic_vector(3 downto 0) ;
    ReW          : out  std_logic                   ;

    WadSrc      : out std_logic_vector(1 downto 0) ;
    R1src       : out std_logic_vector(1 downto 0) ;
    op1sel      : out std_logic                   ;
    SType       : out std_logic_vector(1 downto 0) ;
    ShiftAmtSel : out std_logic                   ;
    Shift       : out std_logic                   ;
    MulW        : out std_logic                   ;
    ShiftW      : out std_logic                   ;
    op1update   : out std_logic                   
 );
end entity Main_Controller;

architecture arch of Main_Controller is

TYPE state_type IS (fetch, rdAB, arith,addr,brn,wrRF,wrM,rdM,M2RF,shift,readx,rdM_and_auto_incr_res2RF,wrMRF,addr_rdB); 
SIGNAL state : state_type;

  signal Z, N, V, C :  std_logic;

begin

PROCESS (clk) 
BEGIN
	IF clk’EVENT AND clk = ‘1’ THEN 
		CASE state IS
			WHEN fetch=> 
					IorD  		<= '0';
				--MR: out std_logic:='0';
				--  PW          <= '1';             
				    MW    		<= '0';      
				    IW   		<= '1';      
				    DW    		<= '0';      
				    Rsrc        <= '0'; 
				    M2R         <= "00";   --
				    RW          <= '0';
				    AW          <= '0';                    ;
				    BW          <= '0';
				    Asrc1       <= "00";
				    Asrc2       <= "01";
				    Fset        <= '0' ;                  ;
				    op          <= add ;
				    ReW         <= '0' ;

				    WadSrc      <= "000";
				    R1src       <= "00";
				    op1sel      <= '0';                   ;
				    SType       <= ;
				    ShiftAmtSel <= "00000";
				    Shift       <= '0';
				    MulW        <= '0';
				    ShiftW      <= '0';
				    op1update   <= '0'; 
				state <= rdAB; 
			WHEN rdAB =>
	
				IF (ins_27_26 = "00") THEN 
					state <= arith; 
					IorD  		<= '0';
					--MR: out std_logic:='0';
					--  PW          <= '0';             
				    MW    		<= '0';      
				    IW   		<= '0';      
				    DW    		<= '0';      
				    Rsrc        <= '0'; 
				    M2R         <= "00";   --
				    RW          <= '0';
				    AW          <= '1';                    ;
				    BW          <= '1';
				    Asrc1       <= "00";
				    Asrc2       <= "01";
				    Fset        <= '0' ;                  ;
				    op          <= add ;
				    ReW         <= '0' ;

				    WadSrc      <= "000";
				    R1src       <= "01";
				    op1sel      <= '0';                   ;
				    SType       <= ;
				    ShiftAmtSel <= "00000";
				    Shift       <= '0';
				    MulW        <= '0';
				    ShiftW      <= '0';
				    op1update   <= '0';
				ELSIF (ins_27_26 = "01") THEN state <= addr; 
				ELSIF (ins_27_26 = "10") THEN state <= brn; 
				END IF;
			WHEN arith=>   
				state <= wrRF; 
			WHEN addr => 
				IF (ins_20 = '0') THEN state <= wrM;
				ELSE state <= rdM;
				END IF;
			WHEN wrM => 
				state <= fetch;
			WHEN rdM => 
				state <= M2RF;
			WHEN brn => 
				state <= fetch; 
			WHEN wrRF => 
				state <= fetch;
			WHEN M2RF => 
				state <= fetch;
			WHEN shift =>
				IF (ins_27_26="00") THEN state <=arith ;
				ELSIF(ins_27_26="01") THEN state <= addr_rdB; 
				END IF;
			WHEN readx =>
				state <= shift;
			WHEN rdM_and_auto_incr_res2RF =>
				IF (ins_20 = '0') THEN state <= wrMRF;
				ELSE state <=M2RF;
				END IF;
			WHEN  =>wrMRF
				state <= fetch;
			WHEN  =>addr_rdB
				state <= rdM_and_auto_incr_res2RF;


		END CASE; 
	END IF;
END PROCESS;



end architecture;
