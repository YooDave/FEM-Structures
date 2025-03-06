% Task 1b test case
clc 
clear all 
t = 10e-3;
E = 210e9;
nu = 0.3;
G_modulus = E/(2*(1+nu));
G = G_modulus*eye(2,2);
ptype = 1;
D = hooke(1,E,nu); % Note: Thin plate = plane stress 2D assumption
h = 1; %
rho = 1000;
g = 9.81;
L=2;
H=2;
l=1;
Dbar=D*t^3/12;
m = 150; % Mass of person in kg

% Define problem parameters
xmin = 0; xmax = 2; % Plate length in meters
ymin = 0; ymax = 2; % Plate height in meters
nelx = 5; % Number of elements along x-direction
nely = 5;  % Number of elements along y-direction
nel = nelx*nely;

% Call the mesh generator
[mesh, Coord, Edof_ip, Edof_oop] = rectMesh(xmin, xmax, ymin, ymax, nelx, nely);

nnodes = size(Coord,1);
% DoFs in each node
dofs = zeros(nnodes,2);
for i = 1:nnodes
    dofs(i,1) = 2*i-1;
    dofs(i,2) = 2*i;
end
  
[Ex,Ey]=coordxtr(Edof_ip,Coord,dofs,4); %Ex and Ey gives coordinates of element 

Edof_ip = full(Edof_ip); 
Edof_oop = full(Edof_oop);

elcoord=[Ex(:,1) Ey(:,1) ; Ex(:,2) Ey(:,2)  ;Ex(:,3) Ey(:,3) ; Ex(:,4) Ey(:,4) ]; %Coordinate system of  all elements

Xcoord = elcoord(:,1); Ycoord = elcoord(:,2);


LeftSide_nodes=find(abs(Xcoord-L)'<100*eps);
RightSide_nodes=find(abs(Xcoord-0)'<100*eps);
BottomSide_nodes=find(abs(Ycoord-H)'<100*eps);
TopSide_nodes=find(abs(Ycoord-0)'<100*eps); % This routine kindly taken from TunnelMeshGen.m :)

platform_nodes1 = find(Xcoord(TopSide_nodes)<(l + (L - l)/2))';
platform_nodes = find(Xcoord(platform_nodes1)>(L - l)/2);

No_of_nodes_in_topXcoord = length(Xcoord); % total number of nodes
all_nodes = 1:No_of_nodes_in_topXcoord;

excluded_top_nodes = setdiff(all_nodes, platform_nodes); % Using setdiff

ndofs_ip = 2*length(Coord(:,1));
ndofs_op = 3*length(Coord(:,1));


fw_ext = zeros(ndofs_op,1);
fu_ext = zeros(ndofs_ip,1);

% External force by big mac
Body = m*g/(length(platform_nodes)-1);
for i = 1:length(platform_nodes)-1
    fu_ext(2*platform_nodes(i)) = fu_ext(2*platform_nodes(i))+ Body/2;
    fu_ext(2*platform_nodes(i+1)) = fu_ext(2*platform_nodes(i+1)) + Body/2;
end

% Stiffness matrices
Kww = zeros(ndofs_op);
Kuu = zeros(ndofs_ip);

for iel = 1:nel
    
    y_avg = (max(Ey(iel,:))+min(Ey(iel,:)))/2;

    p = rho*g*y_avg;
    
    [Keww, few_ext,Keuu,Bu] = ownKirchhoffQuad(Ex(iel,:),Ey(iel,:),[ptype h],Dbar,p,t,D);

    fw_ext(Edof_oop(iel,2:end)) = fw_ext(Edof_oop(iel,2:end)) + few_ext;

    Kww(Edof_oop(iel,2:end),Edof_oop(iel,2:end)) = Kww(Edof_oop(iel,2:end),Edof_oop(iel,2:end)) + Keww;
    Kuu(Edof_ip(iel,2:end),Edof_ip(iel,2:end)) = Kuu(Edof_ip(iel,2:end),Edof_ip(iel,2:end)) + Keuu;

end

F_nodal_total = sum(fw_ext) + sum(fu_ext);

F_anal = rho * g * H * L + m*g;