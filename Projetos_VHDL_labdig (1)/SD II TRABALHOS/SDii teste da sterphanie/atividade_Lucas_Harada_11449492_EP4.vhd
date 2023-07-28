library IEEE;
use IEEE.numeric_bit.all;

entity alu is
	generic (
		size : natural := 10
	);
	port (
		A, B : in bit_vector(size-1 downto 0);
		F : out bit_vector(size-1 downto 0);
		S : in bit_vector(3 downto 0);
		Z : out bit;
		Ov : out bit;
		Co : out bit
	);
end entity alu;

architecture atividade2 of alu is
component alu1bit is
	port (
    	a, b, less, cin: in bit;
      	result, cout, set, overflow: out bit;
        ainvert, binvert: in bit;
      	operation: in bit_vector(1 downto 0)
    );
end component;

signal S_escolhe: bit_vector(1 downto 0);
signal result, result_menor, tudozero: bit_vector(size-1 downto 0);
signal set_result, overflow, cout_result: bit_vector(size-1 downto 0);
signal a_inverte, b_inverte: bit;

begin
S_escolhe <= S(1) & S(0);
a_inverte <= S(3); 
b_inverte <= S(2);

opera: for i in size-1 downto 0 generate

    operacoes_zero: if i=0 generate
      	zero: alu1bit port map (
     		a => A(i),
            b => B(i), 
     		less => '0', 
     		cin => b_inverte,
     		ainvert => a_inverte,
            binvert => b_inverte, 
     		result => result(i), 
     		cout => cout_result(i), 
     		set => set_result(i), 
     		overflow => overflow(i), 
     		operation => S_escolhe
     	);
    end generate;
    
    operacoes_nao_zero: if i>0 generate
      	naoz: alu1bit port map (
     		a => A(i),
            b => B(i), 
     		less => '0', 
     		cin => cout_result(i-1),
     		ainvert => a_inverte,
            binvert => b_inverte, 
     		result => result(i), 
     		cout => cout_result(i), 
     		set => set_result(i), 
     		overflow => overflow(i), 
     		operation => S_escolhe
     	);
    end generate;
    
end generate;

tudozero <= (others => '0');
result_menor <= (0 => '1', others => '0') when (unsigned(A) < unsigned(B)) else
				(others => '0');

------------ SAIDAS ------------

F <= result when (S /= "0111") else result_menor;
Z <= '1' when ((result = tudozero) AND (S /= "0111")) else 		-- Seletor nao menor
	 '1' when ((result_menor = tudozero) AND (S = "0111")) else -- Seletor menor
     '0';
Ov <= overflow(size-1);
Co <= cout_result(size-1);

end architecture;