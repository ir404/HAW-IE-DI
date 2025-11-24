------------------------------------------------------------
-- File: "dff_tb.vhd"

-- libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- entity
entity dff_tb is
end dff_tb;

-- architecture
architecture Behavioral of dff_tb is

    -- declare the design file (dff)
    component dff is
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            d : in STD_LOGIC;
            q : out STD_LOGIC
        ); 
    end component;

    -- signals in the testbench that are connected to the design file
    signal d_s, q_s : STD_LOGIC;
    signal clk_s : STD_LOGIC;
    signal rst_s : STD_LOGIC;

    -- constants for simulating the timing
    constant PERIOD : time := 10 ns;    -- period of one clock cycle
    constant OFFSET : time := 1 ns;     -- small offset

begin
    -- instantiate the design file (dff)
    i_dff : dff
        port map(
            clk => clk_s,
            rst => rst_s,
            d => d_s,
            q => q_s
        );

    -- generate a clock
    clock: process
    begin
        while(true) loop
            clk_s <= '1';       -- set the clock to 0
            wait for PERIOD/2;  -- wait PERIOD/2
            clk_s <= '0';       -- set the clock to 1
            wait for PERIOD/2;  -- wait PERIOD/2
        end loop;
    end process;


    -- STIMULI process
    process
    begin
        -- 0. small offset
        -- (input signals are not synchronized with the clock)
        wait for OFFSET;

        -- 1. reset the dff for 3 clock periods
        rst_s <= '1'; wait for 3*PERIOD;

        -- 2. disable the reset
        rst_s <= '0'; wait for PERIOD;
        
        -- 3. APPLY STIMULI [1,0,0,1] for 1 period
        d_s <= '1';	wait for PERIOD;
        d_s <= '0';	wait for PERIOD;
        d_s <= '1';	wait for PERIOD;
        d_s <= '0';	wait for PERIOD;

        -- 4. APPLY STIMULI that are faster than the period
        d_s <= '1';	wait for PERIOD/5;
        d_s <= '0';	wait for PERIOD/5;
        d_s <= '1';	wait for PERIOD/5;
        d_s <= '0';	wait for PERIOD/5;
        d_s <= '1';	wait for PERIOD/5;
        d_s <= '0';	wait for PERIOD/5;
        
        -- 5. Simulation done
        assert false report "example finished" severity failure;
        wait;
    end process;
end Behavioral;
