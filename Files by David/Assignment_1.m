%% Properties
clear all;clc;


% Material properties
E = 30E9; % Young's modulus
nu = 0.2; % Poisson's ratio
g = 9.81; % Gravitational accel
rho_conc = 2200; % density concrete kg/m^3
L = 1; % Thickness in z-direction
rho_water = 1000; % density water kg/m^3

% Properties in he table
Z = 45;
B = 15;
H = 20;
D = 6;
b = 6;
h = 7;
r = 2;

% Number of elements for Tunnel Mesh
Nr = 11; % Min 1
Nt = 22; % Min 5

% Coordinates of the triangular element nodes
x1 = 0;
y1 = 0;
x2 = 1;
y2 = 0.25;
x3 = 0.5;
y3 = 1;

% Area of triangle element using determinant method
A = Area(x1, y1, x2, y2, x3, y3);

% D matrix of material properties resulting from Voigt notation
De = (E / ((1 + nu) * (1 - 2*nu))) * [1-nu, nu, 0; nu, 1-nu, 0; 0, 0, (1-2*nu)/2];

% B matrix using the code snippet of the lecture script
Be = Be_cst_func([0;0],[1;0.25],[0.5;1]);

% Element stiffness matrix of single triangle task 1b
K_el = Be'*De*Be*L*A;

% Mass of triangle element
m = rho_conc * A*h;

% Load vector on triangle nodes
f_e = -g*[0;m/3;0;m/3;0;m/3];

% Pressure
p = 5;

% Force resulting through pressure task 1c
[f1x,f1y,f2x,f2y]= PressureLoad(0,0,1,1,L,p);


[Edof,Coord,Ex,Ey,LeftSide_nodes,TopSide_nodes,RightSide_nodes,BottomSide_nodes]...
    =TunnelMeshGen(H,B,D,b,h,r,Nr,Nt,1);

[M,I,a] = Solving(Ex,Ey,De,Z,L,g,BottomSide_nodes,LeftSide_nodes,...
    RightSide_nodes,TopSide_nodes,Coord,Edof,rho_water,rho_conc);



