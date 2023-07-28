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