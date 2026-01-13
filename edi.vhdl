library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.types.all;

entity EDI is
  port (
    wdbl, a_in, f_in: in std_logic_vector(7 downto 0);
    rdbl, f_out: out std_logic_vector(7 downto 0);
    io_in: in io_ports_in;
    io_out: out io_ports_out;
    clc: in calc;
    dst: in dest;
    clk: in std_logic;
    f_w, int: out std_logic
  );
end EDI;

architecture EDI of EDI is
  signal int_port: std_logic_vector(3 downto 0);
  signal cur_port: integer;
begin
  cur_port <= to_integer(unsigned(a_in));
  f_out <= f_in or X"04" when (dst = c0_ctx and io_ports_in(cur_port).tx = '1') else (others => 'Z');
  f_w <= '1' when dst = c0_ctx else 'Z';

  for i in 0 to 7 generate
    int <= '1' when io_ports_in(i).int = '1' else 'Z';
    int_port <= std_logic_vector(to_unsigned(i, 3)) when (io_ports(i).int = '1') else (others => 'Z');

    io_ports_out(i).clk <= clk;
  end generate;
  
  rdbl <= io_ports_in(cur_port).data when (clc = c8_in) else
          '00000' & int_port when (clc = c8_int) else
          (others => 'Z');

  process(clk)
  begin
    if (rising_edge(clk)) then
      if (dst = d8_out) then
        io_ports_out(cur).data <= wdbl;
        io_ports_out(cur).tx <= '1';
      end if;

      if (clc = c8_inp) then
        io_ports_out(cur).rx <= '1';
      end if;
  end process;

  process(io_ports_in(i).rx)
  begin
    io_ports_out(cur_port).tx <= '0';
  end process;
  
  io_ports_out(cur_port).data <= wdbl when (clc = )
end EDI;
