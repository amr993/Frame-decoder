LIBRARY IEEE ;
USE ieee.std_logic_1164.ALL ;
-- Author: Amr Mohamed Taha
-- This a testbench for the frame decoder where I test more than one case
-- 1st case : Check the reset
-- 2nd case : All data are correct and the frame is in simple mode
-- 3rd case : All data are correct and the frame is in Extended mode
-- 4th case : Reset between frames
-- 5th case : Check if the SOF is not 7E
-- 6th case : Check if the ID is not 80 nor 81
-- 7th case : Check if 7E comes and I'm in the Error state
-- 8th case : Check if EOF not E7 
ENTITY Decoder_Tb IS
END ENTITY ;
ARCHITECTURE TB OF Decoder_Tb IS
COMPONENT Frame_Decoder IS
PORT(
	clk , reset , vdd , vss  : IN std_logic ;
	word_in : IN std_logic_vector (7 downto 0);
	e : OUT std_logic ;
	address , data : OUT std_logic_vector (7 downto 0)
);
End COMPONENT ;
SIGNAL clk, reset , e : std_logic;
SIGNAL vdd : std_logic := '1' ;
SIGNAL vss : std_logic := '0' ;
SIGNAL word_in , address , data : std_logic_vector (7 downto 0);

constant clk_period : time := 100 ns ;
FOR FD : Frame_Decoder USE ENTITY work.Frame_Decoder (moore_2);
BEGIN
FD : Frame_Decoder PORT MAP ( clk => clk , reset => reset , vdd => vdd , vss => vss , word_in => word_in , e => e , address => address , data => data );
	
clock : PROCESS IS
	BEGIN
 	clk <= '0' , '1' AFTER clk_period ;
	WAIT FOR 200 ns;
END PROCESS clock ;

sg : PROCESS IS
	BEGIN
--1st case
	reset  <= '1' ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: Reset1 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: Reset1 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: Reset1 case data"    SEVERITY warning;
	
-- 2nd case
	reset  <= '0' ;
	word_in <= x"7E" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: SOF1 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: SOF1 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: SOF1 case data"    SEVERITY warning;
	WAIT FOR clk_period ;	

	word_in <= x"80" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: ID frame1 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: ID frame1 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: ID frame1 case data"    SEVERITY warning;
	WAIT FOR clk_period ;
	
	word_in <= x"88" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: address frame1 case e"       SEVERITY failure;
	ASSERT address =x"88"  REPORT "Error: address frame1 case address" SEVERITY failure;
	ASSERT data =x"00"     REPORT "Error: address frame1 case data"    SEVERITY failure;
	WAIT FOR clk_period ;
	
	word_in <= x"77" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: data frame1 case e"       SEVERITY failure;
	ASSERT address =x"00"  REPORT "Error: data frame1 case address" SEVERITY failure;
	ASSERT data =x"77"     REPORT "Error: data frame1 case data"    SEVERITY failure;
	WAIT FOR clk_period ;
	
	word_in <= x"E7" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: EOF1 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: EOF1 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: EOF1 case data"    SEVERITY warning;
	WAIT FOR clk_period ;
	
-- 3rd case
	word_in <= x"7E" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: SOF2 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: SOF2 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: SOF2 case data"    SEVERITY warning;
	WAIT FOR clk_period ;
	
	word_in <= x"81" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: ID frame2 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: ID frame2 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: ID frame2 case data"    SEVERITY warning;
	WAIT FOR clk_period ;

	word_in <= x"88" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: address frame2 case e"       SEVERITY failure;
	ASSERT address =x"88"  REPORT "Error: address frame2 case address" SEVERITY failure;
	ASSERT data =x"00"     REPORT "Error: address frame2 case data"    SEVERITY failure;
	WAIT FOR clk_period ;
	
	word_in <= x"77" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: data1 frame2 case e"       SEVERITY failure;
	ASSERT address =x"00"  REPORT "Error: data1 frame2 case address" SEVERITY failure;
	ASSERT data =x"77"     REPORT "Error: data1 frame2 case data"    SEVERITY failure;
	WAIT FOR clk_period ;
	
	word_in <= x"66" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: data2 frame2 case e"       SEVERITY failure;
	ASSERT address =x"00"  REPORT "Error: data2 frame2 case address" SEVERITY failure;
	ASSERT data =x"66"     REPORT "Error: data2 frame2 case data"    SEVERITY failure;
	WAIT FOR clk_period ;
	
	word_in <= x"E7" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: EOF2 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: EOF2 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: EOF2 case data"    SEVERITY warning;
	WAIT FOR clk_period ;

-- 4th case
	reset  <= '1' ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: Reset2 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: Reset2 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: Reset2 case data"    SEVERITY warning;
	WAIT FOR clk_period ;

-- 5th case
	reset <= '0' ;
	word_in <= x"EE" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "wrong SOF : Error: SOF case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "wrong SOF : Error: SOF case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "wrong SOF : Error: SOF case data"    SEVERITY warning;
	WAIT FOR clk_period ;

-- 6th case
	word_in <= x"7E" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: SOF3 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: SOF3 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: SOF3 case data"    SEVERITY warning;
	WAIT FOR clk_period ;

-- 7th case
	word_in <= x"88" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Wrong ID : Error: ID frame3 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Wrong ID : Error: ID frame3 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Wrong ID : Error: ID frame3 case data"    SEVERITY warning;
	WAIT FOR clk_period ;
	
-- 8th case
	word_in <= x"7E" ;
	WAIT FOR clk_period ;
	ASSERT e ='1'          REPORT "Error: SOF4 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: SOF4 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: SOF4 case data"    SEVERITY warning;
	WAIT FOR clk_period ;

	word_in <= x"80" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: ID frame4 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: ID frame4 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: ID frame4 case data"    SEVERITY warning;
	WAIT FOR clk_period ;

	word_in <= x"89" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: address frame4 case e"       SEVERITY failure;
	ASSERT address =x"89"  REPORT "Error: address frame4 case address" SEVERITY failure;
	ASSERT data =x"00"     REPORT "Error: address frame4 case data"    SEVERITY failure;
	WAIT FOR clk_period ;
	
	word_in <= x"77" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Error: data frame4 case e"       SEVERITY failure;
	ASSERT address =x"00"  REPORT "Error: data frame4 case address" SEVERITY failure;
	ASSERT data =x"77"     REPORT "Error: data frame4 case data"    SEVERITY failure;
	WAIT FOR clk_period ;
	
	word_in <= x"EF" ;
	WAIT FOR clk_period ;
	ASSERT e ='0'          REPORT "Wrong EOF : Error: EOF4 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Wrong EOF : Error: EOF4 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Wrong EOF : Error: EOF4 case data"    SEVERITY warning;
	WAIT FOR clk_period ;
	
	word_in <= x"7E" ;
	WAIT FOR clk_period ;
	ASSERT e ='1'          REPORT "Error: SOF5 case e"       SEVERITY warning;
	ASSERT address =x"00"  REPORT "Error: SOF5 case address" SEVERITY warning;
	ASSERT data =x"00"     REPORT "Error: SOF5 case data"    SEVERITY warning;
	
	WAIT ;
END PROCESS sg ;
END ARCHITECTURE ;
