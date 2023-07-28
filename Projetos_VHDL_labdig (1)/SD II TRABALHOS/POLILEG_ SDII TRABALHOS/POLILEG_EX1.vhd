library ieee;
use  Ieee.numeric_bit.all;

entity signExtend is
  port (
    i: in bit_vector(31 downto 0); -- input
	o: out bit_vector(63 downto 0) -- output
	);
 end signExtend;

architecture extensao of signExtend is



begin 






o <= bit_vector(resize(signed(i(20 downto 12)), 64))  when ((i(31 downto 21) = "11111000010") or (i(31 downto 21) = "11111000000")) else -- formato D 
     bit_vector(resize(signed(i(25 downto 0)), 64)) when (i(31 downto 26) = "000101") else -- Formato B 
	 bit_vector(resize(signed(i(23 downto 5)), 64)) when (i(31 downto 24) = "10110100") else --- Formato Cb
	 bit_vector(resize(signed(i(20 downto 16)), 64)) when (i(31 downto 21) = ("11001011000" or "10001011000" or "10001010000" or "10101010000"))-- Formato R 
	 ;

end architecture;
