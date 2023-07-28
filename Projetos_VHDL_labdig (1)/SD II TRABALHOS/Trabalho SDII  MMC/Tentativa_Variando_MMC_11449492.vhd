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

  

   

  

architecture a_mmc of mmc is  

  

   

 Signal fim_aux : bit; 

signal a_temp, b_temp: bit_vector(15 downto 0);  

  

signal nSomas_aux: bit_vector(8 downto 0);  

  

type ciclos_maquina is (espera, comparar, DiferentesAB, IgualdadeAB, zero);  

  

signal estado: ciclos_maquina;  

  

   

  

begin  

  

   

  

eme: process (clock, inicia)  

  

	begin  

  

	if (reset = '1') then  

  

		estado <= espera;  


		fim <= '0';  

        Fim_aux  <= '0'; 

  

		nSomas <= "000000000";  

  

		MMC <= "0000000000000000";  
        
        
  

	elsif (clock'event and clock = '1') then  

  

		case estado is  

  

        	--------------------------  

  

  

        				when espera =>  

               if (fim_aux = '0') then

                nSomas_aux <= "000000000";  

  

                nSomas <= nSomas_aux;  

  

                fim <= '0';  

              Fim_aux <= '0'; 
              
              end if;
  
              
				if (inicia = '1' and fim_aux /= '1') then  

                  
                    
					a_temp <= bit_vector(unsigned("00000000"&A));   

  

                  	b_temp <= bit_vector(unsigned("00000000"&B));  

  

                  	estado <= comparar;  

  

                elsif ( fim_aux /= '1') then

  

                  	estado <= espera;  

  

				end if;  

  


  

  			when comparar =>  

  

				if (A = "00000000" OR B = "00000000") then    

  

                  	estado <= zero;  

  

				  

  

				elsif (a_temp /= b_temp) then					-- Teste - A diferente de B  

  

					estado <= DiferentesAB;  

  

				else										-- Teste - A igual a B  

  

					estado <= IgualdadeAB;  

  

				end if;  

  

            ----------------------------  

  

			when DiferentesAB =>  

  

				nSomas_aux <= bit_vector(unsigned(nSomas_aux) + 1);  

  

				if (a_temp > b_temp) then   

  

					b_temp <= bit_vector(unsigned(b_temp) + unsigned(B));  

  

				else  

  

					a_temp <= bit_vector(unsigned(a_temp) + unsigned(A));  

  

				end if;  

  

				estado <= comparar;  

  

            -----------------------  

  


			when IgualdadeAB =>  

  

				MMC <= a_temp;  

  

				fim <= '1';  

             Fim_aux <= '1'; 

  

				estado <= espera;  

  

				nSomas <= nSomas_aux;  

  

            -----------------------------  


  

            when zero =>  

  

            	MMC <= "0000000000000000";  

  

                fim <= '1';  

               Fim_aux  <= '1'; 

  

                nSomas <= (others => '0');  

  

                estado <= espera;  

  

		end case;  

  

	end if;  

  

end process;  

  

end architecture; 