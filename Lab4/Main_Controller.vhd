library IEEE;
use IEEE.std_logic_1164.all;


entity Main_Controller is
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
    op1update   : out std_logic
    );
end entity Main_Controller;

architecture arch of Main_Controller is

  type state_type is (fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, wr_from_M2RF, shift_state1, shift_state2 rdM_wrRF, wrM_wrRF, addr_rdB, PC_plus4, rd_mul, mul_ck_MLA, add_MLA, wr_mul );

  signal state : state_type;
  --signal op_temp : std_logic := "0100";
  signal Z, N, V, C : std_logic;

begin

  process (clk)
  begin
    if (rising_edge(clk)) then
      case state is

--------------------------------------------|
        when fetch =>


          IorD  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '0';
          IW    <= '1';
          DW    <= '0';
          Rsrc  <= '0';
          M2R   <= "10";                --
          RW    <= '1';
          AW    <= '0';
          BW    <= '0';
          mulSel <= '0';
          Asrc1 <= '0';
          Asrc2 <= "01";
          Fset  <= '0';
          op    <= "0100";
          ReW   <= '0';

          WadSrc      <= "10";
          R1src       <= "00";
          op1sel      <= '0';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
          state       <= rdAB;
--------------------------------------------|
        when rdAB =>

          if (ins_27_26 = "00") then
            state <= shift_state1;       --state <= arith;
            IorD  <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '0';
            MW    <= '0';
            IW    <= '0';          --- Instruction won't update due to PC+4
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '1';
            BW    <= '1';
            mulSel <= '0';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= decoded_op;
            ReW   <= '0';

            WadSrc      <= "00";
            R1src       <= "00";
            op1sel      <= '0';
            SType       <= "00";
            ShiftAmtSel <= '0';
            Shift       <= '0';
            MulW        <= '0';
            ShiftW      <= '0';
            op1update   <= '0';         -- Store op1 in op1p;
          elsif (ins_27_26 = "01") then

            if (ins_27_20(5) = '0') then
              state <= shift_state1;     --state <= addr;
            else
              state <= addr;
            end if;

            IorD  <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '0';
            MW    <= '0';
            IW    <= '0';   --- Instruction won't update due to PC+4
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '1';
            BW    <= '1';
            mulSel <= '0';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= decoded_op;
            ReW   <= '0';

            WadSrc      <= "00";
            R1src       <= "00";
            op1sel      <= '1';
            SType       <= "00";
            ShiftAmtSel <= '0';
            Shift       <= '0';
            MulW        <= '0';
            ShiftW      <= '0';
            op1update   <= '1';
          elsif (ins_27_20(5) = '1' and ins_7_4(3 downto 0) ="1001") then 
            state <= mul_ck_MLA;       

            IorD  <= '0';
            MW    <= '0';
            IW    <= '0';   --- Instruction won't update due to PC+4
            DW    <= '0';
            Rsrc  <= '1';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '1';
            BW    <= '1';
            --Asrc1 <= "10";
            mulSel <= '0';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= decoded_op;
            ReW   <= '0';

            WadSrc      <= "00";
            R1src       <= "01";
            op1sel      <= '1';
            SType       <= "00";
            ShiftAmtSel <= '0';
            Shift       <= '0';
            MulW        <= '1';
            ShiftW      <= '0';
            op1update   <= '1';
          
          elsif (ins_27_26 = "10") then 


          	state <= brn;
	          IorD  <= '0';
	          --MR: out std_logic:='0';
	          --  PW          <= '1';
	          MW    <= '0';
	          IW    <= '0';
	          DW    <= '1';
	          Rsrc  <= '0';
	          M2R   <= "10";                --
	          RW    <= '1';
	          AW    <= '0';
	          BW    <= '0';
	          --Asrc1 <= "00";
	          mulSel <= '0';
            Asrc1 <= '0';
            Asrc2 <= "01";
	          Fset  <= '0';                 -- p from Bctrl;
	          op    <= decoded_op;              -- op from the Actrl;
	          ReW   <= '1';

	          WadSrc      <= "10";
	          R1src       <= "00";
	          op1sel      <= '0';
	          SType       <= "00";
	          ShiftAmtSel <= '0';
	          Shift       <= '0';
	          MulW        <= '0';
	          ShiftW      <= '0';
	          op1update   <= '0';
          end if;

--------------------------------------------|


        when arith =>
          state <= wrRF;

          IorD  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '0';
          IW    <= '0';
          DW    <= '0';
          Rsrc  <= '0';
          M2R   <= "10";                --
          RW    <= '0';
          AW    <= '0';
          BW    <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1 <= '0';
          Asrc2 <= "00";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= decoded_op;              -- op from the Actrl;
          ReW   <= '1';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '1';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when addr =>
          if (ins_20 = '0') then state <= wrM;
          else state                   <= rdM;
          end if;
          IorD                         <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW                           <= '0';
          IW                           <= '0';
          DW                           <= '0';
          Rsrc                         <= '1';
          M2R                          <= "00";    --
          RW                           <= '0';
          AW                           <= '0';
          BW                           <= '1';
          --Asrc1                        <= "00";
          mulSel <= '0';
          Asrc1 <= '0';
          Asrc2                        <= "10";
          Fset                         <= '0';     -- p from Bctrl;
          op                           <= "0100";
          ReW                          <= '1';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';


