library IEEE;
use IEEE.std_logic_1164.all;


entity Main_Controller is
  port (
    decoded_op : in std_logic_vector(3 downto 0):="0000";              -- whats this
    ins_20     : in std_logic:='0';
    ins_31_28  : in std_logic_vector(3 downto 0):="0000";
    ins_27_26  : in std_logic_vector(1 downto 0):="00";
    ins_27_20  : in std_logic_vector(7 downto 0):="00000000";
    ins_7_4    : in std_logic_vector(3 downto 0):="0000";
    F          : in std_logic_vector(3 downto 0):="0000";  -- (Flags : Z & N & V & C )
    p          : in std_logic:='0';
    clk        : in std_logic:='0';
    class      : in std_logic_vector(1 downto 0):="00";
    sub_class  : in std_logic_vector(3 downto 0):="0000";
    variant    : in std_logic_vector(1 downto 0):="00";
    ins_status : in std_logic_vector(1 downto 0):="00";

--CONTROL SIGNALS
    --------------

    IorD   : out std_logic:='0';
--MR: out std_logic:='0';
    MW     : out std_logic:='0';
    IW     : out std_logic:='0';
    DW     : out std_logic:='0';
    Rsrc   : out std_logic:='0';
    M2R    : out std_logic_vector(1 downto 0):="00";  --
    RW     : out std_logic:='0';
    AW     : out std_logic:='0';
    BW     : out std_logic:='0';
    mulSel : out std_logic:='0';
    Asrc1  : out std_logic:='0';                     --
    Asrc2  : out std_logic_vector(1 downto 0):="00";
    Fset   : out std_logic:='0';
    op     : out std_logic_vector(3 downto 0):="0000";
    ReW    : out std_logic:='0';

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
    HREADY:in std_logic:='0'
    );
end entity Main_Controller;

architecture arch of Main_Controller is


  type state_type is (prefetch,skip2,skip,wait_state2,wait_state1,wait1, wait2, wait3, wait4,wait5,wait6, wait7, wait8, fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, wr_from_M2RF, shift_state1, shift_state2, rdM_wrRF, wrM_wrRF, addr_rdB, PC_plus4, mul_ck_MLA, only_mul, add_MLA, wr_mul);

    signal IorD_temp,MW_temp,IW_temp,Rsrc_temp,DW_temp,RW_temp,AW_temp,BW_temp,mulSel_temp,Asrc1_temp,Fset_temp,ReW_temp,op1sel_temp,ShiftAmtSel_temp,Shift_temp,MulW_temp,ShiftW_temp,op1update_temp:std_logic:='0';
 signal SType_temp,M2R_temp,Asrc2_temp,WadSrc_temp,R1src_temp:std_logic_vector(1 downto 0):="00";
 signal op_temp:std_logic_vector(3 downto 0):="0000";
 
  signal state      : state_type;
  --signal op_temp : std_logic := "0100";
  signal Z, N, V, C : std_logic:='0';

begin

Z<=F(3);
N<=F(1);
V<=F(2);
C<=F(0);

IorD <= IorD_temp;
    MW                           <= MW_temp;
      IW                           <= IW_temp;
      DW                           <= DW_temp;
      Rsrc                         <= Rsrc_temp;
      M2R                          <= M2R_temp;  --
      RW                           <= RW_temp;
      AW                           <= AW_temp;
      BW                           <= BW_temp;
      mulSel <= mulSel_temp;
      
      Asrc1  <= Asrc1_temp;
      Asrc2 <= Asrc2_temp;
      Fset  <= Fset_temp;                 -- p from Bctrl;
      op    <= op_temp;              -- Presently only adding the offset
      ReW   <= ReW_temp;
      WadSrc      <= WadSrc_temp;
      R1src       <= R1src_temp;
      op1sel      <= op1sel_temp;
      SType      <= SType_temp;
      ShiftAmtSel <= ShiftAmtSel_temp;
      Shift       <= Shift_temp;
      MulW        <= MulW_temp;
      ShiftW      <= ShiftW_temp;
      op1update   <= op1update_temp;  
  
  
  process (clk)
  begin
    if (falling_edge(clk) ) then
      case state is
--------------------------------------------|

