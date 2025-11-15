------------------------------------------------------------------
--
-- [IE3-DI] Digital Circuits Winter Term 2025
--			Exercise 2
--
-- @name:   addsub.vhd
-- @author: Imran Rizwan
-- @description: Adder and Subtractor
--				 DESIGN FILE
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
entity addsub is
	port( 	
		A  	 : IN  std_logic_vector(7 downto 0);	-- Operand A (bitwidth 8)
     	B  	 : IN  std_logic_vector(7 downto 0);    -- Operand B (bitwidth 8)
        sel  : IN  std_logic;                       -- Select input (bitwidth 1); 0 for addition; 1 for subtraction

		S 	 : OUT std_logic_vector(7 downto 0);	-- Sum (bitwidth 8)
        C	 : OUT std_logic;						-- Carry Out (bitwidth 1)
        V    : OUT std_logic;                       -- Overflow flag that denotes overflows of signed operations
        N    : OUT std_logic;                       -- Negative flag that denotes negative results
        Z    : OUT std_logic                        -- Negative flag that denotes whether the result is zero (if S==0; Z =1;else Z=0)
    );
end entity;

---------------------------------
-- architecture
architecture rtl of addsub is
begin
    ---------------------------------
    -- combinatorial process
    add_or_sub: process(A, B, sel)

        -- variable declarations
        variable S_v    : std_logic_vector(7 downto 0);     -- Holds the sum
        variable cin_v  : std_logic;                        -- Holds the carry bit as it ripples through
        variable A_i    : std_logic;                        -- The i-th bit of A
        variable B_i    : std_logic;                        -- Holds the MUX output for B(i) - the i-th bit of B
        variable c7_v   : std_logic;                        -- Carry *into* bit at 7th index (needed to determine Overflow)
        variable cout_v : std_logic;                        -- Final carry out (for C flag)
        variable V_v    : std_logic;                        -- Overflow flag
        variable N_v    : std_logic;                        -- Negative flag
        variable Z_v    : std_logic;                        -- Zero flag

        begin
            -- 1. Initialise variables
            cin_v := sel;            -- is 0 for addition; 1 for subtraction (A + NOT B + 1)
            S_v :=  "00000000";
            c7_v := '0';

            -- 2. Data processing - loops through every bit
            for i in 0 to 7 loop
                -- Get the i-th bit of each operand
                A_i := A(i); 
                B_i := B(i) xor sel;             -- MUX B - sel=0 for addition; sel=1 for subtraction

                -- Store the 7-th carry-into bit
                if i = 7 then 
                    c7_v := cin_v;
                end if;

                -- Standard FA logic using MUXed B
                S_v(i) := A_i xor B_i xor cin_v; 
                cin_v := (A_i and B_i) or (B_i and cin_v) or (A_i and cin_v);
            end loop;

            -- 3. Final carry-out bit is the latest carry-in bit (8-th bit)
            cout_v := cin_v;

            -- 4. Calculate the status flags
            V_v := cout_v xor c7_v; 
            N_v := S_v(7);
            if S_v = "00000000" then
                Z_v := '1';
            else
                Z_v := '0';
            end if;

            -- 5. Variable to signal re-assignment
            S <= S_v;
            C <= cout_v;
            V <= V_v;
            N <= N_v;
            Z <= Z_v;
            
    end process;

end architecture rtl;
