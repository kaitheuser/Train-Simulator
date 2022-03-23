
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
team_Advance = arduino('COM4');

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
team_Advance.digitalWrite(red_Departure_LED,0);

% Attach the green LED of departure gate to digital pin 9.
team_Advance.pinMode(green_Departure_LED,'output');

% Set the green LED of departure gate as default which is on. 
team_Advance.digitalWrite(green_Departure_LED,1);

% Attach the left LED to digital pin 14.
team_Advance.pinMode(left_LED,'output')

% Attach the right LED to digital pin 15.
team_Advance.pinMode(right_LED,'output')

gateFlag = 1; 
% -------------------------------------------------------------------------

% Make sure the crossing gate was open when the train is loacted at the train station.

% Check the servo Status.
team_Advance.servoStatus;

% Control the servo and open the crossing gate vertically.
team_Advance.servoWrite(1,66);

% -------------------------------------------------------------------------

% Prompt user to choose between urban and rural.
community = input('Please type 1 for Urban or 2 for Rural:\n');

% -------------------------------------------------------------------------

% Use if-else selection statement to run the train in different community.
   
    % Enable the train to move forward.
    team_Advance.motorRun(1,'forward');
    
    % Set the motor speed to train initial speed which is 255.
    team_Advance.motorSpeed(1,train_Maximum_Speed);
        
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
        
        if community == 1
             % Initialize the variable right_Flash to 1.75.
             right_Flash = 0.25;   
             % Initialize the variable left_Flash to 2.25.
             left_Flash = 0.75;
             
        else if community == 2
                % Initialize the variable right_Flash to 0.75.
               right_Flash = 0.25;    
                % Initialize the variable left_Flash to 1.25.
               left_Flash = 0.75;
               
            end
        end
        
  
        
        % Set the motor speed to train minimum speed which is 170.
        team_Advance.motorSpeed(1,train_Minimum_Speed);
        
        % Receive the current status of the departure break beam
        % sensors for 5 times.
        
        for i = 1 : 5
            team_Advance.analogRead(departure_Gate);
        end
       
        % While the train still not yet arrive at the departure gate.
        while gateFlag < 250
            
            % Assign timeline to toc to update the timeline.
            timeline = toc;
            
            % Receive the current status of the departure break beam sensors 5 times.
            for i = 1 : 5
                gateFlag = team_Advance.analogRead(departure_Gate);
                
            end           
       
            % Set the motor speed to train minimum speed which is 170.
            team_Advance.motorSpeed(1,train_Minimum_Speed);
            
            % Switch on both red_Approach_LED and green_Departure_LED, and
            % switch off both green_Approach_LED and red_Departure_LED.
            team_Advance.digitalWrite(red_Approach_LED,1);
            team_Advance.digitalWrite(green_Approach_LED,0);
            team_Advance.digitalWrite(red_Departure_LED,0);
            team_Advance.digitalWrite(green_Departure_LED,1);
            
            if community == 1
                  % Delay on opening the crossing gate for 2 seconds by using if statement.
                if timeline >= 1                
                % Close the crossing gate horizontally.
                team_Advance.servoWrite(1,170);               
                end
                
            else if community == 2
                    % Delay on opening the crossing gate for 1 second by using if statement.
                    if timeline >= 0.75              
                    % Close the crossing gate horizontally.
                    team_Advance.servoWrite(1,170);              
                    end
                    
                end
            end
            

            % Use if-else statement in while-loop to make both LEDs flash
            % alternatively.
            if timeline >= right_Flash
                
                % Switch on right LED.
                team_Advance.digitalWrite(right_LED,1);
                
                % Switch off left LED.
                team_Advance.digitalWrite(left_LED,0);
            
                % Increment the right_Flash by 1.
                right_Flash = right_Flash + 1;
                
            elseif timeline >= left_Flash
                
                % Switch on left LED.
                team_Advance.digitalWrite(left_LED,1);
                
                % Switch off right LED.
                team_Advance.digitalWrite(right_LED,0);
                
                % Increment the left_Flash by 1.
                left_Flash = left_Flash + 1;
            end
            
             for i = 1 : 5
                gateFlag = team_Advance.analogRead(departure_Gate);
            end   
        end
        gateFlag = 1;
    end
        
    % If the train passes the departure gate.    
    if team_Advance.analogRead(departure_Gate) > 250
        
        % Switch off the right LED.
        team_Advance.digitalWrite(right_LED,0);
        
        % Switch off the left LED.
        team_Advance.digitalWrite(left_LED,0);
        
        % Open the crossing gate.
        team_Advance.servoWrite(1,66);
        
        % Set the train speed to maximum.
        team_Advance.motorSpeed(1,train_Maximum_Speed);
        
        % Reset the stopwatch.
        tic;
        
        % Switch off both red_Approach_LED and green_Departure_LED, and
        % switch on both green_Approach_LED and red_Departure_LED.
        team_Advance.digitalWrite(red_Approach_LED,0);
        team_Advance.digitalWrite(green_Approach_LED,1);
        team_Advance.digitalWrite(red_Departure_LED,1);
        team_Advance.digitalWrite(green_Departure_LED,0);
    end
end
    
        







