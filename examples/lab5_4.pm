program Exo51;

VAR s:SEMAPHORE := 0;

PROCEDURE A;
BEGIN
	writeln("I am the process A");
END;

PROCEDURE B;
BEGIN
	writeln("I am the process B");
END;

PROCEDURE C;
BEGIN
	writeln("I am the process C");
END;

PROCEDURE D;
BEGIN
	writeln("I am the process D");
END;

BEGIN
	COBEGIN
		BEGIN
			A;
			WAIT(s);
			B;
		END;
		
		BEGIN
			C;
			SIGNAL(s);
			D;
		END;
	COEND;
END.