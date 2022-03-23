

%--------------------------------------------------------------

%Group A
clear all;
close all;
delete(instrfindall);
clc;

%a= arduino_sim();
a=arduino('COM4')
a.servoAttach(1);
%a.servoStatus
a.servoWrite(1,66);
a.pinMode(14,'output');
a.pinMode(15,'output')
a.digitalWrite(15,1);
a.digitalWrite(14,1);
rLED=15;
a.digitalWrite(rLED,0);

approach=3;
departure=2;


%global variables 


trainInitialSpeed = 200;
trainMinSpeed = 170;
trainMaxSpeed = 255;
currentSpeed = trainInitialSpeed; 


true = 1;
false = 0;

%set initial
a.motorRun(1, 'forward');
a.motorSpeed(1,trainInitialSpeed);   
while(1)

   if(a.analogRead(approach) > 250)
        %fprintf('departure\n')
       a.motorSpeed(1,trainMinSpeed);
       
   else if ( a.analogRead(departure) > 250)
           % a.analogRead(departure)
            a.motorSpeed(1,trainMaxSpeed);
       end
   end
   time
end  