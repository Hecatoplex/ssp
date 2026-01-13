library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ROM is
  port (
    adh, adl: in std_logic_vector(7 downto 0);
    r, mode: in std_logic;
    rdbh, rdbl: out std_logic_vector(7 downto 0)
  );
end ROM;

architecture ROM of ROM is
  type rom_type is array(32768 to 65535) of std_logic_vector(7 downto 0);
  signal storage: rom_type := (X"10", X"20", X"30", X"00", others => X"00");
  signal address: std_logic_vector(15 downto 0);
begin
  address <= adh&adl;
  rdbl <= storage(to_integer(unsigned(address))) when (r = '1') else
          (others => 'Z');
  rdbh <= storage(to_integer(unsigned(address)) + 1) when (r = '1' and mode = '1') else
          (others => 'Z');
end ROM;
