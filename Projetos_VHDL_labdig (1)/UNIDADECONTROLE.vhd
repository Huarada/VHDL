library IEEE;                     -- CODIGO DA UNIDADE DE CONTROLE
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity UNIDADECONTROLE is
    port( MODO  : in std_logic;
	      CLK,CLR, PROX : in std_logic;
		  prod_conf,setor_conf,prod_lido, setor_lido     : in std_logic_vector(1 downto 0); -- informação da entrada_saida
		  ctrlprod_conf, ctrlsetor_conf, ctrlprod_lido, ctrlsetor_lido     : out std_logic_vector(1 downto 0); -- outputs da maquina q serao lidos pelo FD
		  Z1, ctrlPROX      : out std_logic);
end UNIDADECONTROLE;		  



architecture definicao of UNIDADECONTROLE is



  type state_type is (StateConf, StateOpr);
  signal PS,NS : state_type; --estado presente e estado futuro
begin 
  
  sync_proc: process(CLK,NS,CLR)
   begin
  
   if(CLR = '1') then
  --   PS <= StateConf;   voltamos pro estado configuracao no clear, acho q eh desnecessario so vou deixar comentado
  
   ctrlprod_conf <= "00";
   ctrlprod_lido <= "00";
   ctrlsetor_conf <= "00";
   ctrlsetor_lido <= "00"; -- ZERA TODOS OS PARAMETROS, INDEPENDENTE DO ESTADO NA UC
   
   elsif(rising_edge(CLK)) then 
     PS<= NS;
   end if;
  end process sync_proc;
  
  comb_proc: process(PS,MODO)       -- definiremos MODO = 0 como selecao pra configuracao, e MODO = 1 como selecao pra operacao
  begin
    Z1<= '0';  -- pre-assign output , verificar o estado da maquina q estamos (dado intermediario pra teste )
	case PS is 
	
	  when StateConf =>  -- o que irá ocorrer no estado StateConf , configuracao  
	  Z1<= '0';
	  ctrlPROX <= '0' -- NAO DEVE TER OPERACOES NO FLUXO DE DADO DURANTE A CONFIGURACAO, ENTAO PROX = proximo DEVE SER 0
	  
	  ctrlprod_conf <= prod_conf;                   -- em modo configuracao sera feita apenas o setup dos dados conf
	  ctrlsetor_conf <= setor_conf;
	  if (MODO = '1') then NS<= StateOpr;         -- irah pro estado de operacao apenas quando MODO for pra 1, durante o estado configuracao
	  else NS<= StateConf;      
	  end if;
	  
	  when StateOpr =>   -- o que irá ocorrer no estado StateOpr
	  
	  Z1 <= '1';
	  ctrlprod_lido <= prod_lido;
	  ctrlsetor_lido <= setor_lido;
	  ctrlPROX <= PROX; -- AS OPERACOES DO FD IRAO OCORRER POR CAUSA DESSA LINHA, PROX REPRESENTA O INPUT: proximo
	  
	  if( MODO = '1') then NS <= StateOpr;  -- MODO =1 continuara preso no estado operacao
	  else NS <= StateConf;                 -- caso contrario ira pro modo configuracao
	  end if;
	  
	  when others  =>  -- pegar as situacoes q nao foram abordadas
	  
	  Z1<= '0';
	  NS<= StateConf;
	 
	 end case;
	 
	end process comb_proc;
	
end definicao;