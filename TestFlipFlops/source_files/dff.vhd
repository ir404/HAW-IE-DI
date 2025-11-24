------------------------------------------------------------
-- File: "dff.vhd"

-- library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- entity
entity dff is
    port(
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        d   : in STD_LOGIC;
        q   : out STD_LOGIC
    ); 
end dff;

-- architecture
architecture rtl of dff is
-- signal declaration

begin

-- signal and output assignments



    -- sequential process
    sync : process (clk, rst)
    begin 
        if rst = '1' then                       -- reset
            q <= '0';
        elsif clk'event and clk = '1' then      -- rising clock edge
            q <= d;
        end if;
    end process;
end rtl;
