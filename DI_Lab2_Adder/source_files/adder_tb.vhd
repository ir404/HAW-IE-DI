------------------------------------------------------------------
--
-- [IE3-DI] Digital Circuits Winter Term 2025
--			Exercise 2
--
-- @name:   adder_tb.vhd
-- @author: Imran Rizwan
-- @description: Ripple-Carry-Adder Unit
--				 TESTBENCH
--
-- (c) 2025 HAW Hamburg
--
------------------------------------------------------------------

---------------------------------
-- libraries / packages 
library IEEE;
use IEEE.std_logic_1164.all;

---------------------------------
-- entity
entity adder_tb is
end entity;

---------------------------------
-- architecture
architecture behavioral of adder_tb is

-- signal/constant declarations
signal cycle		: std_logic :='0';
signal A_s, B_s		: std_logic_vector(7 downto 0);
signal S_s			: std_logic_vector(7 downto 0);
signal ci_s			: std_logic;
signal co_s			: std_logic;

constant PERIOD		: time := 100 ns;
constant OFFSET		: time := 20 ns;

---------------------------------
-- component declaration for device under test (DUT)
component adder is	
	port( 	
        A 	 : in std_logic_vector(7 downto 0);
        B 	 : in std_logic_vector(7 downto 0);
        ci   : in std_logic;

        S	 : out std_logic_vector(7 downto 0);
        co   : out std_logic
    );
end component;

---------------------------------
-- data type for an 8 bit test-vector (stimulus-response record)
type stimulus_response_type is record
	operand_A	: std_logic_vector (7 downto 0);
    operand_B	: std_logic_vector (7 downto 0);
    carry_in	: std_logic;
    result_S	: std_logic_vector (7 downto 0);
    carry_out	: std_logic;
end record;

-- data type for a complete test-vector set, 
-- NOTE: "range <>" means "unconstrained array" of arbitrary size
type stimulus_response_array_type is array (natural range <>) of stimulus_response_type;

-- definition of test-vector set
constant TEST_DATA: stimulus_response_array_type := (
--    A,          B,         cin,  S,         cout
	("00000000", "00000001", '0', "00000001", '0'),
	("00000001", "00000001", '0', "00000010", '0'),
	("00000000", "00000001", '1', "00000010", '0'),

    ("00001111", "00000001", '0', "00010000", '0'),     -- 15 + 1 
	("01010101", "10101010", '0', "11111111", '0'),     
	("11111111", "00000001", '0', "00000000", '1'),     -- results in an overflow
	("10000000", "10000000", '0', "00000000", '1'),     -- MSB adds up and  overflow
	("11110000", "00001111", '1', "00000000", '1'),

-- ...
	("11111111", "00000000", '1', "00000000", '1')
);

begin

---------------------------------
-- simulation cycle
cycle <= not cycle after PERIOD/2;

---------------------------------
-- device under test (DUT) instantiation
dut: adder  
        port map(
            A    => A_s, 
            B    => B_s, 
            S    => S_s, 
            ci   => ci_s, 
            co   => co_s
		);
 

---------------------------------
-- stimuli process
stimuli: process
begin
   ---------------------------------

   -- wait for some initialization time
	wait for PERIOD; 
	wait for OFFSET; 
	
	-- iterate through all test vectors
	for I in TEST_DATA'range loop 
		-- wait for beginning of next simulation cycle
		wait until rising_edge(cycle);	
		
		-- STIMULI: apply current data set from TEST DATA
        A_s <= TEST_DATA(I).operand_A;  
        B_s <= TEST_DATA(I).operand_B; 	
        ci_s <= TEST_DATA(I).carry_in;	
		-- propagation delay modeling
        wait for OFFSET;
		
        -- RESPONSE: compare results with expected results from test vector:
        assert S_s = TEST_DATA(I).result_S report "error in sum" severity warning;
		assert co_s = TEST_DATA(I).carry_out report "error in carry_out" severity warning;
		
    end loop; 
	
   ---------------------------------
   -- test finished
	wait until rising_edge(cycle);
	wait for 3*PERIOD; 
	-- this stops simulation, don't be confused by the "failure" keyword
    assert false report "planned end of simulation" severity failure; 
    wait;
end process;
end behavioral;
