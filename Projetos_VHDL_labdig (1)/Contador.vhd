--contador.vhd
--contador hexadecimal de 4 bits


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador is
      port (clock, zera, conta, carrega: in std_logic;
	     entrada: in std_logic_vector( 3 downto 0);     -- Fluxo de entrada
		 contagem: out std_logic_vector( 3 downto 0);   --Fluxos de saida
		 fim: out std_logic;)
		 
end contador;


architecture comportamental of contador is
    
	signal IQ: integer range 0 to 15;          -- Sinal interno, necessario para fazer ligacao entre entradas e saidas
begin
    
	process (clock, zera, conta, carrega, entrada, IQ) -- codigo sequencial responde a alteracao desses sinais
	begin
	
	if zera = '1' then IQ <= 0;               -- sinal de reset
	elsif clock'event and clock = '1' then    -- caso nao resete, o circuito responde a borda de subida do clk
	    if carrega = '1' then                 -- carrega faz o preset dos dados, igual a entrada
		  IQ <= to_integer(unsigned(entrada));
		elsif conta ='1' then                 -- caso nao tenha preset, inicia a contagem
		  if IQ = 15 then IQ <= 0;            -- caso do overflow
		  else IQ <= IQ + 1;                  -- se nao existir overflow, contagem padrao
		  end if;
		else IQ <= IQ;                        -- se a "contagem" nao for acionada, o valor nao muda
        end if;
    end if;
   end process;
 
   contagem <= std_logic_vector( to_unsigned( IQ, contagem'length));  -- Traduz o valor de inteiro para vetor de bits
   
   fim <= '1' when IQ = 15 else '0' ;                                 -- fim identifica a parada antes de overflow

end comportamental;   
    
  	
		 
	       