--------------------------------------------|
        when wrM =>
          state <= fetch;
          IorD  <= '1';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '1';
          IW    <= '0';
          DW    <= '0';
          Rsrc  <= '0';
          M2R   <= "00";                --
          RW    <= '0';
          AW    <= '0';
          BW    <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
            Asrc1 <= '0';
          Asrc2 <= "00";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= "0100";
          ReW   <= '0';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '1';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when rdM =>
          state <= wr_from_M2RF;
          IorD  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '0';
          IW    <= '0';
          DW    <= '1';
          Rsrc  <= '0';
          M2R   <= "00";                --
          RW    <= '0';
          AW    <= '0';
          BW    <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
            Asrc1 <= '0';
          Asrc2 <= "00";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= "0100";              -- op from the Actrl;
          ReW   <= '0';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '1';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when brn =>
          --;;;  -- we have to do PC =PC + 4 + Offset will take two cycles;
          state <= fetch;
          IorD  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '0';
          IW    <= '0';
          DW    <= '1';
          Rsrc  <= '0';
          M2R   <= "10";                --
          RW    <= '1';
          AW    <= '0';
          BW    <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
            Asrc1 <= '0';
          Asrc2 <= "11";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= "0100";              -- op from the Actrl;
          ReW   <= '1';

          WadSrc      <= "10";
          R1src       <= "00";
          op1sel      <= '0';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when wrRF =>
          state <= fetch;
          IorD  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '0';
          IW    <= '0';
          DW    <= '0';
          Rsrc  <= '0';
          M2R   <= "1";                 --
          RW    <= '1';
          AW    <= '0';
          BW    <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1 <= '0';
          Asrc2 <= "00";
          Fset  <= '0';                 -- depends on p from Bctrl
          op    <= "0100";              -- op from Actrl
          ReW   <= '0';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '0';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';

--------------------------------------------|
        when wr_from_M2RF =>
          state <= fetch;
          IorD  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '0';
          IW    <= '0';
          DW    <= '0';
          Rsrc  <= '0';
          M2R   <= "00";                --
          RW    <= '1';
          AW    <= '0';
          BW    <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1 <= '0';
          Asrc2 <= "00";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= "0100";              -- op from the Actrl;
          ReW   <= '0';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '1';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when shift_state1 =>
          -- read register X = RF[IR[11-8]]; is also done here;
          if (ins_27_26 = "00") then
            state <= shift_state2;

            IorD  <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW    <= '0';
            IW    <= '0';
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '1';
            BW    <= '0';
            --Asrc1 <= "01";
            mulSel <= '0';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= decoded_op;
            ReW   <= '0';

            WadSrc      <= "00";
            R1src       <= "01";
            op1sel      <= '1';
            SType       <= "00";        --- Not sure which bits signal it
            if (ins_27_20(5)='0') then  
              ShiftAmtSel <= '0';   -- register specified
            else
              ShiftAmtSel <= '1';   -- immediate
            end if;
            Shift       <= '1';
            MulW        <= '0';
            ShiftW      <= '0';
            op1update   <= '1';
          elsif(ins_27_26 = "01") then
            state <= shift_state2;
            IorD  <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW    <= '0';
            IW    <= '0';
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '1';
            BW    <= '0';
            --Asrc1 <= "01";
            mulSel <= '0';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= decoded_op;
            ReW   <= '0';

            WadSrc      <= "00";
            R1src       <= "01";
            op1sel      <= '1';
            SType       <= "00";        --- Not sure which bits signal it
            ShiftAmtSel <= '1';         --- ins(11 to 4);
            Shift       <= '1';
            MulW        <= '0';
            ShiftW      <= '1';
            op1update   <= '0';


          end if;

--------------------------------------------|
        when shift_state2 =>
          -- read register X = RF[IR[11-8]]; is also done here;
          if (ins_27_26 = "00") then
            state <= arith;

            IorD  <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW    <= '0';
            IW    <= '0';
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '0';
            BW    <= '0';
            --Asrc1 <= "01";
            mulSel <= '0';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= decoded_op;
            ReW   <= '0';

            WadSrc      <= "00";
            R1src       <= "01";
            op1sel      <= '1';
            SType       <= "00";        --- Not sure which bits signal it
            if (ins_27_20(5)='0') then  
              ShiftAmtSel <= '0';   -- register specified
            else
              ShiftAmtSel <= '1';   -- immediate
            end if;
            Shift       <= '1';
            MulW        <= '0';
            ShiftW      <= '1';
            op1update   <= '0';
          elsif(ins_27_26 = "01") then
            state <= addr_rdB;
            IorD  <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW    <= '0';
            IW    <= '0';
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '1';
            BW    <= '0';
            --Asrc1 <= "01";
            mulSel <= '0';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= decoded_op;
            ReW   <= '0';

            WadSrc      <= "00";
            R1src       <= "01";
            op1sel      <= '1';
            SType       <= "00";        --- Not sure which bits signal it
            ShiftAmtSel <= '1';         --- ins(11 to 4);
            Shift       <= '1';
            MulW        <= '0';
            ShiftW      <= '1';
            op1update   <= '0';


          end if;
