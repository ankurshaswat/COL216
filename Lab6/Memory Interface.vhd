library IEEE;
use IEEE.std_logic_1164.all;


entity Memory_Interface is
      port (
  HTRANS    : in  std_logic;
  MemSelect : in  std_logic;
  HADDR     : in  std_logic_vector (31 downto 0);
  HWRITE    : in  std_logic;
  HWDATA    : in  std_logic_vector (31 downto 0);
  clk       : in  std_logic;
  HREADYIN    : in std_logic;
  HREADYOUT    : out std_logic;
  HRDATA    : out std_logic_vector(31 downto 0);
  HSIZE: in std_logic_vector(1 downto 0);
  reset:in std_logic
  );
end entity Memory_Interface;



architecture arch of Memory_Interface is

  component Memory is
    port(Address     : in  std_logic_vector(31 downto 0);
         writeData   : in  std_logic_vector(31 downto 0);
         clock       : in  std_logic;
         outer       : out std_logic_vector(31 downto 0);
         MR          : in  std_logic;
         reset       : in  std_logic;
         MW          : in  std_logic;
         WriteEnable : in  std_logic_vector(3 downto 0));
  end component;

  component ProcessorMemoryPath is
    port (
      FromProcessor : in  std_logic_vector(31 downto 0);
      FromMemory    : in  std_logic_vector(31 downto 0);
      DTType        : in  std_logic_vector(2 downto 0);  -- last 2 bits tell type of tranfer 00 for word 01 for half 10 for byte
      -- bit index 3 tells     0 for zero extension and 1 for sign extension
      ByteOffset    : in  std_logic_vector(1 downto 0);
      ToProcessor   : out std_logic_vector(31 downto 0);
      ToMemory      : out std_logic_vector(31 downto 0);
      WriteEnable   : out std_logic_vector(3 downto 0));
  end component;

  type state_type is (init, assertAddress, wait1, wait2, wait3, ReadData, WriteData);
  signal state : state_type;
  signal W:std_logic;
  signal addr:std_logic_vector(31 downto 0);
  signal mem_out,mem_out_temp,HWDATA_modified:std_logic_vector(31 downto 0);
  signal MW:std_logic;
  signal write_enable_modified:std_logic_vector(3 downto 0);
  signal dttyper:std_logic_vector(2 downto 0);
begin

  process (clk)
  begin
    if (falling_edge(clk)) then
      case state is

        when init =>
          if(HTRANS = '0') then
            state <= init;
          else
            if(MemSelect = '1') then
              state <=assertAddress ;
            else
              state <= init;
            end if;
          end if;

        when assertAddress =>
          addr   <= HADDR;
          HREADYOUT <= '0';
          W      <= HWRITE;
          state  <= wait1;

        when wait1 =>
          HREADYOUT <= '0';
          state  <= wait2;

        when wait2 =>
          HREADYOUT <= '0';
          state  <= wait3;

        when wait3 =>
          HREADYOUT <= '1';
          if(W = '1') then
            state <= WriteData;
          else
            state <= ReadData;
          end if;

        when WriteData =>
          MW <= '1';
          state       <= init;

        when ReadData =>
          HRDATA <= mem_out;
          state  <= init;
      end case;
    end if;
  end process;

dttyper <= '1' & HSIZE;

    PMPath : ProcessorMemoryPath port map(
      FromProcessor => HWDATA,
      FromMemory    => mem_out_temp,
      DTType        => dttyper,               --
      ByteOffset    => "00",           --
      ToProcessor   => mem_out,
      ToMemory      => HWDATA_modified,
      WriteEnable   => write_enable_modified  --
      );


  Mem : Memory port map(address => HADDR, writeData => HWDATA_modified, outer => mem_out_temp,
   MR => '1', MW => MW, clock => clk, reset => reset, WriteEnable => write_enable_modified);


end architecture;
