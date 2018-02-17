function absoluteSpeeds(NA,Rf,S,p)
% Function to find speeds of different compnenets
%   Input:
%       NA = Array defining gear sizes
%           [Ns Nr Np Z]
%               Ns = Number of teeth in sun
%               Nr = Number of teeth in one planet
%               Np = Number of teeth in ring
%               Z = Number of planets
%       Rf = Final speed increase ratio
%       S = Array defining transition speeds in RPM
%           [So S1 S2 Sf]
%               So = Input start speed
%               S1 = Input speed at first gear transition
%               S2 = Input speed at final gear transition
%               Sf = Max input speed
%       p = Data precision (default 100)
%   Outputs:
%       figures that show the relationship between input speed,
%       transmission/ring speed and the output/sun speed, the wheel speed,
%       and the planet speed

% Check min/max arguments entered
narginchk(3,4);

% Set default value for data precision
if nargin<4 || isempty(p)
    p=100;
end

% Store gear array sizes as individual variables for clarity
Ns = NA(1); % Number of teeth in sun
Nr = NA(2); % Number of teeth in ring
Np = NA(3); % Number of teeth in planet

% Sun speed given carrier and ring speed
ws = @(wc,wr)((Ns+Nr)*wc-Nr*wr)/Ns;

% Planet speed given sun, carrier and ring speed
wp = @(ws,wc,wr)(Ns*ws-Nr*wr-(Ns+2*Np-Nr)*wc)/(-2*Np);

% Input speed array from min to max
wc = linspace(0,S(4),p);

% Ring speed maximum where sun speed is zero
wr = ((Ns+Nr)/Nr)*S(4);

% Ring speed array from min to max
wr = linspace(0,wr,p);

% Create matrix of speeds
wo = zeros(p,p);
wpl = zeros(p,p);
wf = zeros(p,p);

% Fill speed matrices
for i = 1:p
    for j = 1:p
        wo(j,i)=ws(wc(i),wr(j));
        wpl(j,i)=wp(ws(wc(i),wr(j)),wc(i),wr(j));
        wf(j,i)=Rf*ws(wc(i),wr(j));
    end
end

% Make figures
figure('name','Transmission Output Speed','NumberTitle','off');
surf(wc,wr,wo);
title('Transmission Output Speed [rpm]');
xlabel('Input Speed [rpm]');
xlim([min(wc),max(wc)]);
ylabel('Transmission Speed [rpm]');
ylim([min(wr),max(wr)]);
zlabel('Output Speed [rpm]');
zlim([0,max(wo(:))]);

figure('name','Final Output Speed','NumberTitle','off');
surf(wc,wr,wf);
title('Final Output Speed [rpm]');
xlabel('Input Speed [rpm]');
xlim([min(wc),max(wc)]);
ylabel('Transmission Speed [rpm]');
ylim([min(wr),max(wr)]);
zlabel('Wheel Speed [rpm]');
zlim([0,max(wf(:))]);

figure('name','Planet Speed','NumberTitle','off');
surf(wc,wr,wpl);
title('Planet Speed [rpm]');
xlabel('Input Speed [rpm]');
xlim([min(wc),max(wc)]);
ylabel('Transmission Speed [rpm]');
ylim([min(wr),max(wr)]);
zlabel('Planet Speed [rpm]');
zlim([min(wpl(:)),max(wpl(:))]);