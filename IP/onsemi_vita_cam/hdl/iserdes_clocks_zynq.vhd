-- *********************************************************************
-- Copyright 2008, Cypress Semiconductor Corporation.
--
-- This software is owned by Cypress Semiconductor Corporation (Cypress)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of Cypress.
--
-- Disclaimer: Cypress makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. Cypress reserves the right to make changes without further
-- notice to the materials described herein. Cypress does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. Cypress' products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the Cypress Software License Agreement.
--
-- *********************************************************************
-- Author         : $Author: gert.rijckbosch $ @ cypress.com
-- Department     : MPD_BE
-- Date           : $Date: 2011-05-13 10:06:42 +0200 (vr, 13 mei 2011) $
-- Revision       : $Revision: 943 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

-------------------
-- LIBRARY USAGE --
-------------------
--common:
---------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

--xilinx:
---------
--Library XilinxCoreLib;
library unisim;
use unisim.vcomponents.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_clocks_zynq is
    generic (
        SIMULATION   : integer := 0;
        DATAWIDTH    : integer := 10;    -- can be 4, 6, 8 or 10 for DDR, can be 2, 3, 4, 5, 6, 7, or 8 for SDR.
        DATA_RATE    : string  := "DDR"; -- DDR/SDR
        CLKSPEED     : integer := 50;    -- APPCLK speed in MHz. Everything is generated from Appclk to be as sync as possible
        --DATAWIDTH, DATARATE, and clockspeed are used to calculate high speed clk speed.
        --SIM_DEVICE   : string  := "VIRTEX5"; --VIRTEX4/VIRTEX5, for BUFR
        C_FAMILY     : string  := "zynq";
        DIFF_TERM    : boolean := TRUE;
        USE_INPLL    : boolean := TRUE
    );
    port
    (
        CLOCK              : in    std_logic;  --appclock
        RESET              : in    std_logic;  --active high reset

        CLK_RDY            : out    std_logic; --CLK status (locked)
        CLK_STATUS         : out    std_logic_vector(15 downto 0); -- extended status
                                                                   -- 8 LSBs: transmit clk (if any)
                                                                   -- 8 MSBs: receive clk (if any)

        --reset for synchronizer between clk_div and App_clk
        CLK_DIV_RESET      : out std_logic;

        -- to iserdes
        CLK                : out   std_logic;
        CLKb               : out   std_logic;
        CLKDIV8            : out   std_logic;
        CLKDIV             : out   std_logic;

        -- from sensor (only used when USED_EXT_CLK = YES)

        HS_IN_CLK          : in    std_logic;
        HS_IN_CLKb         : in    std_logic
    );

end iserdes_clocks_zynq;

architecture rtl of iserdes_clocks_zynq is

-- functions
function calcclockdivider (
    DATAWIDTH : integer;
    DATA_RATE : string
)
return integer is
variable output : integer := 0;
begin
    if (DATA_RATE = "SDR") then
        output := DATAWIDTH;
    else
        output := DATAWIDTH/2;
    end if;

    return output;

end function;

function checkBUFRdividable (
    clockdivider : integer
)
return boolean is
variable output : boolean := FALSE;

begin
    if
    (
        clockdivider = 2 or
        clockdivider = 3 or
        clockdivider = 4 or
        clockdivider = 5 or
        clockdivider = 6 or
        clockdivider = 7 or
        clockdivider = 8
    ) then
         output := TRUE;
     else
         output := FALSE;
     end if;

    return output;
end function;

function calcperiod (
    CLKSPEED   : integer;
    MULTIPLIER : integer
)
return real is
variable output : real := 0.0;

begin

    output := 1000.0/real(CLKSPEED*MULTIPLIER);

    return output;

end function;

function setlocktime (
    USECLKFX     : boolean;
    USEPLL       : boolean;
    SIMULATION   : integer;
    CLKSPEED     : integer
)
return std_logic_vector is
variable output : std_logic_vector(23 downto 0) := X"000000";

