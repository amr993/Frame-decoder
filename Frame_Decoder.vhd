LIBRARY IEEE ;
USE IEEE.std_logic_1164.ALL ;

ENTITY Frame_Decoder IS
PORT(
	clk , reset , vdd , vss  : IN std_logic ;
	word_in : IN std_logic_vector (7 downto 0);
	e : OUT std_logic ;
	address , data : OUT std_logic_vector (7 downto 0)
);
End ENTITY ;

ARCHITECTURE moore_2 OF Frame_Decoder IS
TYPE state_type IS ( SOF , ID , Add , EOF , Data1 , Data2 , Error );
SIGNAL current_state : state_type ;
SIGNAL next_state : state_type ;
SIGNAL flag : std_logic ;
BEGIN
cs : PROCESS ( clk , reset )
Begin
	IF reset = '1' THEN 
	  current_state <= SOF ;
	ELSIF rising_edge (clk) THEN
	  current_state <= next_state ;
	END IF ;
END PROCESS cs ;

ns : PROCESS ( current_state , word_in )
BEGIN
	CASE current_state IS
	   WHEN SOF => 
		e <= '0';
		address <= x"00" ;
		data <= x"00" ;
		IF word_in =  x"7E" THEN
		   next_state <= ID ;
		ELSE
		   next_state <= SOF ;
		END IF ;
	   WHEN ID => 
		e <= '0';
		address <= x"00" ;
		data <= x"00" ;
		IF word_in = x"80" THEN
		   flag <= '1' ;
		   next_state <= Add ; 
		ELSIF word_in = x"81" THEN
		   flag <= '0' ;
		   next_state <= Add ;
		ELSE 
		   next_state <= Error ;
		END IF ;
	   WHEN Add => 
		e <= '0';
		address <= word_in ;
		data <= x"00" ;
		next_state <= Data1 ; 
	   WHEN Data1 =>
		e <= '0';
		address <= x"00" ;
		data <= word_in ;
		IF flag = '1' THEN
		next_state <= EOF ;
		ELSIF flag = '0'  THEN
		next_state <= Data2 ;
		END IF ;
		flag <= '0';
	   WHEN Data2 =>
		e <= '0';
		address <= x"00" ;
		data <= word_in ;
		next_state <= EOF ;
	   WHEN EOF =>
		e <= '0';
		address <= x"00" ;
		data <= x"00" ;
		IF word_in = x"E7" THEN 
		   next_state <= SOF ;
		ELSE
		   next_state <= Error ; 
		END IF ;
	   WHEN Error =>
		e <= '1';
		address <= x"00";
		data <= x"00";
		IF word_in = x"7E" THEN
		next_state <= ID ;
		ELSE
		next_state <= SOF ;
        	END IF ;
	END CASE ;
   END PROCESS ns;
END ARCHITECTURE ; 