when skip => 
 if (ins_20 = '0') then --state <= wrM;
           state <= wait_state1;
           HTRANS <= '1';
           HWRITE <= '1';
         else 
           state                   <=   wait_state1; --rdM;
           HTRANS <= '1';
           HWRITE <= '0';

         end if;
         
         

         IorD_temp                         <= '1';  -- give the address for reading  or writing   --- '0';

         --MR: out std_logic:='0';
         --  PW          <= '1';
         MW_temp                           <= '0';
         IW_temp                           <= '0';
         DW_temp                           <= '0';
         Rsrc_temp                         <= '1';
         M2R_temp                          <= "00";  --
         RW_temp                           <= '0';
         AW_temp                           <= '0';
         BW_temp                           <= '1';
         --Asrc1_temp                        <= "00";

         mulSel_temp <= '0';
         Asrc1_temp  <= '1';

         Asrc2_temp <= "10";
         Fset_temp  <= '0';                 -- p from Bctrl;
         op_temp    <= "0100";              -- Presently only adding the offset
         ReW_temp   <= '1';

         WadSrc_temp      <= "00";
         R1src_temp       <= "00";
         op1sel_temp      <= '0';
         SType_temp       <= "00";
         ShiftAmtSel_temp <= '0';
         Shift_temp       <= '0';
         MulW_temp        <= '0';
         ShiftW_temp      <= '0';
         op1update_temp   <= '0';

        when wait1 =>                   --00000000
          IorD_temp   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';
          op_temp     <= "0000";
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
          state       <= wait2;
--------------------------------------------|
        when wait2 =>                   --00000000
          IorD_temp   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';
          op_temp     <= "0000";
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
          state       <= prefetch;
       HWRITE<='0';

--------------------------------------------|
        when wait3 =>                   --00000000
           IorD_temp  <= '1';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '1';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
          state       <= wait4;
--------------------------------------------|
        when wait4 =>                   --00000000
           IorD_temp  <= '1';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '1';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
          state       <= wait8;
--------------------------------------------|
        when wait8 =>                   --00000000
           IorD_temp  <= '1';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '1';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
          state       <= wr_from_M2RF;

--------------------------------------------|
        when prefetch =>                   -- 002210C4
          
          if (HREADY = '1')  then
            state <= fetch ;
            HTRANS <= '0';
          else
            HTRANS <= '1';
            state <= prefetch ;
          end if ;
       HWRITE<='0';

          IorD_temp   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '1';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "01";
          Fset_temp   <= '0';
          op_temp     <= "0100";
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';

--------------------------------------------|
        when fetch =>                   -- 002210C4
          

          IorD_temp   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '1';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "10";               --
          RW_temp     <= '1';
          AW_temp     <= '0';
          BW_temp     <= '0';
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "01";
          Fset_temp   <= '0';
          op_temp     <= "0100";
          ReW_temp    <= '0';

          WadSrc_temp      <= "10";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
          state       <= rdAB;
