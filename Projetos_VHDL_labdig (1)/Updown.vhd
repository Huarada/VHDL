--updown.vhd
--updown hexadecimal de 4 bits


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity updown is
      port (clock, clear, entrasai: in std_logic;       --Fluxo de entrada
		 contagem: out std_logic_vector( 3 downto 0);   --Fluxos de saida
		 fim: out std_logic);
		 
end updown;


architecture comportamental of updown is
    
	signal IQ: integer range 0 to 15;          -- Sinal interno, necessario para fazer ligacao entre entradas e saidas
	signal overflow: std_logic;
	signal underflow: std_logic;
begin
    
	process (clock, clear, entrasai, IQ) -- codigo sequencial responde a alteracao desses sinais
	begin
	
	if clear = '1' then IQ <= 0;               -- sinal de reset
	elsif clock'event and clock = '1' then    -- caso nao resete, o circuito responde a borda de subida do clk

		if (entrasai ='1' and overflow = '0') then                 -- caso nao tenha preset, inicia a contagem
		 
		  IQ <= IQ + 1;                  -- se nao existir overflow, contagem padrao
		 
		elsif(entrasai = '0' and underflow = '0') then  -- se sair carro e nao existir underflow, subtracao padrao
              IQ <= IQ - 1;
		end if;	  
			  
		else IQ <= IQ;                        -- se tiver overflow ou undrflow, o valor nao muda
        end if;
   
   end process;
 
   contagem <= std_logic_vector( to_unsigned( IQ, contagem'length));  -- Traduz o valor de inteiro para vetor de bits
   
   fim <= '1' when IQ = 15 else '0' ;                                 -- fim identifica a parada antes de overflow
   overflow <= '1' when IQ = 15 else '0' ;
   underflow <= '1' when IQ = 0 else '0';

end comportamental;   
    