library IEEE;
use IEEE.numeric_bit.all;

entity jokempo is

port ( 
  a: in bit_vector (1 downto 0); --! gesto do jogador A
  b: in bit_vector (1 downto 0); --! gesto do jogador B 
  y: out bit_vector (1 downto 0) --! resultado do jogo
    );
    end jokempo;    
    
architecture regras of jokempo is
    
    signal Av: bit_vector(2 downto 0);    
    signal Bv: bit_vector(2 downto 0);
    signal C : signed (2 downto 0);
    signal Z : bit_vector(1 downto 0);
    signal Csinal : signed(1 downto 0);
   
    
begin
 Av <= ('0' & a);  
 Bv <= ('0' & b);
 
 C <= signed(Av) - signed(Bv); --! tentar ser 01 quando a vence e 10 quando b vence  
 
 Csinal(1)<= '0';
 Csinal(0) <= C(2); --! necessario corrigir por fator 1 quando C da negativo, devido a base usada. 
 

 
 
 Z <= bit_vector( not( C(1 downto 0) - Csinal) ) ; --! not inverte resultados quando Avence, quando Bvence e empate, Mostrando os resultados corretos
 
 
 y <=  "00" when (a = "00" or b = "00" ) else Z ;
 
 end regras;
 
 
 
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



entity jokempotriplo is
port (
   a1, a2, a3 : in bit_vector(1 downto 0);  --! gesto do jogador A para os 3 jogos
   b1, b2, b3 : in bit_vector (1 downto 0); --! gesto do jogador B paraos 3 jogos
   z : out bit_vector(1 downto 0)           --! resultado da disputa
   ); 
   end jokempotriplo;
   
architecture calculo of jokempotriplo is   
   
   component jokempo is
      port ( 
         a: in bit_vector (1 downto 0); --! gesto do jogador A
         b: in bit_vector (1 downto 0); --! gesto do jogador B 
         y: out bit_vector (1 downto 0) --! resultado do jogo
         );
      end component;
      
   component melhordetres is 
      port(
         resultado1: in bit_vector (1 downto 0); --! resultado dos jogo1
         resultado2: in bit_vector (1 downto 0); --! resultado dos jogo2
         resultado3: in bit_vector (1 downto 0); --! resultado dos jogo3
         z: out bit_vector (1 downto 0) --! resultado da disputa
         );
      end component;
    
   signal jogo1, jogo2, jogo3 : bit_vector(1 downto 0);
      
         
   begin 
   
      xjogo1 : jokempo port map (a1, b1, jogo1);
   
      xjogo2 : jokempo port map (a2, b2, jogo2);
      
      xjogo3 : jokempo port map (a3, b3, jogo3);
      
      xvencedor : melhordetres port map (jogo1, jogo2, jogo3, z);
      
end calculo;
      