--------------------------------------------|
        when rdAB =>

          if (ins_27_20(7 downto 5) = "000" and ins_7_4(3 downto 0) = "1001") then
            state <= mul_ck_MLA;        -- 00420B10

            IorD_temp <= '0';
            MW_temp   <= '0';
            IW_temp   <= '0';   --- Instruction won't update due to PC+4
            DW_temp   <= '0';
            Rsrc_temp <= '1';
            M2R_temp  <= "00";               --
            RW_temp   <= '0';
            AW_temp   <= '1';
            BW_temp   <= '1';

            --Asrc1_temp <= "10";
            mulSel_temp <= '0';
            Asrc1_temp  <= '1';
            Asrc2_temp  <= "00";
            Fset_temp   <= '0';
            op_temp     <= decoded_op;
            ReW_temp    <= '0';

            WadSrc_temp      <= "00";
            R1src_temp       <= "01";
            op1sel_temp      <= '0';
            SType_temp       <= "00";
            ShiftAmtSel_temp <= '0';
            Shift_temp       <= '0';
            MulW_temp        <= '0';
            ShiftW_temp      <= '0';
            op1update_temp   <= '0';
          elsif (ins_27_26 = "00") then    -- 00020B00
            state <= shift_state1;      --state <= arith;
            IorD_temp  <= '0';

            --MR: out std_logic:='0';
            --  PW          <= '0';
            MW_temp     <= '0';
            IW_temp     <= '0';   --- Instruction won't update due to PC+4
            DW_temp     <= '0';
            Rsrc_temp   <= '0';
            M2R_temp    <= "00";             --
            RW_temp     <= '0';
            AW_temp     <= '1';
            BW_temp     <= '1';
            mulSel_temp <= '0';
            Asrc1_temp  <= '1';
            if (ins_27_20(5)='0') then
              Asrc2_temp  <= "00";
            else
              Asrc2_temp <= "10";
            end if;
            Fset_temp   <= '0';
            op_temp     <= decoded_op;
            ReW_temp    <= '0';

            WadSrc_temp      <= "00";
            R1src_temp       <= "00";
            op1sel_temp      <= '0';
            SType_temp       <= "00";
            ShiftAmtSel_temp <= '0';
            Shift_temp       <= '0';
            MulW_temp        <= '0';
            ShiftW_temp      <= '0';
            op1update_temp   <= '0';         -- Store op1 in op1p;
          elsif (ins_27_26 = "01") then
            -- 00020B00
            if (ins_27_20(5) = '1') then
              state <= shift_state1;    -- Offser is reg spec
            else
              state <= addr;            -- Offset is immediate
            end if;

            IorD_temp   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '0';
            MW_temp     <= '0';
            IW_temp     <= '0';   --- Instruction won't update due to PC+4
            DW_temp     <= '0';
            Rsrc_temp   <= '0';
            M2R_temp    <= "00";             --
            RW_temp     <= '0';
            AW_temp     <= '1';
            BW_temp     <= '1';
            mulSel_temp <= '0';
            Asrc1_temp  <= '1';
            Asrc2_temp  <= "00";
            Fset_temp   <= '0';
            op_temp     <= decoded_op;
            ReW_temp    <= '0';

            WadSrc_temp      <= "00";
            R1src_temp       <= "00";
            op1sel_temp      <= '0';
            SType_temp       <= "00";
            ShiftAmtSel_temp <= '0';
            Shift_temp       <= '0';
            MulW_temp        <= '0';
            ShiftW_temp      <= '0';
            op1update_temp   <= '0';



          elsif (ins_27_26 = "10" and ins_27_20(4) = '0') then
            --- 002210C0

            state  <= brn;              -- PC Increamented by 4
            IorD_temp   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW_temp     <= '0';
            IW_temp     <= '0';
            DW_temp     <= '0';
            Rsrc_temp   <= '0';
            M2R_temp    <= "10";             --
            RW_temp     <= '1';
            AW_temp     <= '0';
            BW_temp     <= '0';
            --Asrc1_temp <= "00";
            mulSel_temp <= '0';
            Asrc1_temp  <= '0';
            Asrc2_temp  <= "01";
            Fset_temp   <= '0';              -- p from Bctrl;
            op_temp     <= "0100";           -- add
            ReW_temp    <= '0';

            WadSrc_temp      <= "10";
            R1src_temp       <= "00";
            op1sel_temp      <= '0';
            SType_temp       <= "00";
            ShiftAmtSel_temp <= '0';
            Shift_temp       <= '0';
            MulW_temp        <= '0';
            ShiftW_temp      <= '0';
            op1update_temp   <= '0';

          elsif (ins_27_26(1 downto 0) = "10" and ins_27_20(4) = '1') then
            --- 002210C0

            state  <= PC_plus4;         -- Write in Link Register
            IorD_temp   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW_temp     <= '0';
            IW_temp     <= '0';
            DW_temp     <= '0';
            Rsrc_temp   <= '0';
            M2R_temp    <= "10";             --
            RW_temp     <= '1';
            AW_temp     <= '0';
            BW_temp     <= '0';
            --Asrc1_temp <= "00";
            mulSel_temp <= '0';
            Asrc1_temp  <= '0';
            Asrc2_temp  <= "01";
            Fset_temp   <= '0';              -- p from Bctrl;
            op_temp     <= "0100";           -- add
            ReW_temp    <= '0';

            WadSrc_temp      <= "11";        -- r14
            R1src_temp       <= "00";
            op1sel_temp      <= '0';
            SType_temp       <= "00";
            ShiftAmtSel_temp <= '0';
            Shift_temp       <= '0';
            MulW_temp        <= '0';
            ShiftW_temp      <= '0';
            op1update_temp   <= '0';

          end if;

--------------------------------------------|




        when arith =>                   -- 110A0040
          state <= wrRF;

          IorD_temp   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "10";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= decoded_op;         -- op_temp from the Actrl;
          ReW_temp    <= '1';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '1';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= Shift_temp;
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when addr =>                             --000A2A10
state<=skip;
          if (ins_20 = '0') then --state <= wrM;
--            state <= wait_state1;
--            HTRANS <= '1';
            HWRITE <= '1';
          else 
--            state                   <=   wait_state1; --rdM;
--            HTRANS <= '1';
            HWRITE <= '0';

          end if;
          
          

          IorD_temp                         <= '1';  -- give the address for reading  or writing   --- '0';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp                           <= '0';
          IW_temp                           <= '0';
          DW_temp                           <= '0';
          Rsrc_temp                         <= '1';
          M2R_temp                          <= "00";  --
          RW_temp                           <= '0';
          AW_temp                           <= '0';
          BW_temp                           <= '1';
          --Asrc1_temp                        <= "00";

          mulSel_temp <= '0';
          Asrc1_temp  <= '1';

          Asrc2_temp <= "10";
          Fset_temp  <= '0';                 -- p from Bctrl;
          op_temp    <= "0100";              -- Presently only adding the offset
          ReW_temp   <= '1';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';


