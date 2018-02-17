function [x] = maxByRow(A)
% Function to find the maximum in each row of a matrix and store in
%       an array
%
%   [x] = MaxByRow(A)
%
%       Inputs:
%           A = input matrix where each row is a data set
%       Output:
%           x = Array of largest values in each row of A. Elements
%                   in order of rows in matrix

k = size(A,1); % Find number of rows
x = zeros(1,k); % Initialize holder
A = abs(A); % Make all values positive

% Populate holder
for i = 1:k
    x(i) = max(A(i,:));
end