begin

    if (SIMULATION > 0) then
        output :=  X"000080";
    else
        if (USEPLL = TRUE) then --PLL lock time is always 100us
            output := std_logic_vector(to_unsigned((CLKSPEED*100),24));
        elsif (USECLKFX = TRUE) then --DFS locktime is always 10ms
            output := std_logic_vector(to_unsigned((CLKSPEED*10000),24));
        else --locktime is worst case for 30MHz; 5000us resulting in 150000 clocks
            output := std_logic_vector(to_unsigned(150000,24));
        end if;
    end if;

    return output;

end function;

function calcinpllmultiplier (
    CLKSPEED     : integer
)
return integer is
variable output : integer := 1;
begin
    -- PLL frequency needs to be within 400MHz and 1000MHz

    if (CLKSPEED > 500) then
        output := 1;
    elsif (CLKSPEED > 250) then
        output := 2;
    elsif (CLKSPEED > 125) then
        output := 4;
    else
        output := 8;
    end if;

    return output;

end function;

--constants
constant clockdivider  : integer := calcclockdivider(DATAWIDTH, DATA_RATE);
constant clockdivider8 : integer := calcclockdivider(8, DATA_RATE);
--constant BUFR_dividable  : boolean := checkBUFRdividable(clockdivider);
constant inpllmultiplier : integer := calcinpllmultiplier(CLKSPEED*clockdivider);

constant zero            : std_logic := '0';
constant one             : std_logic := '1';
constant zeros           : std_logic_vector(31 downto 0) := X"00000000";
constant ones            : std_logic_vector(31 downto 0) := X"FFFFFFFF";
constant LockTimeDIV     : std_logic_vector(23 downto 0) := setlocktime(FALSE, USE_INPLL, SIMULATION, CLKSPEED);
constant ResetTime        : std_logic_vector(23 downto 0) := X"000100";
--signals
type lockedmonitorstatetp is (
    Idle,
    AssertReset2,
    WaitLocked2,
    CheckLocked2,
    AssertReset3,
    WaitLocked3,
    CheckLocked3
);

signal lockedmonitorstate : lockedmonitorstatetp;

signal Cntr : std_logic_vector(23 downto 0);

signal hsinclk : std_logic;

signal clk_tmp : std_logic;

signal LOCKED : std_logic;


-- output of reset sequencer
signal divider_status : std_logic;

begin

-- DO bit assignment (DCM only)
-- DO[0]: Phase shift overflow
-- DO[1]: Clkin stopped
-- DO[2]: Clkfx stopped
-- DO[3]: Clkfb stopped

CLK_STATUS(15)          <= '0';
CLK_STATUS(14)          <= '1';
CLK_STATUS(13)          <= '1';
CLK_STATUS(12 downto 9) <= (others => '0');
CLK_STATUS(8)           <= divider_status;
CLK_STATUS(7)           <= '0';
CLK_STATUS(6)           <= '1';
CLK_STATUS(5)           <= '1';
CLK_STATUS(4 downto 1)  <= (others => '0');
CLK_STATUS(0)           <= '1';

-- connect DCM input to appclock when used as a multiplier
-- connect DCM input to incoming hsclk when used as a divider

CLK_DIV_RESET<= RESET; --FIXME should be in reset until a clock is comming from the device find a way to detect this.

-- clocks in
-- high speed clock in

--assume always differential
IBUFDS_inst : IBUFDS
    generic map
    (
        CAPACITANCE      => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" (Virtex-4 only)
        DIFF_TERM        => DIFF_TERM,   -- Differential Termination (Virtex-4/5, Spartan-3E/3A)
        IBUF_DELAY_VALUE => "0",         -- Specify the amount of added input delay for buffer, "0"-"16" (Spartan-3E/3A only)
        IFD_DELAY_VALUE  => "AUTO",      -- Specify the amount of added delay for input register, "AUTO", "0"-"8" (Spartan-3E/3A only)
        IOSTANDARD       => "DEFAULT"
    )
    port map
    (
        O  => hsinclk,   -- Clock buffer output
        I  => HS_IN_CLK, -- Diff_p clock buffer input (connect directly to top-level port)
        IB => HS_IN_CLKb -- Diff_n clock buffer input (connect directly to top-level port)
    );


