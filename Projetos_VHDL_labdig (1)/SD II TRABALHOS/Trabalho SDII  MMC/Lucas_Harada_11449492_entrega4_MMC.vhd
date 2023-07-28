library IEEE; 

use IEEE.numeric_bit.all; 

 

 

entity mmc is 

  port(  

      reset, clock: in bit; 

      inicia: in bit; 

      A,B: in bit_vector(7 downto 0); 

      fim: out bit; 

      nSomas: out bit_vector(8 downto 0); 

      MMC: out bit_vector(15 downto 0) 

      ); 

end mmc; 

 

 

architecture algoritmo of mmc is 

  signal a_auxi,b_auxil : bit_vector(15 downto 0); 

  signal somas_auxi : bit_vector(8 downto 0); 

  signal ATemp, BTemp : bit_vector(7 downto 0); 

  type Tipo_Estado is (aguarde , comparar , diferente , igual); 

  signal estado : Tipo_Estado; 

   

begin  

   process(clock,inicia)   

    begin 

   if (reset='1') then estado <= aguarde; fim <='0'; nSomas<="000000000"; 

   MMC<="0000000000000000"; 

   elsif (clock'event and clock='1') then 

   case estado is  

  

    when aguarde =>  

     

	  if inicia='1' then   

        ATemp<=A; BTemp<=B; 

	    fim <='0'; a_auxi<=bit_vector(unsigned("00000000"&A)) ; 

        b_auxil<=bit_vector(unsigned("00000000"&B)); somas_auxi<="000000000"; 

        estado <= comparar; 

      else  

        estado <= aguarde; 

      end if; 

     

    when comparar => 

      if (ATemp="00000000" or BTemp="00000000") then estado <=  igual ; fim<='1'; 

      else  

        if a_auxi/=b_auxil then estado <= diferente; 

        else         estado <= igual; 

	  end if; 

      end if; 

     

	when diferente =>  

	  somas_auxi<=bit_vector(unsigned(somas_auxi)+1); 

      if (a_auxi>b_auxil) then  

      b_auxil<= bit_vector((unsigned(b_auxil))+(unsigned(BTemp))); 

      else 

      A_auxi<=bit_vector((unsigned(a_auxi))+(unsigned(ATemp))) ;	   

	  end if; 

      estado<=comparar; 

       

	when igual => 

 	  fim<='1'; 

      nSomas<=somas_auxi; 

 	  MMC<=a_auxi; 

	  estado<=aguarde; 

       

	end case; 

   end if; 

  end process ;	 

end algoritmo; 