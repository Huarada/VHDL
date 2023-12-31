-- comparador.vhd
--   comparador binario com entradas de 2 bits

library IEEE;
use IEEE.std_logic_1164.all;

entity comparador is 
    port (
	    A, B: in std_logic_vector( 1 downto 0);    -- entradas do sistema
		igual: out std_logic                       -- saida do sistema
		);

end comparador;

architecture comportamental of comparador is
begin
    
igual <= '1' when A = B else '0';                 -- sistema entrega 1 (verdadeiro ) quando a comaparacao A = B eh valida, caso contrario entrega 0

end comportamental;	