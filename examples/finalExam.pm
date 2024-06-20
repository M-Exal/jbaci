program barrier;

MONITOR M;
CONST numProcesos = 3;
VAR okToGo:CONDITION;
	n:INTEGER:=0;

PROCEDURE enter;
BEGIN
	n := n+1;
	IF n < numProcesos THEN
		WAITC(okToGo);
	signalC(okToGo);
END;

PROCEDURE exit;
BEGIN
	n := n-1;
	IF n > numProcesos THEN
		WAITC(okToGo);
	signalC(okToGo);
END;

BEGIN
END;

PROCEDURE proceso(i:INTEGER);
BEGIN
	enter;
	writeln("in");
	exit;
	writeln("out");
END;

BEGIN
	COBEGIN;
		proceso(1); proceso(2); proceso(3);
	COEND;
END.