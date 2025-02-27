clc
clear
close all

%%%%%%%%%%%%%%%%$

% Task1c

% Data
E = 210e9; nu = 0.3; 
D = hooke(1,E,nu);
h = 10e-3;
L_section = 2;
l_platform = 1;
H = 2;
rho = 1000; g = 9.81;

xmin = 0; ymin = 0; xmax = L_section; ymax = H; nelx = 5; nely = 5;

[mesh, coord, Edof_ip, Edof_oop] = rectMesh(xmin, xmax, ymin, ymax, nelx, nely);

nodes = mesh';

nel = nelx * nely;

Edof_ip = full(Edof_ip); Edof_oop = full(Edof_oop);

% Element Coordinates
elcoord = [coord(nodes(:,1),1), coord(nodes(:,1),2), coord(nodes(:,2),1), coord(nodes(:,2),2), coord(nodes(:,3),1), coord(nodes(:,3),2),coord(nodes(:,4),1), coord(nodes(:,4),2)];

X_coord = coord(:,1); Y_coord = coord(:,2);


% Boundary nodes and dofs

eps = 0.0001;

LeftSide_nodes=find(abs(X_coord-L_section)<100*eps)';
RightSide_nodes=find(abs(X_coord-0)<100*eps)';
BottomSide_nodes=find(abs(Y_coord-H)<100*eps)';
TopSide_nodes=find(abs(Y_coord-0)<100*eps)';
platform_nodes1 = find(X_coord(TopSide_nodes)<(l_platform + (L_section - l_platform)/2))';
platform_nodes = find(X_coord(platform_nodes1)>(L_section - l_platform)/2);
non_platform_nodes1 = find((l_platform + (L_section - l_platform)/2)<X_coord(TopSide_nodes))';
non_platform_nodes2 = find((L_section - l_platform)/2>X_coord(TopSide_nodes))';
non_platform_nodes = sort([non_platform_nodes2,non_platform_nodes1]);

ndofs_ip = 2*length(coord(:,1));
ndofs_op = 3*length(coord(:,1));

dofs = 1:ndofs_ip;

dof_left = zeros(2*length(LeftSide_nodes),1)';
for i = 1:length(LeftSide_nodes)
    startcolumn = (i-1)*2 + 1;
    endcolumn = startcolumn + 1;
    dof_left(startcolumn:endcolumn) = [(LeftSide_nodes(i)-1)*2 + 1;(LeftSide_nodes(i)-1)*2];
end

dof_right = zeros(2*length(RightSide_nodes),1)';
for i = 1:length(RightSide_nodes)
    startcolumn = (i-1)*2 + 1;
    endcolumn = startcolumn + 1;
    dof_right(startcolumn:endcolumn) = [(RightSide_nodes(i)-1)*2 + 1;(RightSide_nodes(i)-1)*2 + 2];
end

dof_bottom = zeros(2*length(BottomSide_nodes),1)';
for i = 1:length(BottomSide_nodes)
    startcolumn = (i-1)*2 + 1;
    endcolumn = startcolumn + 1;
    dof_bottom(startcolumn:endcolumn) = [(BottomSide_nodes(i)-1)*2 + 1;(BottomSide_nodes(i)-1)*2 + 2];
end

dof_platform = zeros(2*length(platform_nodes),1)';
for i = 1:length(platform_nodes)
    startcolumn = (i-1)*2 + 1;
    endcolumn = startcolumn + 1;
    dof_platform(startcolumn:endcolumn) = [(platform_nodes(i)-1)*2 + 1;(platform_nodes(i)-1)*2 + 2];
end

dof_non_platform = zeros(2*length(non_platform_nodes),1)';
for i = 1:length(non_platform_nodes)
    startcolumn = (i-1)*2 + 1;
    endcolumn = startcolumn + 1;
    dof_non_platform(startcolumn:endcolumn) = [(non_platform_nodes(i)-1)*2 + 1;(non_platform_nodes(i)-1)*2 + 2];
end


% Free and constrained dofs
fdof = 1:ndofs_ip;
cdof = [dof_left, dof_right, dof_bottom];
fdof(cdof) = [];

% Dummy inputs (required for Ke_inplane_Kirchoff and Ke_outplane_Kirchoff
ae_ip = zeros(8,1);
ae_op = zeros(12,1);
f_body_ip = zeros(2,1);

% Initializing stiffness matrices and force and displacement vectors
K_ip = zeros(ndofs_ip,ndofs_ip);
F_ip = zeros(ndofs_ip,ndofs_ip);
a_ip = zeros(ndofs_ip,1);
K_op = zeros(ndofs_op,ndofs_op);
F_op = zeros(ndofs_op,1);
a_op = zeros(ndofs_op,1);

% Boundary Traction
T_ip = zeros(ndofs_ip,1);
Person_weight = 150*g;
T_platform = zeros(length(dof_platform),1);

for i=1:length(platform_nodes)-1
    xe1n = X_coord(platform_nodes(i)); 
    ye1n = Y_coord(platform_nodes(i));
    xe2n = X_coord(platform_nodes(i+1)); 
    ye2n = Y_coord(platform_nodes(i+1));
    
    l_el = sqrt((ye2n-ye1n)^2+(xe2n-xe1n)^2);

    Platform_load = Person_weight / (l_el * h);
    traction = Traction_inplane(xe1n,ye1n,xe2n,ye2n,Platform_load,h);
    T_platform(i:i+3) = T_platform(i:i+3) + traction; 
end

T_ip(dof_platform) = T_platform;

% Boundary Condition
a_ip(cdof) = 0;
a_op(cdof) = 0;


% Assembling global stiffness matrices and external force vectors
for i = 1:nel
    X = elcoord(i,:)';
    [Ke_ip, Fe_ip,Fe_int_ip] = Ke_inplane_Kirchoff(X,D,h,ae_ip,f_body_ip);
    K_ip(Edof_ip(i,2:end),Edof_ip(i,2:end)) = K_ip(Edof_ip(i,2:end),Edof_ip(i,2:end)) + Ke_ip;
    F_ip(Edof_ip(i,2:end),1) = F_ip(Edof_ip(i,2:end),1) + Fe_ip;
    y_el = X(2) + (X(8)-X(2))/2;
    f_body_op = rho * g * y_el;
    [Ke_op, Fe_ext_op,Fe_int_op] = Ke_outplane_Kirchoff(X,D,h,ae_op,f_body_op);
    K_op(Edof_oop(i,2:end),Edof_oop(i,2:end)) = K_op(Edof_oop(i,2:end),Edof_oop(i,2:end)) + Ke_op;
    F_op(Edof_oop(i,2:end),1) = F_op(Edof_oop(i,2:end),1) + Fe_ext_op;
end

% Calculating total external force
F_ext_ip = F_ip + T_ip;
F_ext_op = F_op;

% Solving the in-plane problem
a_ip(fdof,1) = K_ip(fdof,fdof) \ F_ext_ip(fdof,1);

