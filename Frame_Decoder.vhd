-- Author: Amr Mohmed Taha
-- This VHDL code I intended to build a frame decoder where
-- it has two modes simple mode and extended mode 
-- where the simple mode has ID 80 and consistes of 8 byte address
-- and 8 byte data while the extended mode has ID 81 &consistes of
-- 8 byte address and 16 byte data.
-------------------Frame-------------------------
--          _____________________________________________
--         | SOF  |  ID  |Address |     DATA     |  EOF  |
-- Simple  |  7E  |  80  | 1byte  |     1byte    |  E7   |
-- Extended|__7E__|__81__|_1byte__|_____2byte____|__E7___|
-- 
--Note: There is an error state when the ID is not 80 nor 81 It goes to this state
--      or whe the EOF is not E7.
--  In the error state the error bit is '1' and the address and data are zeros.
--  If the SOF not 7E and we are in the SOF state so we will wait until 7E arrive.
--  If 7E arrives and we are in the Error state so the next state will be ID directly.
----------------------------------------------------------------------------------------
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
-- I'm going to build a 2 process moore FSM wher the output depends on the state only 
-- and doesn't depend on the input as the mealy.

ARCHITECTURE moore_2 OF Frame_Decoder IS
TYPE state_type IS ( SOF , ID , Add , EOF , Data1 , Data2 , Error ); -- states for the FSM
SIGNAL current_state : state_type ;
SIGNAL next_state : state_type ;
-- This falg is used to detect if the frame is in the simple or extended mode 
SIGNAL flag : std_logic ;
BEGIN

-- Process for clk & reset 
cs : PROCESS ( clk , reset )
Begin
	IF reset = '1' THEN 
	  current_state <= SOF ;
	ELSIF rising_edge (clk) THEN
	  current_state <= next_state ;
	END IF ;
END PROCESS cs ;

--Process for states outputs and trasistions
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
