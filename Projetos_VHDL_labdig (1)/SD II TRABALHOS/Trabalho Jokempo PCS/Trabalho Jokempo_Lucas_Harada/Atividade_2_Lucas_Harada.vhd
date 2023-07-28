entity melhordetres is
port(
 resultado1: in bit_vector (1 downto 0); --! resultado dos jogo1
 resultado2: in bit_vector (1 downto 0); --! resultado dos jogo2
 resultado3: in bit_vector (1 downto 0); --! resultado dos jogo3
 z: out bit_vector (1 downto 0) --! resultado da disputa
 );
   end melhordetres;
   
architecture contador of melhordetres is
  
  signal AB : bit_vector (1 downto 0);
  signal C : bit_vector (1 downto 0);
  signal D : bit_vector (1 downto 0);
  signal empate : bit ;
  
    begin
    
    AB <= resultado1 and resultado2; --! analise entre dois primeiros resultados
    empate <= '1' when (resultado1 = "11" or resultado2 = "11") else '0';
    
    C <= "11" when (AB = "00" and resultado1 /= "00" and resultado2 /= "00") else AB ; --! J1 vencer e depois J2 vencer eh o mesmo que empate, e vice-versa
    
    D <= resultado3 and C ; --! analise total sem corrigir, eh preciso corrigir devido aos empates e ao falso 00
    
    Z <= C when ( D = "00" and C /= "00" and resultado3 /= "00" and empate = '0') else "11" when ( D = "00" and C /= "00" and resultado3 /= "00" and empate = '1') else D;
    
    end contador;