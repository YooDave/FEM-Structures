% Task 1b test case
clc 
clear all 
t = 50e-3;
E = 80e9;
nu = 0.2;
G_modulus = E/(2*(1+nu));
G = G_modulus*eye(2,2);
ptype = 1;
D = hooke(1,E,nu); % Note: Thin plate = plane stress 2D assumption
q = 0.5*1e3; % Out-of-plane load qz
h = 1; %
body=q;%
rho = 1000;
g = 9.81;
L=2;
H=2;
l=1;

% Define problem parameters
xmin = 0; xmax = 2; % Plate length in meters
ymin = 0; ymax = 2; % Plate height in meters
nelx = 5; % Number of elements along x-direction
nely = 5;  % Number of elements along y-direction

% Call the mesh generator
[mesh, Coord, Edof_ip, Edof_oop] = rectMesh(xmin, xmax, ymin, ymax, nelx, nely);

nnodes = size(Coord,1);
% DoFs in each node
dof = zeros(nnodes,2);
for i = 1:nnodes
    dof(i,1) = 2*i-1;
    dof(i,2) = 2*i;
end
  
[Ex,Ey]=coordxtr(Edof_ip,Coord,dof,4); %Ex and Ey gives coordinates of element 

Edof_ip = full(Edof_ip); 
Edof_oop = full(Edof_oop);

elcoord=[Ex(:,1) Ey(:,1) ; Ex(:,2) Ey(:,2)  ;Ex(:,3) Ey(:,3) ; Ex(:,4) Ey(:,4) ]; %Coordinate system of  all elements

Xcoord = elcoord(:,1); Ycoord = elcoord(:,2);

LeftSide_nodes=find(abs(Xcoord-L)'<100*eps);
RightSide_nodes=find(abs(Xcoord-0)'<100*eps);
BottomSide_nodes=find(abs(Ycoord-H)'<100*eps);
TopSide_nodes=find(abs(Ycoord-0)'<100*eps); % this logic computed from TunnelMeshGen.m from CE1

platform_nodes1 = find(Xcoord(TopSide_nodes)<(l + (L - l)/2))';
platform_nodes = find(Xcoord(platform_nodes1)>(L - l)/2);

No_of_nodes_in_topXcoord = length(Xcoord); % total number of nodes
all_nodes = 1:No_of_nodes_in_topXcoord;

excluded_top_nodes = setdiff(all_nodes, platform_nodes); % Using setdiff

ndofs_ip = 2*length(Coord(:,1));
ndofs_op = 3*length(Coord(:,1));

dofs = 1:ndofs_ip;

% dof_left=zeros(2*length(LeftSide_nodes),1);
% for i = 1:length(LeftSide_nodes)
%     dof_left(i:i+1) = [(LeftSide_nodes(i)-1)*2 + 1;(LeftSide_nodes(i)-1)*2];
%     i=i+1;
% end

Dbar=D*t^3/12;

[Kww, fe_ext,Kuu,Bu] = ownKirchhoffQuad(Ex,Ey,[ptype h],Dbar,body,t,D);

F_nodal_total = sum(fe_ext);
