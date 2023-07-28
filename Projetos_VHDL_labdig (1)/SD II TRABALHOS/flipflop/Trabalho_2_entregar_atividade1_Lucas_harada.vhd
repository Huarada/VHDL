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
   signal p1e , p2e, p4e, p8e : integer := 0 ;
   signal soma: integer := 0 ;
   
   begin
      
      vec <= entrada(9 downto 8) & entrada(3) & entrada (7 downto 5) & entrada(2) & entrada(4) & entrada(1 downto 0) ; --! facil pra contas
      

      
      
      p1 <= vec(8) xor vec(6) xor vec(4) xor vec(2) ; --! vendo bits de paridade
      p2 <= vec(9) xor vec(6) xor vec(5) xor vec(2) ;
      p4 <= vec(6) xor vec(5) xor vec(4) ;
      p8 <= vec(9) xor vec(8);
      
      p1e <= 1 when ((p1 xor entrada(0)) = '1') else 0 ; --! achar paridades erradas
      p2e <= 1 when ((p2 xor entrada(1)) = '1') else 0 ;
      p4e <= 1 when ((p4 xor entrada(2)) = '1') else 0 ;
      p8e <= 1 when ((p8 xor entrada(3)) = '1') else 0 ;
      
      
      soma <= 8*p8e + 4*p4e + 2*p2e + p1e; --! achar a posicao do erro
      
 
      

      
      dados <= entrada(9 downto 5) & not(entrada(4)) when soma = 3 else
               entrada(9 downto 6) & not(entrada(5)) & entrada(4) when soma = 5 else
               entrada(9 downto 7) & not(entrada(6)) & entrada(5 downto 4) when soma = 6 else
               entrada(9 downto 8) & not(entrada(7)) & entrada(6 downto 4) when soma = 7 else
               entrada(9) & not(entrada(8)) & entrada(7 downto 4) when soma = 9 else
               not(entrada(9)) & entrada(8 downto 4) when soma= 10 else
               entrada(9 downto 4);
                
      
      erro <=  '1' when (soma > 10 ) else '0' ;
      
end corretor;