--------------------------------------------|
        when wait_state1 => 
          
          if (ins_20 = '0') then --state <= wrM;
        
            HWRITE <= '1';
          else 
            HWRITE <= '0';

          end if;
          
--          HWRITE <= '0';
          HTRANS <= '1';
          if(HREADY = '1') then 
              if (ins_20 = '0') then 
                HTRANS <= '0';
                state <= wrM;
              else 
                HTRANS <= '0';
                state <= rdM;
              end if;
          else state <=wait_state1;
          end if;
          IorD_temp                         <= IorD_temp ;      -- give the address for reading  or writing   --- '0';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp                           <= MW_temp;
          IW_temp                           <= IW_temp;
          DW_temp                           <= DW_temp;
          Rsrc_temp                         <= Rsrc_temp;
          M2R_temp                          <= M2R_temp;  --
          RW_temp                           <= RW_temp;
          AW_temp                           <= AW_temp;
          BW_temp                           <= BW_temp;
          --Asrc1_temp                        <= "00";

          mulSel_temp <= mulSel_temp;
          Asrc1_temp  <= Asrc1_temp;

          Asrc2_temp <= Asrc2_temp;
          Fset_temp  <= Fset_temp;                 -- p from Bctrl;
          op_temp    <= op_temp;              -- Presently only adding the offset
          ReW_temp   <= ReW_temp;

          WadSrc_temp      <= WadSrc_temp;
          R1src_temp       <= R1src_temp;
          op1sel_temp      <= op1sel_temp;
          SType_temp       <= SType_temp;
          ShiftAmtSel_temp <= ShiftAmtSel_temp;
          Shift_temp       <= Shift_temp;
          MulW_temp        <= MulW_temp;
          ShiftW_temp      <= ShiftW_temp;
          op1update_temp   <= op1update_temp;




--------------------------------------------|

        when wrM =>        
                    -- 00020003
       HWRITE<='0';
          state <= prefetch ; --wait1;
          --HTRANS <= "1";  -- NONSEQ;

          IorD_temp  <= '0';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= p;                  --'1';
          IW_temp     <= '0';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when rdM =>                     -- 00020009
          state <= wr_from_M2RF;  --wait3;
          --HTRANS <= "10";

          IorD_temp  <= '1';  -- made 1 in addr --'1';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '1';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when brn =>                     -- 002230C0
          --;;;  -- we have to do PC =PC + 4 + Offset will take two cycles;
                 HWRITE<='0';

          state  <=   prefetch; --wait1;
          HTRANS <= '1';

          IorD_temp   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "10";               --
          RW_temp     <= p;                  --'1';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "11";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "10";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when wrRF =>                    -- 000200A0
               HWRITE<='0';

          state <=   prefetch;  --wait1;
          -- if (not (ins_27_20(4) = '1' and(ins_27_20(3) = '0'))) then
            IorD_temp   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW_temp     <= '0';
            IW_temp     <= '0';
            DW_temp     <= '0';
            Rsrc_temp   <= '0'; 
            M2R_temp    <= "01";             --
            if (decoded_op(3 downto 2) = "10")  then
              RW_temp     <= '0';                --'1';
            else            
              RW_temp     <= p;                --'1';
            end if;
            AW_temp     <= '0';
            BW_temp     <= '0';
            --Asrc1_temp <= "00";
            mulSel_temp <= '0';
            Asrc1_temp  <= '0';
            Asrc2_temp  <= "00";
            if(decoded_op(3 downto 2) = "10") then
                        Fset_temp   <= '1';
            else
            Fset_temp   <= ins_27_20(0)   ;     -- depends on p from Bctrl
            end if;
            
            op_temp     <= "0100";           -- op_temp from Actrl
            ReW_temp    <= '0';

            WadSrc_temp      <= "00";
            R1src_temp       <= "00";
            op1sel_temp      <= '0';
            SType_temp       <= "00";
            ShiftAmtSel_temp <= '0';
            Shift_temp       <= '0';
            MulW_temp        <= '0';
            ShiftW_temp      <= '0';
            op1update_temp   <= '0';
          -- end if;
