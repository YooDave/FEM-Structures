%% Task 2a - Solving FE problem
clc 
clear all 
%---------------------------------------------------------
% Material and geometric parameters
E = 210e9; % Young's modulus steel
nu = 0.3; % Poisson's ratio steel
D = hooke(1,E,nu); % Note: Thin plate = plane stress 2D assumption
t = 10e-3; % Thickness of wall
rho = 1000; % Density of water
g = 9.81; % Gravitational acceleration
L=2; % Width of pool
H=2; % Height of pool
l=1; % Width of big mac's platform 
m = 150; % Big mac in kg

z = [t/2 , 0, -t/2];

Dbar=D*t^3/12; % Dbar matrix


% Define problem parameters
xmin = 0; xmax = L; % Plate length in meters
ymin = 0; ymax = H; % Plate height in meters

nelx = 20; % Number of elements along x-direction
nely = 20;  % Number of elements along y-direction
nel = nelx*nely; % Total number of elements

% Calling rectMesh function
[mesh, Coord, Edof_ip, Edof_oop] = rectMesh(xmin, xmax, ymin, ymax, nelx, nely);

% Number of nodes
nnodes = size(Coord,1);

% DoFs in each node
dofs = zeros(nnodes,2);
for i = 1:nnodes
    dofs(i,1) = 2*i-1;
    dofs(i,2) = 2*i;
end
  
[Ex,Ey]=coordxtr(Edof_ip,Coord,dofs,4); %Ex and Ey gives coordinates of element 

% Edof matrices
Edof_ip = full(Edof_ip); 
Edof_oop = full(Edof_oop);

% Vector containing nodes
nodes = 1:size(Coord,1);

% Extracting the following nodes
TopNodes = find(Coord(:,2)==0);
BottomNodes = find(Coord(:,2)==H);
LeftNodes = find(Coord(:,1)==L);
RightNodes = find(Coord(:,1)==0);

% Extracting nodes of the platform
PlatformNodes = find(Coord(:,1)<=(L/2+l/2) & Coord(:,1)>=(L/2-l/2) & Coord(:,2)==0);

% Number of dofs for in plane and oop problem
ndofs_ip = 2*length(Coord(:,1));
ndofs_op = 3*length(Coord(:,1));


% Boundary conditions OOP
dofw_F=[1:ndofs_op]; 
dofw_C=[3*LeftNodes;3*BottomNodes;3*RightNodes;3*LeftNodes-1;3*BottomNodes-1;3*RightNodes-1;3*LeftNodes-2;3*BottomNodes-2;3*RightNodes-2];
dofw_F(dofw_C) = []; %removing the prescribed dofs from dof_F
aw = zeros(ndofs_op,1);

% Boundary conditions IP
dofu_F=[1:ndofs_ip]; dofu_C=[2*LeftNodes;2*BottomNodes;2*RightNodes;2*LeftNodes-1;2*BottomNodes-1;2*RightNodes-1];
dofu_F(dofu_C) = []; %removing the prescribed dofs from dof_F
au = zeros(ndofs_ip,1);

% External force vector out of plane
fw_ext = zeros(ndofs_op,1);

% External force vector in-plane
fu_ext = zeros(ndofs_ip,1);

% External force by big mac
Body = m*g/(length(PlatformNodes)-1);
for i = 1:length(PlatformNodes)-1
    fu_ext(2*PlatformNodes(i)) = fu_ext(2*PlatformNodes(i))+ Body/2;
    fu_ext(2*PlatformNodes(i+1)) = fu_ext(2*PlatformNodes(i+1)) + Body/2;
end

% Stiffness matrices
Kww = zeros(ndofs_op);
Kuu = zeros(ndofs_ip);

% Pressure vector
p = zeros(nel,1);

%---------------------------------------------------------
% Element routine
%---------------------------------------------------------

