program Eje52;
VAR s1,s2:SEMAPHORE:=0;
PROCEDURE P1;
BEGIN
writeln ("Sentence 1 of P1");
(* 1 *);WAIT(s1);SIGNAL(s2);
writeln ("Sentence 2 of P1");
END;
PROCEDURE P2;
BEGIN
writeln ("Sentence 1 of P2");
(* 2 *);SIGNAL(s1);WAIT(s2);
writeln ("Sentence 2 of P2");
END;
BEGIN
COBEGIN
P1;
P2;
COEND
END.