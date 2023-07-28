-- ControleVagas.vhd
--	Projeto para a Experiência 05: simulação do bloco de contagem de vagas que acusa se o estacionamento estar lotado. 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity contador is
		port(  
			clock, zera, conta, reduz, carrega: in std_logic;					-- Entradas declaradas como um único bit.
			entrada: in std_logic_vector (3 downto 0); 							-- Entrada declaradas como vetores de 4 bits.
			contagem: out std_logic_vector (3 downto 0); 						-- Entrada declaradas como vetores de 4 bits.
			fim: out std_logic 															-- Saída declarada como um único bit.
		);					
end contador;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- !!! O comparador foi alterado para 3 bits
entity comparador is
		port(
				A, B: in std_logic_vector(3 downto 0); 	-- Entrada declaradas como vetores de 4 bits.
				igual: out STD_LOGIC							 	-- Saída declarada como um único bit.
		);
end comparador;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity ControleVagas is
	port(
		clock, clear, entrada_saida: in std_logic;
		vagas: in std_logic_vector (3 downto 0);
		cheio: out std_logic
	);
end ControleVagas;
	
-- Na declaração de arquitetura, ocorre a descrição do comportamento 
-- da entidade enquanto bloco lógico.

-- ### [CONTADOR UP/DOWN COM "CONTA" E "REDUZ" E NÃO CÍCLICO]  
architecture behavior of contador is
		signal IQ: integer range 0 to 15; 											-- Signal que será utilizado no process, como contador inteiro de 0 a 15.
begin

		process(clock, zera, conta, reduz, carrega, entrada, IQ)
		begin 																				-- inicia o process
			if zera = '1' then IQ <= 0; 												-- Se a entrada "zera" é acionada, a contagem recomeça
			elsif clock'event and clock = '1' then 								-- A cada subida de clock...
				if carrega = '1' then 													-- Se a entrada "carrega" está em alto, o usuário deseja definir previamente a contagem
					IQ <= to_integer(unsigned(entrada)); 							-- Então a IQ recebe um pre-load com o valor da entrada "entrada"
				elsif conta = '1' then 													-- Caso contrário, se "conta" for 1...
					if IQ = 15 then IQ <= 15; 											-- Retorna ao zero, caso IQ esteja na última contagem (o contador é de 16 bits)
					else IQ <= IQ + 1; 													-- Incrementa o valor, caso IQ seja menor que 15.
					end if;
				elsif reduz = '1'then													-- Se "reduz" for 1... [IMPORTANTE: se "conta" e "reduz" são '1', "conta" é priorizado]
					if IQ = 0 then IQ <= 0;									    		-- Retorna ao 15, caso IQ esteja na última decrementação (o contador é de 16 bits)
					else IQ <= IQ - 1;													-- Decrementa o valor, caso IQ seja maior que 0.
					end if; 
				else IQ <= IQ; 															-- Se "conta" e "reduz" não estão em alto, IQ não se altera.
				end if;
			end if;
		end process;  																		-- Encerra o process.
		
		contagem <= std_logic_vector(to_unsigned(IQ, contagem'length)); 	-- A saída "contagem" recebe o valor de IQ, devidamente convertido de integer para logic_vector. 
		 
		fim <= '1' when IQ = 15 else '0'; 											-- A saída "fim" sinaliza o fim da contagem (serve como uma flag de saída).
		
end behavior;


-- comparador.vhd
-- 	comparador binario com entradas de 2 bits

library IEEE;
use IEEE.std_logic_1164.all;


-- Na declaração de arquitetura, ocorre a descrição do comportamento 
-- da entidade enquanto bloco lógico.
architecture behavior of comparador is
begin

		igual <= '1' when A = B else '0'; 					-- O bit "igual" recebe '1' quando A é igual a B, e '0' caso contrário.
		
end behavior;


architecture ControleVagas_arch of ControleVagas is
	component comparador is
		port(
			A: in std_logic_vector(3 downto 0);
			B: in std_logic_vector(3 downto 0);
			igual: out std_logic
		);
	end component comparador;
	
	component contador is
		port(
			clock, zera, conta, reduz, carrega: in std_logic;					
			entrada: in std_logic_vector (3 downto 0); 							
			contagem: out std_logic_vector (3 downto 0); 						
			fim: out std_logic 	
		);
	end component contador;
		

	signal qtd_vagas: std_logic_vector(3 downto 0);
	signal vagasOcupadas: std_logic_vector(3 downto 0);
	signal flagCheio: std_logic;
	
begin
	qtd_vagas <= vagas;
	
	COMPARADOR_component: comparador port map(
		A => qtd_vagas,
		B => vagasOcupadas,
		igual => flagCheio 
	);
	
	CONTADOR_component: contador port map(
		clock => clock,
		zera => clear,
		carrega => (flagCheio and entrada_saida), -- O estacionamento permance lotado enquanto nenhum carro sair
		conta => entrada_saida,
		reduz => NOT entrada_saida,
		entrada => qtd_vagas,
		contagem => vagasOcupadas,
		fim => open
	);

	cheio <= flagCheio;
	

end ControleVagas_arch;