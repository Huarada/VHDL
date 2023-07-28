library IEEE;
use IEEE.numeric_bit.all;

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
