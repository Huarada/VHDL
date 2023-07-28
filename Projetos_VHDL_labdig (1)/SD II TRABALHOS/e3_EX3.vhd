library IEEE;
use IEEE.numeric_bit.all;



entity calc is 
 port(
    clock: in bit;
	reset: in bit;
	instruction: in bit_vector(16 downto 0);
	q1: out bit_vector(15 downto 0)
	);


end calc;

architecture calc_alg of calc is

signal code : bit_vector( 1 downto 0);
signal oper1,oper2, dest : bit_vector( 4 downto 0);

type q_out is array (0  to 31) of bit_vector(15 downto 0);  
signal qa: q_out;


signal imediato: bit_vector(15 downto 0);
signal contatemp: integer range -64 to 64 := 0;


begin	
code <= instruction( 16 downto 15);
oper2 <= instruction( 14 downto 10);
oper1 <= instruction(9 downto 5);
dest  <= instruction(4 downto 0);
  
  
  





  
  
  
  
process( clock, reset)
  begin
   if (reset = '1') then 
      limpar: for i in 31 downto 0 loop
      qa(i) <= "0000000000000000";
	  end loop;
  

   
   

   elsif(clock'event and clock ='1') then
    if(code = "00") then

	   qa(to_integer(unsigned(dest))) <= bit_vector( signed(qa(to_integer(unsigned(oper1)))) + signed(qa( to_integer(unsigned(oper2)))) ) ;   --!ADD

    
	
	elsif( code = "10") then
    
    

    qa(to_integer(unsigned(dest))) <= bit_vector(signed(qa(to_integer(unsigned(oper1))) ) - signed(qa( to_integer(unsigned(oper2))))) ;	--!SUB
	


	
	elsif (code = "01") then
    contatemp <= to_integer(signed(instruction(14 downto 10)));



	qa(to_integer(unsigned(dest))) <= bit_vector( signed(qa(to_integer(unsigned(oper1)))) + to_signed(contatemp,16) );  --!ADDI


	
	
	elsif (code = "11") then
	contatemp <= to_integer(signed(instruction(14 downto 10)));

	
 
	qa(to_integer(unsigned(dest))) <= bit_vector( signed(qa(to_integer(unsigned(oper1)))) - to_signed(contatemp,16) );  --!SUBI

	
	
	end if;

  end if;
  
  
end process ;

    q1<= qa(to_integer(unsigned(oper1)));

end calc_alg;