--------------------------------------------|
        --when readx =>
        --  state <= shift_state;
--------------------------------------------|
        when rdM_wrRF =>
          state                           <= wr_from_M2RF;
          if (ins_27_20(1) = '1') then RW <= '1';
          else RW                         <= '0';
          end if;

          IorD  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '0';
          IW    <= '0';
          DW    <= '1';
          Rsrc  <= '0';
          M2R   <= "01";                --
          --RW    <= '0';
          AW    <= '0';
          BW    <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
            Asrc1 <= '0';
          Asrc2 <= "00";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= "0100";              -- op from the Actrl;
          ReW   <= '0';

          WadSrc      <= "01";
          R1src       <= "00";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';

--------------------------------------------|
        when wrM_wrRF =>
          state <= fetch;


          -- If W='1' then auto_inc else don't
          if (ins_27_20(1) = '1') then RW <= '1';
          else RW                         <= '0';
          end if;

          IorD  <= '1';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '1';
          IW    <= '0';
          DW    <= '0';
          Rsrc  <= '0';
          M2R   <= "11";                --
          --RW    <= '1';
          AW    <= '0';
          BW    <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1 <= '0';
          Asrc2 <= "00";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= "0100";              -- op from the Actrl;
          ReW   <= '0';

          WadSrc      <= "01";
          R1src       <= "00";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '1';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when addr_rdB =>
          if (ins_27_20(5) = '1') then
            state <= rdM_wrRF;
          else state <= wrM_wrRF;
          end if;
          IorD       <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW         <= '0';
          IW         <= '0';
          DW         <= '0';
          Rsrc       <= '1';
          M2R        <= "00";           --
          RW         <= '0';
          AW         <= '0';
          BW         <= '1';
          --Asrc1      <= "00";
          mulSel <= '0';
          Asrc1 <= '0';
          Asrc2      <= "00";
          Fset       <= '0';            -- p from Bctrl;
          op         <= "0100";
          ReW        <= '1';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '1';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';

--------------------------------------------|
--        when PC_plus4 =>
--          state <= brn;
--          IorD  <= '0';
--          --MR: out std_logic:='0';
--          --  PW          <= '1';
--          MW    <= '0';
--          IW    <= '0';
--          DW    <= '1';
--          Rsrc  <= '0';
--          M2R   <= "10";                --
--          RW    <= '1';
--          AW    <= '0';
--          BW    <= '0';
--          Asrc1 <= "00";
--          Asrc2 <= "01";
--          Fset  <= '0';                 -- p from Bctrl;
--          op    <= "0100";              -- op from the Actrl;
--          ReW   <= '1';

--          WadSrc      <= "10";
--          R1src       <= "00";
--          op1sel      <= '0';
--          SType       <= "00";
--          ShiftAmtSel <= '0';
--          Shift       <= '0';
--          MulW        <= '0';
--          ShiftW      <= '0';
--          op1update   <= '0';
--------------------------------------------|
 		when mul_ck_MLA =>
 			if (ins_27_20(1) = '0') then
 				state <= wr_mul;
 			else state <= add_MLA;
 			end if;
            IorD  <= '0';
            MW    <= '0';
            IW    <= '0';          --- Instruction won't update due to PC+4
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '1';
            BW    <= '0';
            mulSel <= '1';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= "0100";
            ReW   <= '0';

            WadSrc      <= "00";
            R1src       <= "10";
            op1sel      <= '1';
            SType       <= "00";
            ShiftAmtSel <= '0';
            Shift       <= '0';
            MulW        <= '0';
            ShiftW      <= '0';
            op1update   <= '0';
--------------------------------------------|
 		when add_MLA=>
 			state <= wr_mul;
 			IorD  <= '0';
            MW    <= '0';
            IW    <= '0';          --- Instruction won't update due to PC+4
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "00";              --
            RW    <= '0';
            AW    <= '0';
            BW    <= '0';
            mulSel <= '1';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= "0100";
            ReW   <= '1';

          WadSrc      <= "00";
          R1src       <= "01";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when wr_mul =>
   			state <= fetch;
   			state <= wr_mul;
 			IorD  <= '0';
            MW    <= '0';
            IW    <= '0';          --- Instruction won't update due to PC+4
            DW    <= '0';
            Rsrc  <= '0';
            M2R   <= "01";              --
            RW    <= '1';
            AW    <= '0';
            BW    <= '1';
            mulSel <= '1';
            Asrc1 <= '1';
            Asrc2 <= "00";
            Fset  <= '0';
            op    <= "0100";
            ReW   <= '0';

          WadSrc      <= "01";
          R1src       <= "01";
          op1sel      <= '1';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';

--------------------------------------------|


      end case;
    end if;
  end process;



end architecture;