--------------------------------------------|
        when wr_from_M2RF =>            -- 00020080
               HWRITE<='0';

          state <=    prefetch  ;  ---wait1;
          IorD_temp  <= '0';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= p;                  --'1';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when shift_state1 =>            -- 91420900 reg_spec -- 99420900 imm
          -- read register X = RF[IR[11-8]]; is also done here;
          if (ins_27_26 = "00") then
            if (ins_27_20(5) = '0') then
              if (ins_7_4(0) = '0') then
                state <= shift_state2;

                IorD_temp   <= '0';
                --MR: out std_logic:='0';
                --  PW          <= '1';
                MW_temp     <= '0';
                IW_temp     <= '0';
                DW_temp     <= '0';
                Rsrc_temp   <= '0';
                M2R_temp    <= "00";         --
                RW_temp     <= '0';
                AW_temp     <= '1';
                BW_temp     <= '0';
                --Asrc1_temp <= "01";
                mulSel_temp <= '0';
                Asrc1_temp  <= '1';
                Asrc2_temp  <= "00";
                Fset_temp   <= '0';
                op_temp     <= decoded_op;
                ReW_temp    <= '0';

                WadSrc_temp <= "00";
                R1src_temp  <= "01";
                op1sel_temp <= '1';
                SType_temp  <= ins_7_4(2 downto 1);  --- Not sure which bits signal it

                ShiftAmtSel_temp <= '1';     -- not register specified

                -- end if;
                Shift_temp     <= '1';
                MulW_temp      <= '0';
                ShiftW_temp    <= '0';
                op1update_temp <= '1';
              else
                state <= shift_state2;

                IorD_temp   <= '0';
                --MR: out std_logic:='0';
                --  PW          <= '1';
                MW_temp     <= '0';
                IW_temp     <= '0';
                DW_temp     <= '0';
                Rsrc_temp   <= '0';
                M2R_temp    <= "00";         --
                RW_temp     <= '0';
                AW_temp     <= '1';
                BW_temp     <= '0';
                --Asrc1_temp <= "01";
                mulSel_temp <= '0';
                Asrc1_temp  <= '1';
                Asrc2_temp  <= "00";
                Fset_temp   <= '0';
                op_temp     <= decoded_op;
                ReW_temp    <= '0';

                WadSrc_temp <= "00";
                R1src_temp  <= "01";
                op1sel_temp <= '1';
                SType_temp  <= "11";         --rotate

                ShiftAmtSel_temp <= '0';     -- not immediate
                -- end if;
                Shift_temp       <= '1';
                MulW_temp        <= '0';
                ShiftW_temp      <= '0';
                op1update_temp   <= '1';
              end if;
            else
              state <= shift_state2;

              IorD_temp   <= '0';
              --MR: out std_logic:='0';
              --  PW          <= '1';
              MW_temp     <= '0';
              IW_temp     <= '0';
              DW_temp     <= '0';
              Rsrc_temp   <= '0';
              M2R_temp    <= "00";           --
              RW_temp     <= '0';
              AW_temp     <= '1';
              BW_temp     <= '0';
              --Asrc1_temp <= "01";
              mulSel_temp <= '0';
              Asrc1_temp  <= '1';
              Asrc2_temp  <= "10";
              Fset_temp   <= '0';
              op_temp     <= decoded_op;
              ReW_temp    <= '0';

              WadSrc_temp <= "00";
              R1src_temp  <= "01";
              op1sel_temp <= '1';
              SType_temp  <= "11";  --- Not sure which bits signal it
              --if (ins_7_4(0) = '0') then
              --  ShiftAmtSel_temp <= '1';           -- register specified
              --else
              --  ShiftAmtSel_temp <= '0';           -- immediate
              --end if;
              ShiftAmtSel_temp <= '1';
              Shift_temp     <= '0';
              MulW_temp      <= '0';
              ShiftW_temp    <= '0';
              op1update_temp <= '1';
            end if;
          elsif(ins_27_26 = "01") then

            state <= shift_state2;      -- 99820900

            -- state <= addr_rdB;
            IorD_temp   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW_temp     <= '0';
            IW_temp     <= '0';
            DW_temp     <= '0';
            Rsrc_temp   <= '0';
            M2R_temp    <= "00";             --
            RW_temp     <= '0';
            AW_temp     <= '1';
            BW_temp     <= '0';
            --Asrc1_temp <= "01";
            mulSel_temp <= '0';
            Asrc1_temp  <= '1';
            if (ins_27_20(5)='1') then
              Asrc2_temp  <= "00";
            else
              Asrc2_temp <= "10";
            end if;
            Fset_temp   <= '0';
            op_temp     <= decoded_op;
            ReW_temp    <= '0';

            WadSrc_temp      <= "00";
            R1src_temp       <= "01";
            op1sel_temp      <= '1';
            SType_temp       <= ins_7_4(2 downto 1);  --- Not sure which bits signal it
            ShiftAmtSel_temp <= '1';         --- ins(11 to 4);
            Shift_temp       <= '1';
            MulW_temp        <= '0';
            ShiftW_temp      <= '0';
            op1update_temp   <= '1';


          end if;

