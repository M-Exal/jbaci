program Suspension;

monitor PC;
const nmrProcesos = 20;
var i:INTEGER;
var delayed:array[0..nmrProcesos] of boolean;
var time:array[0..nmrProcesos] of integer;
var cond:array[0..nmrProcesos] of CONDITION;
	
procedure oneSecondHasPassed;
var i: INTEGER;
begin
	for i:= 1 to nmrProcesos do
	begin
		IF delayed[i] then 
		begin
			time[i]:= time[i] - 1;
			IF time[i] = 0 then 
			begin
				delayed[i]:= false;
				SIGNALC (cond[i]);
			end;
		end;
	end;
end;

procedure delayMe (myself: INTEGER; interval: INTEGER);
begin
	(* it suspends the process identified by myself for interval seconds *)
	delayed[myself]:=TRUE;
	time[myself]:=interval;
	WAITC(cond[myself]);
end;

begin (* monitor *)
	for i:=1 to nmrProcesos do begin
		delayed[i]:=false;
		time[i]:=0;
	end;
end;

(*const nmrProcesos = 20;*)
var i: INTEGER;
currentTime: INTEGER:= 0;
output: BINARYSEM := 1;

procedure clock;
var i, j: integer;
begin
	for i:= 1 to 10 do 
	begin
		for j:= 1 to 200 do 
		begin
		end;
		currentTime := currentTime + 1;
		WAIT(output);
		writeln ("1 second passed. Current time: ", currentTime, " seconds");
		SIGNAL(output);
		oneSecondHasPassed;
	end;
end;

procedure process (ID: integer);
var i, j: integer;
begin
	WAIT (output);
	writeln ("I am the process", ID, " and I go to sleep for ", ID*2, " seconds. Current time: ",
	currentTime);
	SIGNAL (output);
	delayMe (ID, ID*2);
	WAIT (output);
	writeln ("I am the process", ID, " and I just woke up. Current time: ", currentTime);
	SIGNAL (output);
	end;
begin
	cobegin
	clock;
	process(1); process (2); process (3); process (4);
	coend;
end