-- uses BUFIO because the only clocked instances with this clock are in the IO column
-- is limited to one clockregion
BUFIO_regional_hs_clk_in : BUFIO
    port map
    (
        O => clk_tmp, -- Clock buffer output
        I => hsinclk  -- Clock buffer input
    );

CLK  <= clk_tmp;
CLKb <= clk_tmp;

gen_divider_2: if (clockdivider = 2) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "2", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            SIM_DEVICE  => "7series"
        )
        port map
        (
            O   => CLKDIV, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider_2;

gen_divider_3: if (clockdivider = 3) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "3", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            --SIM_DEVICE  => SIM_DEVICE
            SIM_DEVICE  => "7series"
        )
        port map
        (
            O   => CLKDIV, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider_3;

gen_divider_4: if (clockdivider = 4) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "4", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            SIM_DEVICE  => "7series"
        )
        port map
        (
            O   => CLKDIV, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider_4;

gen_divider_5: if (clockdivider = 5) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "5", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            SIM_DEVICE  => "7series"
        )
        port map
        (
            O   => CLKDIV, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider_5;

gen_divider_6: if (clockdivider = 6) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "6", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            SIM_DEVICE  => "7series"
        )
        port map 
        (
            O   => CLKDIV, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider_6;

gen_divider_7: if (clockdivider = 7) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "7", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            SIM_DEVICE  => "7series"
        )
        port map
        (
            O   => CLKDIV, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider_7;

gen_divider_8: if (clockdivider = 8) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "8", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            SIM_DEVICE  => "7series"
        )
        port map
        (
            O   => CLKDIV, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider_8;

gen_divider8_4: if (clockdivider8 = 4) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "4", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            SIM_DEVICE  => "7series"
        )
        port map
        (
            O   => CLKDIV8, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider8_4;

gen_divider8_8: if (clockdivider8 = 8) generate
    BUFR_regional_hs_clk_in : BUFR
        generic map
        (
            BUFR_DIVIDE => "8", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            SIM_DEVICE  => "7series"
        )
        port map
        (
            O   => CLKDIV8, -- Clock buffer output
            CE  => one,
            CLR => zero,
            I   => hsinclk -- Clock buffer input
        );
end generate gen_divider8_8;

locked_monitor_process : process (RESET, CLOCK)
begin
if (RESET = '1') then
    LOCKED <= '0';
    divider_status <= '0';
    CLK_RDY <= '0';
    Cntr <= (others => '1');
    lockedmonitorstate <= Idle;

elsif (CLOCK = '1' and CLOCK'event) then

    LOCKED  <= divider_status;
    CLK_RDY <= LOCKED;

    case lockedmonitorstate is
        when Idle =>
            Cntr <= ResetTime; --reset should be asserted minimum one CLKDIV cycle
            divider_status <= '1';

        when AssertReset2 =>
            If (Cntr(Cntr'high) = '1') then
                Cntr               <= LockTimeDIV; --Cntr should be as long as lock time
                lockedmonitorstate <= WaitLocked2;
            else
                Cntr <= Cntr - '1';
            end if;

        when WaitLocked2 =>
            if (Cntr(Cntr'high) = '1') then
                lockedmonitorstate <= CheckLocked2;
            else
                Cntr <= Cntr - '1';
            end if;

         when CheckLocked2 =>
            Cntr               <= ResetTime; --reset should be asserted minimum one CLKDIV cycle
            lockedmonitorstate <= AssertReset3;

        -- code needs to lock twice to avoid power up problems.
        when AssertReset3 =>
            If (Cntr(Cntr'high) = '1') then
                Cntr               <= LockTimeDIV; --Cntr should be as long as lock time
                lockedmonitorstate <= WaitLocked3;
            else
                Cntr <= Cntr - '1';
            end if;

        when WaitLocked3 =>
            if (Cntr(Cntr'high) = '1') then
                lockedmonitorstate <= CheckLocked3;
            else
                Cntr <= Cntr - '1';
            end if;

         when CheckLocked3 =>
            divider_status     <= '1';
            lockedmonitorstate <= Idle;

        when others =>
            lockedmonitorstate <= Idle;

    end case;

end if;
end process;

end rtl;