--------------------------------------------|
        when shift_state2 =>            -- 51420800 reg_spec -- 59420800 imm
          -- read register X = RF[IR[11-8]]; is also done here;
          if (ins_27_26 = "00") then
            state <= arith;

            IorD_temp   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW_temp     <= '0';
            IW_temp     <= '0';
            DW_temp     <= '0';
            Rsrc_temp   <= '0';
            M2R_temp    <= "00";             --
            RW_temp     <= '0';
            AW_temp     <= '0';
            BW_temp     <= '0';
            --Asrc1_temp <= "01";
            mulSel_temp <= '0';
            Asrc1_temp  <= '1';
            if (ins_27_20(5)='0') then
              Asrc2_temp  <= "00";
            else
              Asrc2_temp <= "10";
            end if;
            Fset_temp   <= '0';
            op_temp     <= decoded_op;
            ReW_temp    <= '0';

            WadSrc_temp <= "00";
            R1src_temp  <= "01";
            op1sel_temp <= '1';
            SType_temp  <= SType_temp;             --- Not sure which bits signal it
              --if (ins_7_4(0) = '0') then
              --  ShiftAmtSel_temp <= '1';       -- register specified
              --else
              --  ShiftAmtSel_temp <= '0';       -- immediate
              --end if;
              ShiftAmtSel_temp <= ShiftAmtSel_temp;
            Shift_temp     <= '1';
            MulW_temp      <= '0';
            ShiftW_temp    <= '1';
            op1update_temp <= '0';
          elsif(ins_27_26 = "01") then
            state <= addr_rdB;          --59820800
            IorD_temp  <= '0';

            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW_temp     <= '0';
            IW_temp     <= '0';
            DW_temp     <= '0';
            Rsrc_temp   <= '0';
            M2R_temp    <= "00";             --
            RW_temp     <= '0';
            AW_temp     <= '0';
            BW_temp     <= '0';
            --Asrc1_temp <= "01";
            mulSel_temp <= '0';
            Asrc1_temp  <= '1';
            if(ins_27_20(5)='1') then
              Asrc2_temp  <= "00";
            else
              Asrc2_temp <= "10";
          end if;
            Fset_temp   <= '0';
            op_temp     <= decoded_op;
            ReW_temp    <= '0';

            WadSrc_temp      <= "00";
            R1src_temp       <= "01";
            op1sel_temp      <= '1';
            SType_temp       <= SType_temp;        --- Not sure which bits signal it
            ShiftAmtSel_temp <= '1';         --- ins(11 to 4);
            Shift_temp       <= '1';
            MulW_temp        <= '0';
            ShiftW_temp      <= '1';
            op1update_temp   <= '0';


          end if;
--------------------------------------------|
        --when readx =>
        --  state <= shift_state;
--------------------------------------------|
        when rdM_wrRF =>  -- 001200A9 -- Auto_inc  XXX 00120029 -- without Auto_inc
          state                           <= wr_from_M2RF; --wait5;
          if (ins_27_20(1) = '1') then RW_temp <= p;  --'1';
          else RW_temp                         <= '0';
          end if;

          IorD_temp   <= '1';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '1';
          Rsrc_temp   <= '0';
          M2R_temp    <= "01";               --
          --RW_temp    <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "01";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';

--------------------------------------------|
        when wait5 =>  -- 001200A9 -- Auto_inc  XXX 00120029 -- without Auto_inc
          state                           <= wait6;
          if (ins_27_20(1) = '1') then RW_temp <= p;  --'1';
          else RW_temp                         <= '0';
          end if;

          IorD_temp   <= '1';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '1';
          Rsrc_temp   <= '0';
          M2R_temp    <= "01";               --
          --RW_temp    <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "01";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';

--------------------------------------------|
        when wait6 =>  -- 001200A9 -- Auto_inc  XXX 00120029 -- without Auto_inc
          state                           <=wait7;
          if (ins_27_20(1) = '1') then RW_temp <= p;  --'1';
          else RW_temp                         <= '0';
          end if;

          IorD_temp   <= '1';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '1';
          Rsrc_temp   <= '0';
          M2R_temp    <= "01";               --
          --RW_temp    <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "01";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';

