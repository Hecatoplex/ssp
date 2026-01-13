library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.calc;
use work.types.dest;

entity ALU is
  port (
    clc: in calc;
    dst: in dest;
    ai, bi, xi, yi, si, fi, rdbl: in std_logic_vector(7 downto 0);
    ao, xo, yo, so, fo: out std_logic_vector(7 downto 0);
    wa, wx, wy, ws, wf: out std_logic
  );
end ALU;

architecture ALU of ALU is
  signal intx, lhsx, rhsx: signed(7 downto 0);
begin
  lhsx <= signed(ai) when (clc = c8_add or clc = c8_sub or clc = c8_bta or clc = c8_bto or clc = c8_btx or clc = c8_inc or clc = c8_dec or clc = c8_asl or clc = c8_asr or clc = c8_lsl or clc = c_lsr or clc = c8_rll or clc = c8_rlr) else
          signed(xi) when (clc = c8_inx or clc = c8_dex) else
          signed(yi) when (clc = c8_iny or clc = c8_dey) else
          signed(si) when (clc = c8_sp1 or clc = c8_sm1 or clc = c8_sp2 or clc = c8_sm2) else
          signed(fi) when (clc = c8_fls or clc = c8_flc) else
          signed(0);
  rhsx <= signed(rdbl);
  intx <= lhsx + rhsx when (clc = c8_add or clc = c8_sub or clc = c8_inc);
end ALU;
