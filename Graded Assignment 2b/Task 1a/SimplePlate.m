%simple plate example using own element function
clear all; close all
format short e
% assume rectangular geometry [mm]
L=200; H=20;
h = 1; % Plate thickness [mm]
q=1e-3; %N/mmˆ2 load on plate
%
% Introduce 8 nodes and 3 elements
%
% 1 -----4------6-----8
% | | | |
% | 1 | 2 | 3 | H
% | | | |
% 2------3------5-----7
%
% <---------L--------->
%
%
nel=3; nnodes=8; % number of elements, number of nodes
nen=4; % number of nodes per element
%Define Edof
%
% 1-3--10-12--16-18--22-24
% | | | |
% | 1 | 2 | 3 | H
% | | | |
% 4-6 --7-9---13-15--19-21
Edof=[1 1:12;
2 7:9 13:15 16:18 10:12;
3 13:15 19:21 22:24 16:18];
% each row is the node, column coordinates of the node
Coord=[0 H; 0 0; L/3 0; L/3 H; 2*L/3 0; 2*L/3 H; L 0; L H];
% each row is node, values are the global d.o.f. in the nodes
Dof=[1:3; 4:6; 7:9; 10:12; 13:15; 16:18; 19:21; 22:24];
[Ex,Ey]=coordxtr(Edof,Coord,Dof,nen)
%plot mesh
figure(1)
plotpar=[2 1 0]
eldraw2(Ex,Ey,plotpar)
axis equal

%define size of stiffness and force
dofs_per_node = 3; % Number of dofs per node
ndofs=dofs_per_node*nnodes;
K = spalloc(ndofs,ndofs,20*ndofs); % defines K as a sparse matrix and sets the size
% to (ndof x ndof) with initial zero value
% No. of estimated non-zero entries is 20*ndofs
f_ext_area = zeros(ndofs,1);
a = zeros(ndofs,1);
%% Material data
mpar.Emod = 200.e3; % Youngs modulus [MPa]
mpar.v = 0.3; % Poisson's ratio [-]
ptype=1; %ptype=1: plane stress
% 2: plane strain, 3:axisym, 4: 3d
D=hooke(ptype,mpar.Emod,mpar.v); % Constitutive matrix - plane stress
Dbar=h^3/12*D;
%% Boundary conditions
dof_F=[1:ndofs]; dof_C=[1:6];
dof_F(dof_C) = []; %removing the prescribed dofs from dof_F
a_C = [0 0 0 0 0 0]';
%body force in each element, in x and y coordinate
body=ones(nel,1).*q; %here q all elements and gauss points
%% Setup and solve FE equations
% Assemble stiffness matrix and load vector
for el = 1:nel
[Ke, fe_ext] = ownKirchhoffQuad(Ex(el,:),Ey(el,:),[ptype h],Dbar,body(el,1));
[K,f_ext_area] = assem(Edof(el,:),K,Ke,f_ext_area,fe_ext);
end
a_F = K(dof_F, dof_F)\(f_ext_area(dof_F) - K(dof_F, dof_C)*a_C);
f_extC = K(dof_C, dof_F)*a_F + K(dof_C, dof_C)*a_C - f_ext_area(dof_C);
a(dof_F) = a_F;
a(dof_C) = a_C;
Ed = extract_dofs(Edof,a); % extract element displacements for plotting
% now plot displacement as a function of x for the lower boundary
w=a([4 7 13 19]);
x=[0 L/3 2*L/3 L];
figure(2)
plot(x,w,'g-')
xlabel('x [mm]')