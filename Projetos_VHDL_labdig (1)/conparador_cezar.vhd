-- comparador.vhd
-- 	comparador binario com entradas de 2 bits

library IEEE;
use IEEE.std_logic_1164.all;

-- Na declaração de entidade, ocorre as a definição de
-- entradas e saídas da entidade. Isto é, das entradas
-- e saídas do bloco que terá a lógica explicitada na
-- arquitetura. 
entity comparador is
		port(
				A, B: in std_logic_vector(1 downto 0); 	-- Entrada declaradas como vetores de 4 bits.
				igual: out STD_LOGIC							 	-- Saída declarada como um único bit.
		);
end comparador;

-- Na declaração de arquitetura, ocorre a descrição do comportamento 
-- da entidade enquanto bloco lógico.
architecture behavior of comparador is
begin

		igual <= '1' when A = B else '0'; 					-- O bit "igual" recebe '1' quando A é igual a B, e '0' caso contrário.
		
end behavior;