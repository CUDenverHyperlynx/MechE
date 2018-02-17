function [n,u] = speedtorqueRatio(NA,ws,S,E)
% Function that defines the speed and torque ratos based on gear sizes,
%   input speed limits, and tranission speeds
%
%   [n,u] = speedtorqueRatio(NA,ws,S,E)
%
%   Inputs:
%       NA = Planetary system parameters
%           [Sun Teeth, Ring Teeth, Planet Teeth, Number of Planets]
%       ws = input speed array
%       S = Transition speeds [low first second top]
%       E = Resolution of data
%   Outputs:
%       n = speed ratio
%       u = torque ratio

% Check for entered arguments
narginchk(4,4);

% Determine final geometric ratio as base for gear ratios
x = (NA(1)+NA(2))/NA(1);

% Define speed ratio as function of input speed
%      First gear is assigned to be half the speed reduction of final gear
n = zeros(1,E); % Initialize
for i = 1:find(round(ws,0)==S(2),1)-1
    n(i) = 0;
end
for i = find(round(ws,0)==S(2),1):find(round(ws,0)==S(3),1)-1
    n(i) = 1/(2*x);
end
for i = find(round(ws,0)==S(3),1):E
    n(i) = 1/x;
end

% Define torque ratio as function of input speed
%      First gear is assigned to be twice the torque increase of final gear
u = zeros(1,E); % Initialize
for i = 1:find(round(ws,0)==S(2),1)-1
    u(i) = 0;
end
for i = find(round(ws,0)==S(2),1):find(round(ws,0)==S(3),1)-1
    u(i) = 2*x;
end
for i = find(round(ws,0)==S(3),1):E
    u(i) = x;
end