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
    adding: process(A, B, sel)

        -- variable declarations
        variable cin_v  : std_logic;                        -- Holds the carry as it ripples through
        variable S_v    : std_logic_vector(7 downto 0);     -- Holds the sum
        variable A_i    : std_logic;                        -- The i-th bit of A
        variable B_i    : std_logic;                        -- Holds the MUX output for B(i) - the i-th bit of B
        variable c7_v   : std_logic;                        -- Carry *into* bit at 7th index (for Overflow)
        variable cout_v : std_logic;                        -- Final carry out (for C flag)
        variable V_v    : std_logic;                        -- Overflow flag
        variable N_v    : std_logic;                        -- Negative flag
        variable Z_v    : std_logic;                        -- Zero flag

        begin
            ci_v := sel;            -- is 0 for addition; 1 for subtraction (A + NOT B + 1)

            for i in 0 to 7 loop
                A_i := A(i); 

                if sel = '1' then
                    B_i := not B(i);        -- for subtraction
                else 
                    B_i := B(i);            -- for addition
                end if;

                -- Perform the FA
                S_v     := A_i xor B_i xor ci_v;
                co_v    := (A_i and B_i) or (B_i and cin_v) or (A_i and cin_v);
            end loop;

            -- Set the flags
            V_v := cout_v xor c7_v;
            N_v := S_v(7);
            if S = "00000000" then
                Z = '1';
            else
                Z = '0';
            end if;

            -- Assign variable values to signals
            S <= S_v;
            C <= co_v;
            V <= V_v;
            N <= N_v;
            Z <= Z_v;
            
    end process;

end architecture rtl;
