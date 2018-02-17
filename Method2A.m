function [x1,x2] = Method2A(NA,NT,DP,CP,M,S,E)
 %  Function to determine tangential mesh forces during gear shift and
%    before ring gear lock
% 
%    [x] = Method2A(NA,NT,DP,CP,M,S,E)
% 
%    Inputs:
%       NA = Planetary system parameters
%           [Sun Teeth, Ring Teeth, Planet Teeth, Number of Planets]
%       NT = Transmission control system parameters
%           [Ring outside, Transmisson]
%       DP = Diametral Pitch [in/tooth]
%       CP = Chain pitch [in/link]
%       M = motor choice
%       S = Transition speeds [low first second top]
%       E = Resolution of data
%   Outputs:
%       x = Mesh forces and component angular accelerations dependant
%           Row 1:  Sun/Planet Tangential Mesh Force [lbs]
%           Row 2:  Planet/Carrier Contact Force [Lbs]
%           Row 3:  Planet/Ring Tangential Mesh Force [lbs]
%           Row 4:  Chain Tension Force [lbs]
%           Row 5:  Planet alpha [s^-2]
%           Row 6:  Ring alpha [s^-2]
%           Row 7:  Carrier alpha [s^-2]
%           Row 8:  Friction Brake alpha [s^-2]
%           Row 9:  Transmission Torque [lbs-in]
%
%   Notes:
%      - Input speed changes linearly from min to max RPM
%      - Input torque based on manufacture specs
%      - Speed and torque ratios pre-determined and hardcoded

narginchk(7,7);

Rs = NA(1)/(2*DP); % Radius of Sun pitch circle
Rp = NA(3)/(2*DP); % Radius of planet pitch circle
Rr = NA(2)/(2*DP); % Radius of ring internal pitch circle
Rrs = CP/(2*sind(180/NT(1))); % Radius of ring sprocket pitch circle
Rb = CP/(2*sind(180/NT(2))); % Radius of friction brake sprocket pitch circle
t = NA(2)/NA(1); % Defining ring(internal)/sun tooth ratio

Z = NA(4); % Number of Planets
p = 0.284; % Density of steel in lb/in^3

% Moment of inertia by component in lb-in^2 from CAD software
Js = 3.181/16; % Moment of inertia of sun
Jp = (32.064-0.211)/16; % Moment of inertia of one planet
Jr = (3834.659)/16; % Moment of inertia of ring
Jc = (1/20)*(104.741+11.675*3+(7517.145+166500+1927.113+11.295))/16; % Moment of inertia of carrier
Jb = (825.89+196.353+11.188+62.882+3086.333+571.449)/16; % Moment of inertia of trans float

mp = (39.534-3.538)/16; % Mass of one planet lb from CAD software
mc = (3.538*3+59.962)/16; % Mass of carrier lb from CAD software

w = linspace(S(1),S(4),E);

for j = 1:2
    Tin = torqueCurve(M,E,S,w);
    [n,u] = speedtorqueRatio(NA,w,S,E);
    switch j
        case 1
            ws = S(2);
            Tin = Tin(find(round(w,0)==ws,1));
            n = linspace(0,n(find(round(w,0)==ws,1)),E);
            u = linspace(0,u(find(round(w,0)==ws,1)),E);
        case 2
            ws = S(3);
            Tin = Tin(find(round(w,0)==ws,1));
            n = linspace(n(find(round(w,0)==S(2),1)),0.95*n(find(round(w,0)==ws,1)),E);
            u = linspace(u(find(round(w,0)==S(2),1)),u(find(round(w,0)==ws,1)),E);
    end
        
    x = zeros(9,E);
    
    for i = 1:E
        A = [...
            0 0 0 0 0 Rrs 0 -Rb;...
            0 0 0 0 -2*Rp Rr 2*Rp+Rs-Rr 0;...
            Rs*Z 0 0 0 0 0 0 0;...
            -Rp 0 Rp 0 -Jp 0 0 0;...
            -1 1 -1 0 0 0 -(mp+mc/Z)*(Rs+Rp) 0;...
            0 0 -Rr*Z Rrs 0 -Jr 0 0;...
            0 (Rs+Rp)*Z 0 0 0 0 -Jc 0;...
            0 0 0 Rb 0 0 0 Jb;...
            ];
        
        y = [0;0;Tin;0;0;0;-u(i)*Tin;...
            (t*(n(i)*u(i)+1))/(1-n(i)*(t+1))*(Rb/Rrs)*Tin];
        
        q = A\y;
        for k = 1:8
            x(k,i) = q(k);
        end
        x(9,i) = (t*(n(i)*u(i)+1))/(1-n(i)*(t+1))*(Rb/Rrs)*Tin;
    end
    figure
    for i = 1:8
        subplot(3,4,i)
        plot(n,x(i,:));
        xlabel('Speed Ratio (\theta_C/\theta_s) [RPM/RPM]');
        switch i
            case 1
                title('Sun/Planet Mesh Force');
                ylabel('Force [Lbs]');
       
            case 2
                title('Carrier/Planet Force');
                ylabel('Force [Lbs]');
       
            case 3
                title('Ring/Planet Mesh Force');
                ylabel('Force [Lbs]');
       
            case 4
                title('Chain Tension Force');
                ylabel('Force [Lbs]');
       
            case 5
                title('Planet \alpha');
                ylabel('\alpha [sec^-2]');
       
            case 6
                title('Ring \alpha');
                ylabel('\alpha [sec^-2]');
       
            case 7
                title('Carrier \alpha');
                ylabel('\alpha [sec^-2]');
       
            case 8
                title('Friction Brake \alpha');
                ylabel('\alpha [sec^-2]');
        end
   
        subplot(3,4,9)
        plot(n,u);
        xlabel('Speed Ratio (\theta_C/\theta_s) [RPM/RPM]');
        ylabel('Torque ratio (\tau_o/\tau_i) [lb-in/lb-in]');
    end
    subtitle(strcat('Method 2: Continuous Input and Changing Gear Ratio Before Final Ratio (\omega_S = ',num2str(ws),' RPM)'));
    
    if j==1
        x1 = x;
    elseif j==2
        x2 = x;
    end
end