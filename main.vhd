-- 2018 by Fabrizio Di Vittorio (fdivitto2013@gmail.com)


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity addr_decoder is
	port (A:        in  std_logic_vector (23 downto 12);
	      IDE_CS1:  out std_logic;
	      IDE_CS2:  out std_logic;
	      RTC_CS:   out std_logic;
	      NET_CS:   out std_logic;
	      SPARE_CS: out std_logic);

	attribute LOC: string;
	attribute LOC of A:        signal is "P1 P2 P3 P4 P5 P6 P7 P8 P9 P11 P13 P14";
	attribute LOC of IDE_CS1:  signal is "P16";
	attribute LOC of IDE_CS2:  signal is "P15";
	attribute LOC of RTC_CS:   signal is "P18";
	attribute LOC of NET_CS:   signal is "P17";
	attribute LOC of SPARE_CS: signal is "P19";
end addr_decoder;


architecture Behavioral of addr_decoder is
begin

  -- IDE_CS1 and IDE_CS2 (IDE HARD DRIVE) selection schema:
  -- A14  A13  A12    Address Range     Signal Selected (LOW)
  --  0    0    0    0xDA0000-0xDA0FFF         CS1
  --  0    0    1    0xDA1000-0xDA1FFF         CS2
  --  0    1    0    0xDA2000-0xDA2FFF         CS1
  --  0    1    1    0xDA3000-0xDA3FFF         CS2
  --  1    0    0    0xDA4000-0xDA4FFF         None
  --  1    0    1    0xDA5000-0xDA5FFF         None
  --  1    1    0    0xDA6000-0xDA6FFF         None
  --  1    1    1    0xDA7000-0xDA7FFF         None
  process (A)
  begin
    if A(23 downto 16) = x"DA" and A(14) = '0' then
			IDE_CS1 <= A(12);
			IDE_CS2 <= not A(12);
		else
			IDE_CS1 <= '1';
			IDE_CS2 <= '1';
		end if;
	end process;

  -- SPARE_CS (Real Time Clock) selected (LOW) for address in 0xD80000-0xD8FFFF
	SPARE_CS <= '0' when A(23 downto 16) = x"D8" else '1';

  -- RTC_CS   (Real Time Clock) selected (LOW) for addresses in 0xDC0000-0xDCFFFF
	RTC_CS   <= '0' when A(23 downto 16) = x"DC" else '1';

  -- NET_CS   (arcnet chip select) selected (LOW) for addresses in 0xD90000-0xD9FFFF
	NET_CS   <= '0' when A(23 downto 16) = x"D9" else '1';



end Behavioral;
