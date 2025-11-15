------------------------------------------------------------------
--
-- [IE3-DI] Digital Circuits Winter Term 2025
--			Exercise 2
--
-- @name:   addsub_tb.vhd
-- @author: 
-- @description: Adder and Subtractor Unit with Status Flags
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
entity addsub_tb is
end entity;

---------------------------------
-- architecture
architecture behavioral of addsub_tb is

-- signal/constant declarations
signal cycle		: std_logic :='0';
signal A_s, B_s		: std_logic_vector(7 downto 0);
signal S_s			: std_logic_vector(7 downto 0);
signal sel_s		: std_logic;
signal C_s, V_s, N_s, Z_s : std_logic;

constant PERIOD		: time := 100 ns;
constant OFFSET		: time := 20 ns;

---------------------------------
-- component declaration for device under test (DUT)
component addsub
	port( 	
		A  	 : IN  std_logic_vector(7 downto 0);	-- Operand A (bitwidth 8)
     	B  	 : IN  std_logic_vector(7 downto 0);    -- Operand B (bitwidth 8)
        sel	 : IN  std_logic;						-- Select input (bitwidth 1) 

		S 	 : OUT std_logic_vector(7 downto 0);	-- Sum (bitwidth 8)
        C	 : OUT std_logic;						-- Carry Out (bitwidth 1)
        N	 : OUT std_logic;						-- Carry Out (bitwidth 1)
        V	 : OUT std_logic;						-- Carry Out (bitwidth 1)
        Z	 : OUT std_logic						-- Carry Out (bitwidth 1)
    );
end component;

---------------------------------
-- data type for an 8 bit test-vector (stimulus-response record)
type stimulus_response_type is record
	operand_A	: std_logic_vector (7 downto 0);
    operand_B	: std_logic_vector (7 downto 0);
    select_in	: std_logic;
    result_S	: std_logic_vector (7 downto 0);
    carry		: std_logic;
    overflow	: std_logic;
    negative	: std_logic;
    zero		: std_logic;
end record;

-- data type for a complete test-vector set, 
-- NOTE: "range <>" means "unconstrained array" of arbitrary size
type stimulus_response_array_type is array (natural range <>) of stimulus_response_type;

-- definition of test-vector set
constant TEST_DATA: stimulus_response_array_type := (
--    A,          B,         sel,  S,          C,   V,   N,   Z
	("00000010", "00000001", '0', "00000011", '0', '0', '0', '0'),
	("00000010", "00000001", '1', "00000001", '1', '0', '0', '0'),
	("01000000", "01111000", '0', "10111000", '0', '1', '1', '0'),
	("01000000", "01111000", '1', "11001000", '0', '0', '1', '0'),
-- TODO: Add test vectors here
-- ...
	("11111111", "00000001", '0', "00001000", '1', '0', '0', '1')
    );

begin

---------------------------------
-- simulation cycle
cycle <= not cycle after PERIOD/2;

---------------------------------
-- device under test (DUT) instantiation
i_addsub : addsub	
	port map( 	
		A  	=> A_s,
     	B  	=> B_s,
        sel	=> sel_s,

		S 	=> S_s,
        C	=> C_s,
        N	=> N_s,
        V	=> V_s,
        Z	=> Z_s
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
        sel_s <= TEST_DATA(I).select_in;
		-- propagation delay modeling
        wait for OFFSET;
		
        -- RESPONSE: compare results with expected results from test vector:
        assert S_s = TEST_DATA(I).result_S report "error in sum" severity warning;
		assert N_s = TEST_DATA(I).negative report "error in negative flag" severity warning;
		assert C_s = TEST_DATA(I).carry report "error in carry flag" severity warning;
		assert V_s = TEST_DATA(I).overflow report "error in overflow flag" severity warning;
		assert Z_s = TEST_DATA(I).zero report "error in zero flag" severity warning;
		
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