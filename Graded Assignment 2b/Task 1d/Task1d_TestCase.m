%% Task 1d - Solving FE problem
clc
clear all
%---------------------------------------------------------
% Material and geometric parameters
E = 80e9; % Young's modulus steel
nu = 0.2; % Poisson's ratio steel
D = hooke(1,E,nu); % Note: Thin plate = plane stress 2D assumption
t = 50e-3; % Thickness of wall
z = 5E-3;

Dbar=D*t^3/12; % Dbar matrix

% Ex and Ey matrices
Ex = 1E-3 * [2 11 12 3];
Ey = 1E-3 * [4 5 21 22];

% Displacements
au = (1:8)*1E-6;
aw = (9:20)*1E-6;

% Initializing stress vector
sigma = zeros(3,1);

% Calculating mean stress over Gauss points
[sigma,sigma_matrix] = Stress(D,au.',aw.',z,Ex,Ey);
