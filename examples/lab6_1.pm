program ProducerConsumer;
monitor PC;
const N = 5;
var Oldest: integer;
	Newest:integer;
	Count: integer;
	NotEmpty: Condition;
	NotFull: Condition;
	Buffer: array[0..N] of integer;

procedure Append(V: integer);
begin
	if Count = N then
		WaitC(NotFull);
	Buffer[Newest] := V;
	Newest := (Newest + 1) mod N;
	Count := Count + 1;
	SignalC(NotEmpty);
end;

procedure Take(var V: Integer);
begin
	if Count = 0 then
		WaitC(NotEmpty);
	V := Buffer[Oldest];
	Oldest := (Oldest + 1) mod N;
	Count := Count - 1;
	SignalC(NotFull);
end;

begin
	Count := 0; Oldest := 0; Newest := 0;
end;

VAR output: BINARYSEM;
const Values = 20;

procedure Producer(ID: integer);
var I: integer;
begin
	for I := 1 to Values do
	begin
		WAIT (output);
			writeln ("Producer ", ID, " producing ", ID*100+I);
		SIGNAL (output);
		Append(ID*100+I);
	end;
end;

procedure Consumer(ID: integer);
var I, J: integer;
begin
	for I := 1 to 10 do
	begin
		Take(J);
		WAIT (output);
			writeln ("Consumer ", ID, " consuming ", J);
		SIGNAL (output);
	end;
end;

begin
	INITIALSEM (output, 1);
	cobegin
		Producer(1); Consumer(1); Consumer(2);
	coend;
end.