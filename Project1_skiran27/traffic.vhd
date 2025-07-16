-- Copyright (C) 1991-2012 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 12.1 Build 177 11/07/2012 SJ Full Version"
-- CREATED		"Mon Sep 30 22:47:42 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY traffic IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		EWred :  OUT  STD_LOGIC;
		EWyellow :  OUT  STD_LOGIC;
		EWgreen :  OUT  STD_LOGIC;
		NSred :  OUT  STD_LOGIC;
		NSyellow :  OUT  STD_LOGIC;
		NSgreen :  OUT  STD_LOGIC
	);
END traffic;

ARCHITECTURE bdf_type OF traffic IS 

COMPONENT counter
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	A :  STD_LOGIC;
SIGNAL	B :  STD_LOGIC;
SIGNAL	C :  STD_LOGIC;
SIGNAL	D :  STD_LOGIC;
SIGNAL	NA :  STD_LOGIC;
SIGNAL	NB :  STD_LOGIC;
SIGNAL	NC :  STD_LOGIC;
SIGNAL	ND :  STD_LOGIC;
SIGNAL	q :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	VCC :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;


BEGIN 



SYNTHESIZED_WIRE_0 <= NB AND NC AND ND;


EWyellow <= A AND B AND C;


ND <= NOT(D);



EWred <= NA OR SYNTHESIZED_WIRE_0;


b2v_inst12 : counter
PORT MAP(clk => clk,
		 reset => reset,
		 enable => VCC,
		 q => q);


EWgreen <= SYNTHESIZED_WIRE_1 OR SYNTHESIZED_WIRE_2 OR SYNTHESIZED_WIRE_3;


NSred <= A OR SYNTHESIZED_WIRE_4;


SYNTHESIZED_WIRE_7 <= NA AND B AND NC;


SYNTHESIZED_WIRE_5 <= NA AND NC AND D;


SYNTHESIZED_WIRE_6 <= NA AND NB AND C;


NSgreen <= SYNTHESIZED_WIRE_5 OR SYNTHESIZED_WIRE_6 OR SYNTHESIZED_WIRE_7;

A <= q(3);



SYNTHESIZED_WIRE_3 <= A AND B AND NC;

B <= q(2);


C <= q(1);


D <= q(0);



SYNTHESIZED_WIRE_1 <= A AND NC AND D;


SYNTHESIZED_WIRE_2 <= A AND NB AND C;


SYNTHESIZED_WIRE_4 <= NB AND NC AND ND;


NSyellow <= NA AND B AND C;


NA <= NOT(A);



NB <= NOT(B);



NC <= NOT(C);



END bdf_type;