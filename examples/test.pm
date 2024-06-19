Program Suspension;
monitor PC;
const nmrProcesses = 20;
var i: INTEGER;
delayed: array[0..nmrProcesses] of boolean;
time: array[0..nmrProcesses] of integer;
cond: array[0..nmrProcesses] of CONDITION;
procedure oneSecondHasPassed;
var i: INTEGER;
begin
for i:= 1 to nmrProcesses do
IF delayed[i] then begin
time[i]:= time[i] - 1;
IF time[i] = 0 then begin
delayed[i]:= false;
SIGNALC (cond[i]);
end
end
end;
procedure delayMe (myself: INTEGER; intervalo: INTEGER);
begin
delayed [myself]:= TRUE;
time [myself]:= intervalo;
WAITC (cond[myself]);
end;
begin (* del monitor *)
for i:= 1 to nmrProcesses do begin
delayed[i]:= false;
time[i]:= 0;
end;
end;
const nmrProcesses = 20;
var i: INTEGER;
currentTime: INTEGER:= 0;
output: BINARYSEM := 1;
procedure reloj;
var i, j: integer;
begin
for i:= 1 to 10 do begin
for j:= 1 to 200 do;
currentTime:= currentTime + 1;
WAIT (output);
writeln ("1 second has passed. Current time: “, currentTime,” seconds");
SIGNAL (output);
oneSecondHasPassed;
end;
end;
procedure process (ID: integer);
var I, J: integer;
begin
WAIT(output);
writeln ("I’m the process", ID, " and I’m going to sleep ", ID*2, " seconds. Current time: ",
currentTime);
SIGNAL (output);
delayMe (ID, ID*2);
WAIT (output);
writeln ("soy el process", ID, "and I’ve woken up. Current time: ", currentTime);
SIGNAL (output);
end;
begin
cobegin
reloj;
process(1); process (2); process (3); process (4);
coend;
end.