

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
		clock, clear, entrada_saida, entrada_saida_idosos: in std_logic;
		vagas: in std_logic_vector (3 downto 0);
		vagas_prioritarias: in std_logic_vector (3 downto 0);
		cheio: out std_logic;
		numeroIdosos: out std_logic_vector (3 downto 0)
	);
end ControleVagas;
	


library IEEE;                     -- CODIGO DA UNIDADE DE CONTROLE
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity my_fsml is
    port( TOG_EN  : in std_logic;
	      CLK,CLR : in std_logic;
		  E_S     : in std_logic; -- informação da entrada_saida
		  Z1      : out std_logic);
end my_fsml;		  

---------------------------------------------------------------------------------------------------------------------------------------------
--                                                              Controle Vagas
---------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;                                    -- Arquitetura da unidade de controle
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture fsml of my_fsml is
  type state_type is (ST0, ST1);
  signal PS,NS : state_type;
  signal Q     : std_logic;
begin 
  Q <= E_S;
  
  sync_proc: process(CLK,NS,CLR)
   begin
  
   if(CLR = '1') then
     PS <= ST0;
   elsif(rising_edge(CLK)) then 
     PS<= NS;
   end if;
  end process syn_proc;
  
  comb_proc: process(PSTOG_EN)
  begin
    Z1<= '0';  -- pre-assign output
	case PS is 
	
	  when ST0 =>  -- o que irá ocorrer no estado ST0
	  Z1<= '0';
	  if (TOG_EN = '1') then NS<= ST1;
	  else NS<= ST0; 
	  end if;
	  
	  when ST1 =>   -- o que irá ocorrer no estado ST1
	  
	  Z1 <= Q;
	  
	  if( TOG_EN = '1') then NS <= ST1;
	  else NS <= ST0;
	  end if;
	  
	  when others  =>  -- pegar as situacoes q nao foram abordadas
	  
	  Z1<= '0';
	  NS<= ST0;
	 
	 end case;
	 
	end process comb_proc;
	
end fsml;	
	  






---------------------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
		
    component fsml is
	
	     port( TOG_EN  : in std_logic;
	      CLK,CLR : in std_logic;
		  E_S     : in std_logic; -- informação da entrada_saida
		  Z1      : out std_logic);
    end my_fsml;	
	    
	
	
	
	
	signal qtd_vagas: std_logic_vector(3 downto 0);
	signal qtd_prioritarias: std_logic_vector(3 downto 0);
	signal vagasOcupadas, vagasOcupadasIdosos, vagasOcupadasPrioridade: std_logic_vector(3 downto 0);
	signal entrada_saida_total_depurado: std_logic;
	signal flagCheioNormal: std_logic;                                      -- Sinal pra Identificar vaga normal cheia
	signal flagCheioPrioridade: std_logic;                                       -- Sinal pra identificar vaga prioritaria cheia
	signal Z: std_logic;                                                    -- Sinal da entrada_saida_idoso_depurado pela unidade de controle
	
begin
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                                SISTEMA DE CONTAGEM DE VAGAS NORMAIS COM LIMITADOR DE OVERFLOW
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
	qtd_vagas <= vagas;

	COMPARADOR_VAGA_NORMAL_component: comparador port map(
		A => qtd_vagas,
		B => vagasOcupadas,
		igual => flagCheioNormal 
	);
	
	CONTADOR_VAGAS_NORMAIS_component: contador port map( 
		clock => clock,
		zera => clear,
		carrega => (flagCheioNormal and entrada_saida_total_depurado), -- O estacionamento permance lotado enquanto nenhum carro sair
		conta => entrada_saida_total_depurado,
		reduz => NOT entrada_saida_total_depurado,
		entrada => vagasOcupadas, -- A contagem é recarregada no número atual caso lote
		contagem => vagasOcupadas,
		fim => open
	);
	
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	                                 SISTEMA PRA CONTAR NUMERO TOTAL DE IDOSOS NO ESTACIONAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	CONTADOR_IDOSOS_component: contador port map(          -- CONTADOR DE IDOSOS
		clock => clock,
		zera => clear,
		carrega => (flagCheioNormal and entrada_saida_idosos), -- O estacionamento permance lotado enquanto nenhum carro sair
																								 -- Porém, se um carro sai e um carro de idoso entra, a contagem
																								 -- continua.
		conta => entrada_saida_idosos,
		reduz => NOT entrada_saida_idosos,
		entrada => vagasOcupadasIdosos, -- A contagem é recarregada no número atual caso lote
		contagem => vagasOcupadasIdosos,
		fim => open
	);
	
	entrada_saida_total_depurado_depurado <= entrada_saida OR Z;    -- SOMA ENTRADA_SAIDA_IDOSO SEJA 1 COM VAGA_PRIORITARIA CHEIA ou  ENTRADA_SAIDA DE CARROS PADRAO




------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                            SISTEMA DE CONTAGEM PARA VAGAS PRIORITARIAS COM LIMITADOR DE OVERFLOW
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	qtd_prioritarias <= vagas_prioritarias;

	COMPARADOR_VAGA_PRIORITARIA_component: comparador port map(
		A => qtd_prioritarias
		B => vagasOcupadasPrioridade,
		igual => flagCheioPrioridade
	);
	
	
	CONTADOR_VAGAS_NORMAIS_component: contador port map( 
		clock => clock,
		zera => clear,
		carrega => (flagCheioPrioridade and entrada_saida_idosos), -- O estacionamento permance lotado enquanto nenhum carro sair
		conta => entrada_saida_idosos,
		reduz => NOT entrada_saida_idosos,
		entrada => vagasOcupadasPrioridade, -- A contagem é recarregada no número atual caso lote
		contagem => vagasOcupadasPrioridade,
		fim => open
	);
	-- TALVEZ SEJA NECESSARIO CRIAR UM OUTPUT PRA DEBUGAR AQUI
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --                                                           UNIDADE DE CONTROLE 
 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

   UNIDADE_DE_CONTROLE_component: fsml port map(
          TOG_EN  => flagCheioPrioridade,
	      CLK => clock,
		  CLR => clear,
		  E_S => entrada_saida_idosos,
		  Z1  => Z);
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	
	










------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	cheio <= flagCheioNormal and flagCheioPrioridade;
	numeroIdosos <= vagasOcupadasIdosos;     -- output contagem total de idosos
	

end ControleVagas_arch;