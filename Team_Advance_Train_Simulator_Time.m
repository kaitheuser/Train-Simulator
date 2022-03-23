%Clear all variables, command window, and previous arduino connections.
clear all;
close all;
clc;
delete(instrfindall);

% Initialization----------------------------------------------------------

% Initialize the variable right_LED to 15.
right_LED = 15;

% Initialize the variable left_LED to 14.
left_LED = 14;

% Initialize the variable red_Approach_LED to 6.
red_Approach_LED = 6;

% Initialize the variable green_Approach_LED to 7.
green_Approach_LED = 7;

% Initialize the variable red_Departure_LED to 8.
red_Departure_LED = 8;

% Initialize the variable green_Departure_LED to 9.
green_Departure_LED = 9;

% Initialize the variable approach_Gate to 2.
approach_Gate = 2;

% Initialize the variable departure_Gate to 3.
departure_Gate = 3;

% Initialize the variable train_Minimum_Speed to 170;
train_Minimum_Speed = 170;

% Initialize the variable train_Maximum_Speed to 255;
train_Maximum_Speed = 255;

% Attach and connect all the devices and sensors.--------------------------

% Run a train simulator.
team_Advance = arduino_sim();

% Attach the servo and the Arduino.
team_Advance.servoAttach(1);

% Attach the red LED of approach gate to digital pin 6.
team_Advance.pinMode(red_Approach_LED,'output');

% Set the red LED of approach gate as default which is off.
team_Advance.digitalWrite(red_Approach_LED,0);

% Attach the green LED of approach gate to digital pin 7.
team_Advance.pinMode(green_Approach_LED,'output');

% Set the green LED of approach gate as default which is on.
team_Advance.digitalWrite(green_Approach_LED,1);

% Attach the red LED of departure gate to digital pin 8.
team_Advance.pinMode(red_Departure_LED,'output');

% Set the red LED of departure gate as default which is off.
team_Advance.digitalWrite(red_Departure_LED,1);

% Attach the green LED of departure gate to digital pin 9.
team_Advance.pinMode(green_Departure_LED,'output');

% Set the green LED of departure gate as default which is on. 
team_Advance.digitalWrite(green_Departure_LED,0);

% Attach the left LED to digital pin 14.
team_Advance.pinMode(left_LED,'output')

% Attach the right LED to digital pin 15.
team_Advance.pinMode(right_LED,'output')

% -------------------------------------------------------------------------

% Make sure the crossing gate was open when the train is loacted at the train station.
   
    % Enable the train to move forward.
    team_Advance.motorRun(1,'forward');
    
    % Set the motor speed to train speed.
    team_Advance.motorSpeed(1,255);
        

% Use infinite while-loop to execute the program infinite times.
while 1
    
    % Receive the current status of the approach break beam
    % sensors 5 times.

    for i = 1 : 5
         team_Advance.analogRead(approach_Gate);
    end
 
    % If the approach break beam sensor was interrupted.
    if team_Advance.analogRead(approach_Gate) > 250
        
        % Start stopwatch.
        tic;
        
        % Receive the current status of the departure break beam
        % sensors for 5 times.
        for i = 1 : 5
            team_Advance.analogRead(departure_Gate);
        end
       
        % While the train still not yet arrive at the departure gate.
        while team_Advance.analogRead(departure_Gate) < 250
            
            % Receive the current status of the departure break beam sensors 5 times.
            for i = 1 : 5
                team_Advance.analogRead(departure_Gate);
            end            
        end
    end
        
    % If the train passes the departure gate.    
    if team_Advance.analogRead(departure_Gate) > 250
        
        % Set the train speed to 0.
        team_Advance.motorSpeed(1,0);
        
        % Record the time.
        timeline = toc;
        
        % Calculate the distance travel (inches).
        distance = pi * 11.25;
        
        % Calculate the speed of the train (mph).
        train_Speed = ( distance / 63360 ) / ( timeline / 60 / 60 ); 
        
        % Display final timeline.
        fprintf('Time taken for 1/2 lap = %3.4f seconds', timeline)
        
        % Display the speed of the train.
        fprintf('\nSpeed of the train  = %3.4f mph\n', train_Speed)

    end
end