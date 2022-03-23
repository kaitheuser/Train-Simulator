%Group A
clear all;
close all;
delete(instrfindall);
clc;

a=arduino('COM4')
a.servoAttach(1)
a.servoStatus
a.servoWrite(1,82)                           
a.pinMode(14,'output')
a.pinMode(15,'output')
a.digitalWrite(15,1)
a.digitalWrite(14,1)
rLED=15;
a.digitalWrite(rLED,0)
a.motorRun(1,'forward')
a.motorSpeed(1,255)
a.motorRun(1,'release')

%%
clear all;
close all;
delete(instrfindall);
clc;

a=arduino('COM4')
a.servoAttach(1)
approach=3;
departure=2;
rLED=15;
lLED=14;


 a.motorRun(1, 'forward')
 a.motorSpeed(1, 255);
 
a.analogRead(approach)
a.analogRead(approach)
a.analogRead(approach)

while a.analogRead(approach) < 300

    a.analogRead(approach)
    a.analogRead(approach)
    a.analogRead(approach)
   
end

if a.analogRead(approach) > 300
    tic
    a.servoWrite(1,170)
end

a.analogRead(departure)
a.analogRead(departure)
a.analogRead(departure)

while a.analogRead(departure) < 300

    a.analogRead(departure)
    a.analogRead(departure)
    a.analogRead(departure)
   
end

if a.analogRead(departure) > 300
    time = toc;
    a.servoWrite(1,82)
end

fprintf ('Time = %2.4f', time)