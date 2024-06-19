Program Suspension;
MONITOR PC;
CONST nmrProcesos = 20;
VAR i:INTEGER;
	delayed:array[0..nmrProcesos] of BOOLEAN;
	time:array[0..nmrProcesos] of INTEGER;
	cond:array[0..nmrProcesos] of CONDITION;


PROCEDURE oneSecondHasPassed;
VAR i:INTEGER;
BEGIN
	FOR i:=0 TO nmrProcesos-1 DO
	IF delayed[i] THEN BEGIN
		time[i] := time[i] - 1;
		IF time[i] = 0 THEN BEGIN
			delayed[i] := false;
			SIGNALC(cond[i]);
		END;
	END;
END;

PROCEDURE delayMe(myself: INTEGER; interval: INTEGER);
BEGIN
	delayed[myself] := true;
	time[myself] := interval;
	WAITC(cond[myself]);
END;

BEGIN (*monitor*)
	FOR i:= 0 TO nmrProcesos-1 DO BEGIN
	delayed[i] := false;
	time[i] := 0;
	END;
END;

VAR i:INTEGER;
VAR currentTime:INTEGER := 0;
VAR output:BINARYSEM := 1;

PROCEDURE clock;
VAR 
	i:INTEGER;
	j:INTEGER;
BEGIN
	FOR i := 1 to 10 DO BEGIN
	FOR j := 1 to 200 DO;
	currentTime := currentTime + 1;
	WAIT(output);
		writeln("1 second passed. CurrentTime: ", currentTime, " seconds.");
	SIGNAL(output);
	END;
END;

PROCEDURE process(ID: INTEGER);
BEGIN
	WAIT(output);
		writeln("I am the process ", ID, " and I go to sleep for ", ID*2, " seconds. Current time: ", currentTime);
	SIGNAL(output);
	delayMe(ID, ID * 2);
	WAIT(output);
		writeln("I am the process", ID, " and I just woke up. Current time: ", currentTime);
	SIGNAL(output);
END;

BEGIN
	COBEGIN
		clock;
		process(1);
		process(2);
		process(3);
		process(4);
	COEND;
END.