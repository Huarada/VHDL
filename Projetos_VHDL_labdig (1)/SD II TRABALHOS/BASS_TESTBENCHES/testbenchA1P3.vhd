-- Code your testbench here
library IEEE;

entity testbench is
end testbench;
architecture tb of testbench is
	component bass_hero_solo is
		port (clk, reset: in bit;
		target: in bit_vector (3 downto 0);
		played: in bit_vector (3 downto 0);
		score: out bit_vector (2 downto 0);
		cheers: out bit );
	end component;
    signal clk_in, reset_in: bit;
    signal target_in, played_in: bit_vector (3 downto 0);
	signal score_out: bit_vector (2 downto 0);
	signal cheers_out: bit;
    constant clockPeriod : time := 2 ns; -- clock period
	signal keep_simulating: bit := '0'; -- interrompe simulação
	signal clk_proc: bit; -- se construção alternativa do clock
    begin
    	clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
        DUT: bass_hero_solo port map(clk_in, reset_in , target_in, played_in, score_out, cheers_out);
        stimulus: process is -- Processo de testes
    -- Estrutura de dados com testes
		type test_record is record
			reset: bit; -- Nota: sem clock!
			target, played: bit_vector (3 downto 0);
			score: bit_vector (2 downto 0);
            cheers: bit;
			str : string(1 to 3); -- comment
		end record;
-- Vetor com testes
		type tests_array is array (natural range <>) of test_record;
		constant tests : tests_array :=
-- 			 R     t       p       s     c    str
		  (('1', "0000", "0000", "000", '0', "R01"),
       	   ('0', "0001", "0001", "001", '0', "A01"),
           ('0', "0010", "0010", "010", '0', "A02"),
           ('0', "0110", "0110", "010", '1', "A03"),
           ('0', "1111", "1110", "001", '0', "E01"),
           ('0', "0010", "0010", "010", '0', "A04"),
           ('0', "1010", "1010", "010", '1', "A05"),
           ('0', "0010", "0010", "010", '1', "A06"),
           ('0', "0010", "0000", "001", '0', "E02"),
           ('0', "0110", "0010", "000", '0', "E03"),
           ('0', "1110", "0010", "111", '0', "E04"),
           ('0', "0011", "0000", "110", '0', "E05"),
           ('0', "1000", "0010", "110", '0', "E06"), -- Aqui começa os teste do enunciado, são marcados por TXX
           ('1', "0000", "0000", "000", '0', "T01"),
           ('0', "0100", "0100", "001", '0', "T02"),
           ('0', "0110", "0110", "010", '0', "T03"),
           ('0', "0100", "0100", "010", '1', "T04"),
           ('0', "1100", "1100", "010", '1', "T05"),
           ('0', "0001", "1001", "001", '0', "T06"),
           ('0', "0110", "1111", "000", '0', "T07"),
           ('0', "0010", "1101", "111", '0', "T08"),
           ('0', "1100", "0011", "110", '0', "T09"),
           ('0', "0001", "1010", "110", '0', "T10"),
           ('0', "0110", "0110", "111", '0', "T11"),
           ('0', "1100", "1100", "000", '0', "T12"),
           ('1', "0000", "0000", "000", '0', "T13"),--Segunda tabela
           ('0', "1100", "1100", "001", '0', "T14"),
           ('0', "1100", "0011", "000", '0', "T15"),
           ('0', "1100", "1100", "001", '0', "T16"),
           ('0', "1100", "1100", "010", '0', "T17"),
           ('0', "1100", "0000", "001", '0', "T18"),
           ('0', "1100", "1100", "010", '0', "T19"),
           ('1', "0010", "1101", "000", '0', "T20"),
           ('0', "1100", "0011", "111", '0', "T21"),
           ('0', "1100", "0011", "110", '0', "T22"),
           ('1', "0110", "0110", "000", '0', "T23"),
           ('0', "1100", "1100", "001", '0', "T24")
           );
           

		begin -- Conteúdo dos testes
			assert false report "Test start." severity note;
			keep_simulating <= '1'; -- Habilita clock
    
		for k in tests'range loop
			reset_in <= tests(k).reset;
			target_in <= tests(k).target;
            played_in <= tests(k).played;
		wait until (clk_in'event and clk_in='1'); 
		wait for clockPeriod/4; 
		assert (tests(k).score = score_out)
			report "Fail:score" & tests(k).str severity error;
        assert (tests(k).cheers = cheers_out)
			report "Fail:cheers" & tests(k).str severity error;
		end loop;

-- End of test
		assert false report "Test done." severity note;
		keep_simulating <= '0'; -- Desabilita clock
		wait; -- Fim da execucao
		end process;
end tb;