--------------------------------------------|
        when wait7 =>  -- 001200A9 -- Auto_inc  XXX 00120029 -- without Auto_inc
          state                           <= wr_from_M2RF;
          if (ins_27_20(1) = '1') then RW_temp <= p;  --'1';
          else RW_temp                         <= '0';
          end if;

          IorD_temp   <= '1';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '0';
          IW_temp     <= '0';
          DW_temp     <= '1';
          Rsrc_temp   <= '0';
          M2R_temp    <= "01";               --
          --RW_temp    <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "01";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';

--------------------------------------------|
        when wrM_wrRF =>  -- 111200A3 -- Auto_inc  XXX 11120023 -- without Auto_inc
          state <= prefetch ; --wait1;

       HWRITE<='0';

          -- If W='1' then auto_inc else don't
          if (ins_27_20(1) = '1') then RW_temp <= p;  --'1';
          else RW_temp                         <= '0';
          end if;

          IorD_temp   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp     <= '1';
          IW_temp     <= '0';
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "01";               --rd2p
          --RW_temp    <= '1';
          AW_temp     <= '0';
          BW_temp     <= '0';
          --Asrc1_temp <= "00";
          mulSel_temp <= '0';
          Asrc1_temp  <= '0';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';                -- p from Bctrl;
          op_temp     <= "0100";             -- op_temp from the Actrl;
          ReW_temp    <= '0';

          WadSrc_temp      <= "01";
          R1src_temp       <= "00";
          op1sel_temp      <= '1';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '1';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
when skip2=>
  --if (ins_27_20(0) = '1') then
  --  state <= rdM_wrRF;
  --else state <= wrM_wrRF;
  --end if;
  state <= wait_state2;
  HTRANS <= '1';
  if (ins_20 = '0') then 
    HWRITE <= '1';
  else
    HWRITE <= '0';
  end if;  
  IorD_temp       <= '1';  -- Send the address to the memory- '0';
  --MR: out std_logic:='0';
  --  PW          <= '1';
  MW_temp         <= '0';
  IW_temp         <= '0';
  DW_temp         <= '0';
  Rsrc_temp       <= '1';
  M2R_temp        <= "00";           --
  RW_temp         <= '0';
  AW_temp         <= '0';
  BW_temp         <= '1';
  --Asrc1_temp      <= "00";
  mulSel_temp     <= '0';
  Asrc1_temp      <= '0';
  Asrc2_temp      <= "00";
  Fset_temp       <= '0';            -- p from Bctrl;
  op_temp         <= "0100";         -- only add
  ReW_temp        <= '1';

  WadSrc_temp      <= "00";
  R1src_temp       <= "00";
  op1sel_temp      <= '1';
  SType_temp       <= "00";
  ShiftAmtSel_temp <= '0';
  Shift_temp       <= '1';
  MulW_temp        <= '0';
  ShiftW_temp      <= '0';
  op1update_temp   <= '0';


        when addr_rdB =>                -- 010A0210
          --if (ins_27_20(0) = '1') then
          --  state <= rdM_wrRF;
          --else state <= wrM_wrRF;
          --end if;
          state <= skip2;
--          HTRANS <= '1';
          if (ins_20 = '0') then 
            HWRITE <= '1';
          else
            HWRITE <= '0';
          end if;  
          IorD_temp       <= '1';  -- Send the address to the memory- '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp         <= '0';
          IW_temp         <= '0';
          DW_temp         <= '0';
          Rsrc_temp       <= '1';
          M2R_temp        <= "00";           --
          RW_temp         <= '0';
          AW_temp         <= '0';
          BW_temp         <= '1';
          --Asrc1_temp      <= "00";
          mulSel_temp     <= '0';
          Asrc1_temp      <= '0';
          Asrc2_temp      <= "00";
          Fset_temp       <= '0';            -- p from Bctrl;
          op_temp         <= "0100";         -- only add
          ReW_temp        <= '1';

          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '1';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '1';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';