for iel = 1:nel
    
    y_avg = (max(Ey(iel,:))+min(Ey(iel,:)))/2;

    p(iel) = rho*g*y_avg;
    
    [Keww, few_ext,Keuu] = StressKirchhoffQuad(Ex(iel,:),Ey(iel,:),Dbar,p(iel),t,D);

    fw_ext(Edof_oop(iel,2:end)) = fw_ext(Edof_oop(iel,2:end)) + few_ext;

    Kww(Edof_oop(iel,2:end),Edof_oop(iel,2:end)) = Kww(Edof_oop(iel,2:end),Edof_oop(iel,2:end)) + Keww;
    Kuu(Edof_ip(iel,2:end),Edof_ip(iel,2:end)) = Kuu(Edof_ip(iel,2:end),Edof_ip(iel,2:end)) + Keuu;

    % [Kww,fw_ext]=assem(Edof_oop,Kww,Keww,fw_ext,few_ext);
    % Kuu =assem(Edof_ip,Kuu,Keuu);

end
%---------------------------------------------------------
%---------------------------------------------------------


% Solving the oop problem
a_F = Kww(dofw_F, dofw_F)\(fw_ext(dofw_F) - Kww(dofw_F, dofw_C)*aw(dofw_C));
fw_extC = Kww(dofw_C, dofw_F)*a_F + Kww(dofw_C, dofw_C)*aw(dofw_C) - fw_ext(dofw_C);

% Displacement for OOP problem
aw(dofw_F) = a_F;

% Solving the in plane problem
a_F = Kuu(dofu_F, dofu_F)\(fu_ext(dofu_F) - Kuu(dofu_F, dofu_C)*au(dofu_C));
fu_extC = Kuu(dofu_C, dofu_F)*a_F + Kuu(dofu_C, dofu_C)*au(dofu_C) - fu_ext(dofu_C);

% Displacement for in plane problem
au(dofu_F) = a_F;

sigma = zeros(3,nel,3);
vm_stress = zeros(3,nel);

for iel = 1:nel

    % Mean stresses for three thickness points
    sigma(:,iel,1) = Stress(D,au(Edof_ip(iel,2:end)),aw(Edof_oop(iel,2:end)),z(1),Ex(iel,:),Ey(iel,:));
    sigma(:,iel,2) = Stress(D,au(Edof_ip(iel,2:end)),aw(Edof_oop(iel,2:end)),z(2),Ex(iel,:),Ey(iel,:));
    sigma(:,iel,3) = Stress(D,au(Edof_ip(iel,2:end)),aw(Edof_oop(iel,2:end)),z(3),Ex(iel,:),Ey(iel,:));
    
    % 
    vm_stress(1,iel) = VonMisesStress(sigma(:,iel,1));
    vm_stress(2,iel) = VonMisesStress(sigma(:,iel,2));
    vm_stress(3,iel) = VonMisesStress(sigma(:,iel,1));
end

for iel = 1:nel
    [Ge,Keww] = Buckling(sigma(:,iel,2),t,Ex(iel,:),Ey(iel,:),Dbar,p(iel),D);
end

% Extract displacement data
ed_w = extract_dofs(Edof_oop,aw);

% Initialize figure
figure;
hold on;

% Loop over each element and plot the stress
for i = 1:size(Ex,1) 
    % Calculate average stress for the element
    stress_avg = mean(sigma(:,i));
    
    % Draw each element as a filled polygon with color based on stress
    fill(Ex(i,:), Ey(i,:), stress_avg);
end

% Add colorbar and axis settings
hold off;
colorbar;
title('Stress Distribution');
xlabel('X-coordinate (m)');
ylabel('Y-coordinate (m)');
axis equal;
set(gca,'YDir','reverse');
set(gca,'XDir','reverse');


% % Plotting for in plane displacement using CALFEM
% ed_u = extract_dofs(Edof_ip,au);
% sfac = 2E5;
% figure
% eldisp2(Ex,Ey,ed_u,[1 1 0],sfac);
% set(gca,'YDir','reverse');
% set(gca,'XDir','reverse');
% 
% 
% % Plotting of oop displacement using the fill command
% ed_w = extract_dofs(Edof_oop,aw);
% figure;
% hold on;
% for i = 1:size(Ex,1) 
%     fill(Ex(i,:), Ey(i,:), mean(ed_w(i,1:3:end)));
% end
% hold off;
% colorbar;
% set(gca,'YDir','reverse');
% set(gca,'XDir','reverse');
