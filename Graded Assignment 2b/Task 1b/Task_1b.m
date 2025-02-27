% Task 1b test case
clc 
clear all 
Ex = [2 11 12 3]*1e-3;
Ey = [4 5 21 22]*1e-3;
t = 50e-3;
E = 80e9;
nu = 0.2;
G_modulus = E/(2*(1+nu));
G = G_modulus*eye(2,2);
ptype = 1;
D = hooke(1,E,nu); % Note: Thin plate = plane stress 2D assumption
q = 0.5*1e3; % Out-of-plane load qz


% Define problem parameters
xmin = 0; xmax = 2; % Plate length in meters
ymin = 0; ymax = 2; % Plate height in meters
nelx = 10; % Number of elements along x-direction
nely = 5;  % Number of elements along y-direction
% Call the mesh generator
[mesh, Coord, Edof_ip, Edof_oop] = rectMesh(xmin, xmax, ymin, ymax, nelx, nely);

[Ex,Ey]=coordxtr(Edof_ip,Coord,dof,4);


Dbar=D*t^3/12;

h = 1;
body=q;



[Kww, fe_ext,Kuu,Bu] = ownKirchhoffQuad(Ex,Ey,[ptype h],Dbar,body,t,D);
F_nodal_total = sum(fe_ext)