--------------------------------------------|

 when wait_state2 => 
          
          
          HWRITE <= '0';
          HTRANS <= '1';
           -- IDLE 
          if(HREADY = '1') then      
              if (ins_20 = '0') then 
                HTRANS <= '0';
                state <= wrM_wrRF;
              else 
                HTRANS <= '0';
                state <= rdM_wrRF;
              end if;
          else state <=wait_state2;
          end if;


          IorD_temp                         <= IorD_temp ;      -- give the address for reading  or writing   --- '0';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp                           <= MW_temp;
          IW_temp                           <= IW_temp;
          DW_temp                           <= DW_temp;
          Rsrc_temp                         <= Rsrc_temp;
          M2R_temp                          <= M2R_temp;  --
          RW_temp                           <= RW_temp;
          AW_temp                           <= AW_temp;
          BW_temp                           <= BW_temp;
          --Asrc1_temp                        <= "00";

          mulSel_temp <= mulSel_temp;
          Asrc1_temp  <= Asrc1_temp;

          Asrc2_temp <= Asrc2_temp;
          Fset_temp  <= Fset_temp;                 -- p from Bctrl;
          op_temp    <= op_temp;              -- Presently only adding the offset
          ReW_temp   <= ReW_temp;

          WadSrc_temp      <= WadSrc_temp;
          R1src_temp       <= R1src_temp;
          op1sel_temp      <= op1sel_temp;
          SType_temp       <= SType_temp;
          ShiftAmtSel_temp <= ShiftAmtSel_temp;
          Shift_temp       <= Shift_temp;
          MulW_temp        <= MulW_temp;
          ShiftW_temp      <= ShiftW_temp;
          op1update_temp   <= op1update_temp;

--------------------------------------------|

        when PC_plus4 =>                --002A10C8
          state <= brn;
          IorD_temp  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW_temp    <= '0';
          IW_temp    <= '0';
          DW_temp    <= '0';
          Rsrc_temp  <= '0';
          M2R_temp   <= "10";                --
          RW_temp    <= '1';
          AW_temp    <= '0';
          BW_temp    <= '0';
          Asrc1_temp <= '0';
          Asrc2_temp <= "01";
          Fset_temp  <= '0';                 -- p from Bctrl;
          op_temp    <= "0100";              -- op_temp from the Actrl;
          ReW_temp   <= '1';

          WadSrc_temp      <= "11";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when mul_ck_MLA =>              -- 20820D00
          if (ins_27_20(1) = '0') then
            state <= only_mul;
          else state <= add_MLA;
          end if;
          IorD_temp       <= '0';
          MW_temp         <= '0';
          IW_temp         <= '0';   --- Instruction won't update due to PC+4
          DW_temp         <= '0';
          Rsrc_temp       <= '0';
          M2R_temp        <= "00";           --
          RW_temp         <= '0';
          AW_temp         <= '1';
          BW_temp         <= '0';
          mulSel_temp     <= '1';
          Asrc1_temp      <= '1';
          Asrc2_temp      <= "00";
          Fset_temp       <= '0';
          op_temp         <= "0100";
          ReW_temp        <= '0';


          WadSrc_temp      <= "00";
          R1src_temp       <= "10";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '1';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when only_mul =>                --000E8C00
          state  <= wr_mul;
          IorD_temp   <= '0';
          MW_temp     <= '0';
          IW_temp     <= '0';   --- Instruction won't update due to PC+4
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          mulSel_temp <= '1';
          Asrc1_temp  <= '1';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';
          op_temp     <= "1101";
          ReW_temp    <= '1';


          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when add_MLA =>                 -- 000A0C00
          state  <= wr_mul;
          IorD_temp   <= '0';
          MW_temp     <= '0';
          IW_temp     <= '0';   --- Instruction won't update due to PC+4
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "00";               --
          RW_temp     <= '0';
          AW_temp     <= '0';
          BW_temp     <= '0';
          mulSel_temp <= '1';
          Asrc1_temp  <= '1';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';
          op_temp     <= "0100";
          ReW_temp    <= '1';


          WadSrc_temp      <= "00";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';
--------------------------------------------|
        when wr_mul =>    
                      -- 00120CA0
                             HWRITE<='0';

          state  <= prefetch;
          IorD_temp   <= '0';
          MW_temp     <= '0';
          IW_temp     <= '0';   --- Instruction won't update due to PC+4
          DW_temp     <= '0';
          Rsrc_temp   <= '0';
          M2R_temp    <= "01";               --
          RW_temp     <= p;                  --'1';
          AW_temp     <= '0';
          BW_temp     <= '0';
          mulSel_temp <= '1';
          Asrc1_temp  <= '1';
          Asrc2_temp  <= "00";
          Fset_temp   <= '0';
          op_temp     <= "0100";
          ReW_temp    <= '0';

          WadSrc_temp      <= "01";
          R1src_temp       <= "00";
          op1sel_temp      <= '0';
          SType_temp       <= "00";
          ShiftAmtSel_temp <= '0';
          Shift_temp       <= '0';
          MulW_temp        <= '0';
          ShiftW_temp      <= '0';
          op1update_temp   <= '0';

--------------------------------------------|


      end case;
    end if;
  end process;



end architecture;
