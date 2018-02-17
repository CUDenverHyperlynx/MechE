function [Tin] = torqueCurve(M,E,S,ws)
% Function that constructs torque curve based on motor choice
%       [Tin] = torqueCurve(M,E,S,ws)
%
%   Input:
%       M = motor choice
%           1 = 188
%           2 = 208
%           3 = 228
%           4 = 268
%           5 = 348
%       E = number of data points
%       S = speed transition constants
%           [low first second top]
%       ws = speed values
%   Output:
%       Tin = Torque curve over speed range of motor

switch M
    case 1
        Tin = linspace(100,80,E); % assuming 20% w/o torque curve
        Tin = horzcat(20*ones(1,find(round(ws,0)==S(2),1)-1),Tin(:,find(round(ws,0)==S(2),1):end)); % Lower torque input until first shift RPM
        Tin = Tin.*8.85; % converting N-m to Lb-in
    case 2
        % Generate Input torque values based on input speed
        Tin = zeros(1,E); % Initialize holder
        
        % Populate linear portion
        for i = 1:round(E*19/30,0)
            Tin(i) = -(i-1)*4/(round(E*19/30,0)-1)+140;
        end
        
        % Define data points from EMRAX specs for torque vs speed
        x = linspace(0,S(4),31); % number of points along x axis
        x = x(20:31);
        y = zeros(1,12); % initialize value holder
        
        % Fill in remain data points by manual inspection
        y(1) = 136;
        y(2) = 135;
        y(3) = 134;
        y(4) = 133;
        y(5) = 131.5;
        y(6) = 130;
        y(7) = 128;
        y(8) = 126;
        y(9) = 124;
        y(10) = 121;
        y(11) = 118;
        y(12) = 115;
        y = polyfit(x,y,2); % Define smooth curve fit
        
        % Find fill data for main torque value holder
        x = ws(round(E*19/30,0):E);
        y = polyval(y,x);
        
        % Populate remainder of torque value holder
        for i = round(E*19/30,0)+1:E
            Tin(i) = y(i-(round(E*19/30,0)-1));
        end
        
        Tin = horzcat(20*ones(1,find(round(ws,0)==S(2),1)-1),Tin(:,find(round(ws,0)==S(2),1):end)); % Lower torque input until first shift RPM
        Tin = Tin.*8.85; % Convert torque data from N-m to Lb-in
    case 3
        % Generate Input torque values based on input speed
        Tin = zeros(1,E); % Initialize holder
        
        % Populate linear portion
        for i = 1:round(E*2/5,0)
            Tin(i) = 240;
        end
        
        % Define data points from EMRAX specs for torque vs speed
        x = linspace(0,S(4),26); % number of points along x axis
        x = x(12:26);
        y = zeros(1,15); % initialize value holder
        
        % Fill in remain data points by manual inspection
        y(1) = 239.5;
        y(2) = 238.5;
        y(3) = 237;
        y(4) = 236;
        y(5) = 235;
        y(6) = 234;
        y(7) = 232.5;
        y(8) = 231;
        y(9) = 229.5;
        y(10) = 228;
        y(11) = 226;
        y(12) = 223.5;
        y(13) = 220.5;
        y(14) = 218;
        y(15) = 216;
        y = polyfit(x,y,2); % Define smooth curve fit
        
        % Find fill data for main torque value holder
        x = ws(round(E*2/5,0):E);
        y = polyval(y,x);
        
        % Populate remainder of torque value holder
        for i = round(E*2/5,0)+1:E
            Tin(i) = y(i-(round(E*2/5,0)-1));
        end
        
        Tin = horzcat(20*ones(1,find(round(ws,0)==S(2),1)-1),Tin(:,find(round(ws,0)==S(2),1):end)); % Lower torque input until first shift RPM
        Tin = Tin.*8.85; % Convert torque data from N-m to Lb-in
    case 4
        % Generate Input torque values based on input speed
        Tin = zeros(1,E); % Initialize holder
        
        % Populate linear portion
        for i = 1:round(E*1750/5500,0)
            Tin(i) = 500;
        end
        
        % Define data points from EMRAX specs for torque vs speed
        x = linspace(0,S(4),22); % number of points along x axis
        x = x(9:22);
        y = zeros(1,14); % initialize value holder
        
        % Fill in remain data points by manual inspection
        y(1) = 450;
        y(2) = 430;
        y(3) = 400;
        y(4) = 355;
        y(5) = 325;
        y(6) = 310;
        y(7) = 290;
        y(8) = 280;
        y(9) = 270;
        y(10) = 260;
        y(11) = 250;
        y(12) = 240;
        y(13) = 230;
        y(14) = 220;
        y = polyfit(x,y,2); % Define smooth curve fit
        
        % Find fill data for main torque value holder
        x = ws(round(E*1750/5500,0):E);
        y = polyval(y,x);
        
        % Populate remainder of torque value holder
        for i = round(E*1750/5500,0)+1:E
            Tin(i) = y(i-(round(E*1750/5500,0)-1));
        end
        
        Tin = horzcat(20*ones(1,find(round(ws,0)==S(2),1)-1),Tin(:,find(round(ws,0)==S(2),1):end)); % Lower torque input until first shift RPM
        Tin = Tin.*8.85; % Convert torque data from N-m to Lb-in
    case 5
        % Values for the 348 are scaled by a factor of 2 from the 268 per
        %   Emrax instruction
        
        % Generate Input torque values based on input speed
        Tin = zeros(1,E); % Initialize holder
        
        % Populate linear portion
        for i = 1:round(E*1750/4500,0)
            Tin(i) = 1000;
        end
        
        % Define data points from EMRAX specs for torque vs speed
        x = linspace(0,S(4),18); % number of points along x axis
        x = x(9:18);
        y = zeros(1,10); % initialize value holder
        
        % Fill in remain data points by manual inspection
        y(1) = 950;
        y(2) = 880;
        y(3) = 800;
        y(4) = 710;
        y(5) = 650;
        y(6) = 620;
        y(7) = 580;
        y(8) = 560;
        y(9) = 540;
        y(10) = 520;
        y = polyfit(x,y,2); % Define smooth curve fit
        
        % Find fill data for main torque value holder
        x = ws(round(E*1750/4500,0):E);
        y = polyval(y,x);
        
        % Populate remainder of torque value holder
        for i = round(E*1750/4500,0)+1:E
            Tin(i) = y(i-(round(E*1750/4500,0)-1));
        end
        
        Tin = horzcat(20*ones(1,find(round(ws,0)==S(2),1)-1),Tin(:,find(round(ws,0)==S(2),1):end)); % Lower torque input until first shift RPM
        Tin = Tin.*8.85; % Convert torque data from N-m to Lb-in
end