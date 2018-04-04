library IEEE;
use IEEE.std_logic_1164.all;


entity Main_Controller is
  port (
    decoded_op : in std_logic_vector;              -- whats this
    ins_20     : in std_logic;
    ins_31_28  : in std_logic_vector(3 downto 0);
    ins_27_26  : in std_logic_vector(1 downto 0);
    ins_27_20  : in std_logic_vector(7 downto 0);
    ins_7_4    : in std_logic_vector(3 downto 0);
    F          : in std_logic_vector(3 downto 0);  -- (Flags : Z & N & V & C )
    p          : in std_logic;
    clk        : in std_logic;
    class      : in std_logic_vector(1 downto 0);
    sub_class  : in std_logic_vector(3 downto 0);
    variant    : in std_logic_vector(1 downto 0);
    ins_status : in std_logic_vector(1 downto 0);

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


  type state_type is (wait1, wait2, fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, wr_from_M2RF, shift_state1, shift_state2, rdM_wrRF, wrM_wrRF, addr_rdB, PC_plus4, mul_ck_MLA, only_mul, add_MLA, wr_mul);


  signal state      : state_type;
  --signal op_temp : std_logic := "0100";
  signal Z, N, V, C : std_logic;

begin

  process (clk)
  begin
    if (falling_edge(clk)) then
      case state is
--------------------------------------------|
        when wait1 =>                   --00000000
          IorD   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '0';
          IW     <= '0';
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "00";               --
          RW     <= '0';
          AW     <= '0';
          BW     <= '0';
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "00";
          Fset   <= '0';
          op     <= "0000";
          ReW    <= '0';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '0';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
          state       <= wait2;
--------------------------------------------|
        when wait2 =>                   --00000000
          IorD   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '0';
          IW     <= '0';
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "00";               --
          RW     <= '0';
          AW     <= '0';
          BW     <= '0';
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "00";
          Fset   <= '0';
          op     <= "0000";
          ReW    <= '0';

          WadSrc      <= "00";
          R1src       <= "00";
          op1sel      <= '0';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
          state       <= fetch;
--------------------------------------------|
        when fetch =>                   -- 002210C4


          IorD   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '0';
          IW     <= '1';
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "10";               --
          RW     <= '1';
          AW     <= '0';
          BW     <= '0';
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "01";
          Fset   <= '0';
          op     <= "0100";
          ReW    <= '0';

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


          if (ins_27_26 = "00") then    -- 00020B00
            state <= shift_state1;      --state <= arith;
            IorD  <= '0';

            --MR: out std_logic:='0';
            --  PW          <= '0';
            MW     <= '0';
            IW     <= '0';   --- Instruction won't update due to PC+4
            DW     <= '0';
            Rsrc   <= '0';
            M2R    <= "00";             --
            RW     <= '0';
            AW     <= '1';
            BW     <= '1';
            mulSel <= '0';
            Asrc1  <= '1';
            if (ins_27_20(5)='0') then  
              Asrc2  <= "00";
            else
              Asrc2 <= "10";
            end if;
            Fset   <= '0';
            op     <= decoded_op;
            ReW    <= '0';

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
            -- 00020B00
            if (ins_27_20(5) = '1') then
              state <= shift_state1;    -- Offser is reg spec
            else
              state <= addr;            -- Offset is immediate
            end if;

            IorD   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '0';
            MW     <= '0';
            IW     <= '0';   --- Instruction won't update due to PC+4
            DW     <= '0';
            Rsrc   <= '0';
            M2R    <= "00";             --
            RW     <= '0';
            AW     <= '1';
            BW     <= '1';
            mulSel <= '0';
            Asrc1  <= '1';
            Asrc2  <= "00";
            Fset   <= '0';
            op     <= decoded_op;
            ReW    <= '0';

            WadSrc      <= "00";
            R1src       <= "00";
            op1sel      <= '0';
            SType       <= "00";
            ShiftAmtSel <= '0';
            Shift       <= '0';
            MulW        <= '0';
            ShiftW      <= '0';
            op1update   <= '0';

          elsif (ins_7_4(3 downto 0) = "1001") then
            state <= mul_ck_MLA;        -- 00420B10

            IorD <= '0';
            MW   <= '0';
            IW   <= '0';   --- Instruction won't update due to PC+4
            DW   <= '0';
            Rsrc <= '1';
            M2R  <= "00";               --
            RW   <= '0';
            AW   <= '1';
            BW   <= '1';

            --Asrc1 <= "10";
            mulSel <= '0';
            Asrc1  <= '1';
            Asrc2  <= "00";
            Fset   <= '0';
            op     <= decoded_op;
            ReW    <= '0';

            WadSrc      <= "00";
            R1src       <= "01";
            op1sel      <= '0';
            SType       <= "00";
            ShiftAmtSel <= '0';
            Shift       <= '0';
            MulW        <= '0';
            ShiftW      <= '0';
            op1update   <= '0';

          elsif (ins_27_26 = "10" and ins_27_20(4) = '0') then
            --- 002210C0

            state  <= brn;              -- PC Increamented by 4
            IorD   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW     <= '0';
            IW     <= '0';
            DW     <= '0';
            Rsrc   <= '0';
            M2R    <= "10";             --
            RW     <= '1';
            AW     <= '0';
            BW     <= '0';
            --Asrc1 <= "00";
            mulSel <= '0';
            Asrc1  <= '0';
            Asrc2  <= "01";
            Fset   <= '0';              -- p from Bctrl;
            op     <= "0100";           -- add
            ReW    <= '0';

            WadSrc      <= "10";
            R1src       <= "00";
            op1sel      <= '0';
            SType       <= "00";
            ShiftAmtSel <= '0';
            Shift       <= '0';
            MulW        <= '0';
            ShiftW      <= '0';
            op1update   <= '0';

          elsif (ins_27_26(1 downto 0) = "10" and ins_27_20(4) = '1') then
            --- 002210C0

            state  <= PC_plus4;         -- Write in Link Register
            IorD   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW     <= '0';
            IW     <= '0';
            DW     <= '0';
            Rsrc   <= '0';
            M2R    <= "10";             --
            RW     <= '1';
            AW     <= '0';
            BW     <= '0';
            --Asrc1 <= "00";
            mulSel <= '0';
            Asrc1  <= '0';
            Asrc2  <= "01";
            Fset   <= '0';              -- p from Bctrl;
            op     <= "0100";           -- add
            ReW    <= '0';

            WadSrc      <= "11";        -- r14
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




        when arith =>                   -- 110A0040
          state <= wrRF;

          IorD   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '0';
          IW     <= '0';
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "10";               --
          RW     <= '0';
          AW     <= '0';
          BW     <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "00";
          Fset   <= '0';                -- p from Bctrl;
          op     <= decoded_op;         -- op from the Actrl;
          ReW    <= '1';

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
        when addr =>                             --000A2A10
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
          M2R                          <= "00";  --
          RW                           <= '0';
          AW                           <= '0';
          BW                           <= '1';
          --Asrc1                        <= "00";

          mulSel <= '0';
          Asrc1  <= '1';

          Asrc2 <= "10";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= "0100";              -- Presently only adding the offset
          ReW   <= '1';

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
        when wrM =>                     -- 00020003
          state <= fetch;
          IorD  <= '1';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= p;                  --'1';
          IW     <= '0';
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "00";               --
          RW     <= '0';
          AW     <= '0';
          BW     <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "00";
          Fset   <= '0';                -- p from Bctrl;
          op     <= "0100";
          ReW    <= '0';

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
        when rdM =>                     -- 00020009
          state <= wr_from_M2RF;
          IorD  <= '1';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '0';
          IW     <= '0';
          DW     <= '1';
          Rsrc   <= '0';
          M2R    <= "00";               --
          RW     <= '0';
          AW     <= '0';
          BW     <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "00";
          Fset   <= '0';                -- p from Bctrl;
          op     <= "0100";             -- op from the Actrl;
          ReW    <= '0';

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
        when brn =>                     -- 002230C0
          --;;;  -- we have to do PC =PC + 4 + Offset will take two cycles;
          state  <= wait1;
          IorD   <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '0';
          IW     <= '0';
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "10";               --
          RW     <= p;                  --'1';
          AW     <= '0';
          BW     <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "11";
          Fset   <= '0';                -- p from Bctrl;
          op     <= "0100";             -- op from the Actrl;
          ReW    <= '0';

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
        when wrRF =>                    -- 000200A0
          state <= fetch;
          if (not (ins_27_20(4) = '1' and(ins_27_20(3) = '0'))) then
            IorD   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW     <= '0';
            IW     <= '0';
            DW     <= '0';
            Rsrc   <= '0';
            M2R    <= "01";             --
            RW     <= p;                --'1';
            AW     <= '0';
            BW     <= '0';
            --Asrc1 <= "00";
            mulSel <= '0';
            Asrc1  <= '0';
            Asrc2  <= "00";
            Fset   <= ins_27_20(0);     -- depends on p from Bctrl
            op     <= "0100";           -- op from Actrl
            ReW    <= '0';

            WadSrc      <= "00";
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
        when wr_from_M2RF =>            -- 00020080
          state <= fetch;
          IorD  <= '0';

          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '0';
          IW     <= '0';
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "00";               --
          RW     <= p;                  --'1';
          AW     <= '0';
          BW     <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "00";
          Fset   <= '0';                -- p from Bctrl;
          op     <= "0100";             -- op from the Actrl;
          ReW    <= '0';

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
        when shift_state1 =>            -- 91420900 reg_spec -- 99420900 imm
          -- read register X = RF[IR[11-8]]; is also done here;
          if (ins_27_26 = "00") then
            if (ins_27_20(5) = '0') then
              if (ins_7_4(0) = '0') then
                state <= shift_state2;

                IorD   <= '0';
                --MR: out std_logic:='0';
                --  PW          <= '1';
                MW     <= '0';
                IW     <= '0';
                DW     <= '0';
                Rsrc   <= '0';
                M2R    <= "00";         --
                RW     <= '0';
                AW     <= '1';
                BW     <= '0';
                --Asrc1 <= "01";
                mulSel <= '0';
                Asrc1  <= '1';
                Asrc2  <= "00";
                Fset   <= '0';
                op     <= decoded_op;
                ReW    <= '0';

                WadSrc <= "00";
                R1src  <= "01";
                op1sel <= '1';
                SType  <= ins_7_4(2 downto 1);  --- Not sure which bits signal it

                ShiftAmtSel <= '1';     -- not register specified

                -- end if;
                Shift     <= '1';
                MulW      <= '0';
                ShiftW    <= '0';
                op1update <= '1';
              else
                state <= shift_state2;

                IorD   <= '0';
                --MR: out std_logic:='0';
                --  PW          <= '1';
                MW     <= '0';
                IW     <= '0';
                DW     <= '0';
                Rsrc   <= '0';
                M2R    <= "00";         --
                RW     <= '0';
                AW     <= '1';
                BW     <= '0';
                --Asrc1 <= "01";
                mulSel <= '0';
                Asrc1  <= '1';
                Asrc2  <= "00";
                Fset   <= '0';
                op     <= decoded_op;
                ReW    <= '0';

                WadSrc <= "00";
                R1src  <= "01";
                op1sel <= '1';
                SType  <= "11";         --rotate

                ShiftAmtSel <= '0';     -- not immediate
                -- end if;
                Shift       <= '1';
                MulW        <= '0';
                ShiftW      <= '0';
                op1update   <= '1';
              end if;
            else
              state <= shift_state2;

              IorD   <= '0';
              --MR: out std_logic:='0';
              --  PW          <= '1';
              MW     <= '0';
              IW     <= '0';
              DW     <= '0';
              Rsrc   <= '0';
              M2R    <= "00";           --
              RW     <= '0';
              AW     <= '1';
              BW     <= '0';
              --Asrc1 <= "01";
              mulSel <= '0';
              Asrc1  <= '1';
              Asrc2  <= "00";
              Fset   <= '0';
              op     <= decoded_op;
              ReW    <= '0';

              WadSrc <= "00";
              R1src  <= "01";
              op1sel <= '1';
              SType  <= ins_7_4(2 downto 1);  --- Not sure which bits signal it
              --if (ins_7_4(0) = '0') then
              --  ShiftAmtSel <= '1';           -- register specified
              --else
              --  ShiftAmtSel <= '0';           -- immediate
              --end if;
              ShiftAmtSel = '0';
              Shift     <= '1';
              MulW      <= '0';
              ShiftW    <= '0';
              op1update <= '1';
            end if;
          elsif(ins_27_26 = "01") then

            state <= shift_state2;      -- 99820900

            -- state <= addr_rdB;
            IorD   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW     <= '0';
            IW     <= '0';
            DW     <= '0';
            Rsrc   <= '0';
            M2R    <= "00";             --
            RW     <= '0';
            AW     <= '1';
            BW     <= '0';
            --Asrc1 <= "01";
            mulSel <= '0';
            Asrc1  <= '1';
            Asrc2  <= "00";
            Fset   <= '0';
            op     <= decoded_op;
            ReW    <= '0';

            WadSrc      <= "00";
            R1src       <= "01";
            op1sel      <= '1';
            SType       <= ins_7_4(2 downto 1);  --- Not sure which bits signal it
            ShiftAmtSel <= '1';         --- ins(11 to 4);
            Shift       <= '1';
            MulW        <= '0';
            ShiftW      <= '0';
            op1update   <= '1';


          end if;

--------------------------------------------|
        when shift_state2 =>            -- 51420800 reg_spec -- 59420800 imm
          -- read register X = RF[IR[11-8]]; is also done here;
          if (ins_27_26 = "00") then
            state <= arith;

            IorD   <= '0';
            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW     <= '0';
            IW     <= '0';
            DW     <= '0';
            Rsrc   <= '0';
            M2R    <= "00";             --
            RW     <= '0';
            AW     <= '0';
            BW     <= '0';
            --Asrc1 <= "01";
            mulSel <= '0';
            Asrc1  <= '1';
            Asrc2  <= "00";
            Fset   <= '0';
            op     <= decoded_op;
            ReW    <= '0';

            WadSrc <= "00";
            R1src  <= "01";
            op1sel <= '1';
            SType  <= "00";             --- Not sure which bits signal it
            if (ins_27_20(5) = '0') then
              ShiftAmtSel <= '0';       -- register specified
            else
              ShiftAmtSel <= '1';       -- immediate
            end if;
            Shift     <= '1';
            MulW      <= '0';
            ShiftW    <= '1';
            op1update <= '0';
          elsif(ins_27_26 = "01") then
            state <= addr_rdB;          --59820800
            IorD  <= '0';

            --MR: out std_logic:='0';
            --  PW          <= '1';
            MW     <= '0';
            IW     <= '0';
            DW     <= '0';
            Rsrc   <= '0';
            M2R    <= "00";             --
            RW     <= '0';
            AW     <= '0';
            BW     <= '0';
            --Asrc1 <= "01";
            mulSel <= '0';
            Asrc1  <= '1';
            Asrc2  <= "00";
            Fset   <= '0';
            op     <= decoded_op;
            ReW    <= '0';

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
        when rdM_wrRF =>  -- 001200A9 -- Auto_inc  XXX 00120029 -- without Auto_inc
          state                           <= wr_from_M2RF;
          if (ins_27_20(1) = '1') then RW <= p;  --'1';
          else RW                         <= '0';
          end if;

          IorD   <= '1';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '0';
          IW     <= '0';
          DW     <= '1';
          Rsrc   <= '0';
          M2R    <= "01";               --
          --RW    <= '0';
          AW     <= '0';
          BW     <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "00";
          Fset   <= '0';                -- p from Bctrl;
          op     <= "0100";             -- op from the Actrl;
          ReW    <= '0';

          WadSrc      <= "01";
          R1src       <= "00";
          op1sel      <= '0';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';

--------------------------------------------|
        when wrM_wrRF =>  -- 111200A3 -- Auto_inc  XXX 11120023 -- without Auto_inc
          state <= fetch;


          -- If W='1' then auto_inc else don't
          if (ins_27_20(1) = '1') then RW <= p;  --'1';
          else RW                         <= '0';
          end if;

          IorD   <= '1';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW     <= '1';
          IW     <= '0';
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "01";               --rd2p
          --RW    <= '1';
          AW     <= '0';
          BW     <= '0';
          --Asrc1 <= "00";
          mulSel <= '0';
          Asrc1  <= '0';
          Asrc2  <= "00";
          Fset   <= '0';                -- p from Bctrl;
          op     <= "0100";             -- op from the Actrl;
          ReW    <= '0';

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
        when addr_rdB =>                -- 010A0210
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
          mulSel     <= '0';
          Asrc1      <= '0';
          Asrc2      <= "00";
          Fset       <= '0';            -- p from Bctrl;
          op         <= "0100";         -- only add
          ReW        <= '1';

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
        when PC_plus4 =>                --002A10C8
          state <= brn;
          IorD  <= '0';
          --MR: out std_logic:='0';
          --  PW          <= '1';
          MW    <= '0';
          IW    <= '0';
          DW    <= '0';
          Rsrc  <= '0';
          M2R   <= "10";                --
          RW    <= '1';
          AW    <= '0';
          BW    <= '0';
          Asrc1 <= '0';
          Asrc2 <= "01";
          Fset  <= '0';                 -- p from Bctrl;
          op    <= "0100";              -- op from the Actrl;
          ReW   <= '1';

          WadSrc      <= "11";
          R1src       <= "00";
          op1sel      <= '0';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '0';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when mul_ck_MLA =>              -- 20820D00
          if (ins_27_20(1) = '0') then
            state <= only_mul;
          else state <= add_MLA;
          end if;
          IorD       <= '0';
          MW         <= '0';
          IW         <= '0';   --- Instruction won't update due to PC+4
          DW         <= '0';
          Rsrc       <= '0';
          M2R        <= "00";           --
          RW         <= '0';
          AW         <= '1';
          BW         <= '0';
          mulSel     <= '1';
          Asrc1      <= '1';
          Asrc2      <= "00";
          Fset       <= '0';
          op         <= "0100";
          ReW        <= '0';


          WadSrc      <= "00";
          R1src       <= "10";
          op1sel      <= '0';
          SType       <= "00";
          ShiftAmtSel <= '0';
          Shift       <= '0';
          MulW        <= '1';
          ShiftW      <= '0';
          op1update   <= '0';
--------------------------------------------|
        when only_mul =>                --000E8C00
          state  <= wr_mul;
          IorD   <= '0';
          MW     <= '0';
          IW     <= '0';   --- Instruction won't update due to PC+4
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "00";               --
          RW     <= '0';
          AW     <= '0';
          BW     <= '0';
          mulSel <= '1';
          Asrc1  <= '1';
          Asrc2  <= "00";
          Fset   <= '0';
          op     <= "1101";
          ReW    <= '1';


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
        when add_MLA =>                 -- 000A0C00
          state  <= wr_mul;
          IorD   <= '0';
          MW     <= '0';
          IW     <= '0';   --- Instruction won't update due to PC+4
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "00";               --
          RW     <= '0';
          AW     <= '0';
          BW     <= '0';
          mulSel <= '1';
          Asrc1  <= '1';
          Asrc2  <= "00";
          Fset   <= '0';
          op     <= "0100";
          ReW    <= '1';


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
        when wr_mul =>                  -- 00120CA0
          state  <= fetch;
          state  <= wr_mul;
          IorD   <= '0';
          MW     <= '0';
          IW     <= '0';   --- Instruction won't update due to PC+4
          DW     <= '0';
          Rsrc   <= '0';
          M2R    <= "01";               --
          RW     <= p;                  --'1';
          AW     <= '0';
          BW     <= '0';
          mulSel <= '1';
          Asrc1  <= '1';
          Asrc2  <= "00";
          Fset   <= '0';
          op     <= "0100";
          ReW    <= '0';

          WadSrc      <= "01";
          R1src       <= "00";
          op1sel      <= '0';
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
