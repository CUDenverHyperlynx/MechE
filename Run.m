% Clean slate
wipeIT;

% Collect and condense data
data = fopen('data.txt');
c = textscan(data,'%s %f');
varname = c{1};
varval = c{2};
for i = 1:length(varname)
    eval([varname{i} '= ' num2str(varval(i)) ';']);
end
NA = [Ns Nr Np Z];
NT = [Nrs Nb];
switch M
    case 1
        if s2 > 8500 || s1 > s2
            error('Shift points not valid');
        end
        S = [0 s1 s2 8500];
        Po = 70;
    case 2
        if s2 > 7000 || s1 > s2
            error('Shift points not valid');
        end
        S = [0 s1 s2 7000];
        Po = 80;
    case 3
        if s2 > 6500 || s1 > s2
            error('Shift points not valid');
        end
        S = [0 s1 s2 6500];
        Po = 100;
    case 4
        if s2 > 5500 || s1 > s2
            error('Shift points not valid');
        end
        S = [0 s1 s2 5500];
        Po = 500;
    case 5
        if s2 > 4000 || s1 > s2
            error('Shift points not valid');
        end
        S = [0 s1 s2 4000];
        Po = 1000;
end

clear varname varval i c data Ns Nr Nrs Np Nb Z s1 s2;

% Find and display speed relationships
absoluteSpeeds(NA,Rf,S,10);

% First Method Display
x1 = Method1A(NA, NT, DP, CP, S, M, 10000);
mx1 = maxByRow(x1);

% Second Method Display
[x2,x3] = Method2A(NA, NT, DP, CP, M, S, 10000);
mx2 = maxByRow(x2);
mx3 = maxByRow(x3);

% Third Method Display
x4 = Method3A(NA, NT, DP, CP, S, M, 10000);
mx4 = maxByRow(x4);

% Display Method Maximums in Command Window
h = {'Sun/Planet' 'Planet/Carrier' 'Planet/Ring' 'Chain Tension' 'Transmission tau'};
format longG
A = [mx1(1) mx1(2) mx1(3) mx1(4) mx1(10);...
     mx2(1) mx2(2) mx2(3) mx2(4) mx2(9);...
     mx3(1) mx3(2) mx3(3) mx3(4) mx3(9);...
     mx4(1) mx4(2) mx4(3) mx4(4) mx4(8)];
[h;num2cell(A)]
clear h A;