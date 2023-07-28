library ieee;
use ieee.numeric_bit.all;

entity hamming is
port(
entrada: in bit_vector(9 downto 0); --! 3 gestos mais 4 bits de paridade
dados : out bit_vector(5 downto 0); --! 3 gestos, corrigindo erros de 1 bit
erro: out bit --! erro nao corrigido
);
end hamming;

architecture corretor of hamming is 
   
   signal vec : bit_vector (9 downto 0);
   signal p1, p2, p4, p8 : bit;
   signal p1e , p2e, p4e, p8e : bit_vector( 3 downto 0);
   signal soma: signed(3 downto 0);
   
   begin
      
      vec <= entrada(9 downto 8) & entrada(3) & entrada (7 downto 5) & entrada(2) & entrada(4) & entrada(1 downto 0) ; --! facil pra contas
      

      
      
      p1 <=  vec(8) xor vec(6)  xor vec(4) xor vec(2) ; --! vendo bits de paridade
      p2 <=  vec(9) xor vec(6)  xor  vec(5) xor vec(2) ;
      p4 <= vec(6) xor vec(5) xor vec(4) ;
      p8 <= vec(9) xor vec(8);
      
      p1e <= "0001" when ((p1 xor entrada(0)) = '1') else "0000" ; --! achar paridades erradas
      p2e <= "0010" when ((p2 xor entrada(1)) = '1') else "0000" ;
      p4e <= "0100" when ((p4 xor entrada(2)) = '1') else "0000" ;
      p8e <= "1000" when ((p8 xor entrada(3)) = '1') else "0000" ;
      
      
      soma <= signed(p8e) + signed(p4e) + signed(p2e) + signed(p1e); --! achar a posicao do erro
      
 
      

      
      dados <= entrada(9 downto 5) & not(entrada(4)) when soma = "0011" else
               entrada(9 downto 6) & not(entrada(5)) & entrada(4) when soma = "0101" else
               entrada(9 downto 7) & not(entrada(6)) & entrada(5 downto 4) when soma = "0110" else
               entrada(9 downto 8) & not(entrada(7)) & entrada(6 downto 4) when soma = "0111" else
               entrada(9) & not(entrada(8)) & entrada(7 downto 4) when soma = "1001" else
               not(entrada(9)) & entrada(8 downto 4) when soma= "1010" else
               entrada(9 downto 4);
                
      
      erro <=  '1' when (bit_vector(soma) > "1010" ) else '0' ;
      
end corretor;