%% Material model parameters
g = 9.81; % Gravitational acceleration
mpar.Emod=210e9; %Pa
mpar.Sy=400e6; %Pa
mpar.Hmod=mpar.Emod/20;
nu = 0.3;
dens = 7850;

% Gravitation (1=yes; 0=no)
grav = 0;

% External force P acting on node 3
P = -5000; % Force in [N]

% D matrix of material properties for plane strain
% ptype=2; %ptype=1: plane stress ||| 2: plane strain ||| 3:axisym ||| 4: 3d
% D=hooke(ptype,mpar.Emod,nu); % Constitutive matrix - plane stress
De = (mpar.Emod / ((1 + nu) * (1 - 2*nu))) * [1-nu, nu, 0; nu, 1-nu, 0; 0, 0, (1-2*nu)/2];

% Length
L = 2;

% Height
h = 2;

% Depth
d = 1;

% Element connectivity Edof
Edof = [1 1 2 5 6 13 14 11 12 15 16 17 18;...
    2 1 2 3 4 5 6 7 8 9 10 11 12];

% No. of elements
nelem = size(Edof,1);

% Position of nodes
Coord = [0 0; L 0; L h; L/2 0; L h/2; L/2 h/2; 0 h; L/2 h; 0 h/2];
nnodes = size(Coord,1);
ndofs = 2*nnodes;

% DoFs in each node
dof = zeros(nnodes,2);
for i = 1:nnodes
    dof(i,1) = 2*i -1;
    dof(i,2) = 2*i;
end

% Compute Ex and Ey from CALFEM routine
[Ex,Ey]=coordxtr(Edof,Coord,dof,6);

% Initialize displacements
a=zeros(ndofs,1);
aold=zeros(ndofs,1);  %old displacements (from previous timestep)
da=a-aold;


% Define free dofs and constrained dofs
dof_F=[1:ndofs]; 
dof_C=[1 2 13 14 17 18];
dof_F(dof_C) = []; %removing the prescribed dofs from dof_F

% Time stepping
ntime=40; %number of timesteps
tend=100; %end of time [s]
t=linspace(0,tend,ntime);

% Test run
a_total = zeros(ndofs,ntime);

% Initialize variables for post processing
K = spalloc(ndofs,ndofs,20*ndofs); % defines K as a sparse matrix and sets the size
                                   % to (ndof x ndof) with initial zero value
                                   % No. of estimated non-zero entries is 20*ndofs

% Initialize internal and external force
fint = zeros(ndofs,1);
fext = fint;

% Vector of applied external forces
f_ext = fint;
f_ext(6) = P;

%tolerance value for Newton iteration
tol=1e-6;

% Initializing stress and strain matrices
Et = zeros(nelem,3); % Strain
Es = zeros(nelem,3); % Stress


%---------------------------------------------------
% Newton iteration for solving Non-Linear problem
%---------------------------------------------------

for i=1:ntime
    % Initial guess of unknown displacement field
    a(dof_F)=aold(dof_F)+da(dof_F);
	
    % Newton iteration to find unknown displacements
    unbal=1e10; niter=0;
    while unbal > tol
        K=K.*0; 
        fint=fint.*0; %nullify
        fext = f_ext;
		
        % Loop over elements
        for iel=1:nelem
		
            % Extract element diplacements
            ed=a(Edof(iel,2:end));
			
            % Element calculations for CST
            [fe_int,Ke,fe_ext] = QuadTriang(ed,Ex(iel,:),Ey(iel,:),De,d);

            % Assembling
            fint(Edof(iel,2:end))=fint(Edof(iel,2:end))+fe_int;
            fext(Edof(iel,2:end))=fext(Edof(iel,2:end))+fe_ext;
			
            K(Edof(iel,2:end),Edof(iel,2:end))=...
                K(Edof(iel,2:end),Edof(iel,2:end))+Ke;

            % Calculation of strain and stress
            % Et(iel,:) = Be*a(Edof(iel,2:end)); % Strain
            % Es(iel,:) = De*Be*a(Edof(iel,2:end)); % Stress
				
        end
        % Unbalance equation
        g_F=fint(dof_F)-fext(dof_F);
		
        unbal=norm(g_F);
        if unbal > tol
            % Newton update
            a(dof_F)=a(dof_F)-K(dof_F,dof_F)\g_F;
        end 
		
        niter=niter+1; %update iter counter
        [niter unbal]  %print on screen
		
        if niter>400
            disp('no convergence in Newton iteration')
            break
        end

        f_extC = fint(dof_C)- fext(dof_C);


    end
    

    da=a-aold;
    aold = a;
    a_total(:,i) = a;    
end



% Analytical solution of cantilever beam
% https://www.engineeringtoolbox.com/cantilever-beams-d_1848.html
I = 1/12 * d*h^3;
defl = abs(P)*L^3 /(3*mpar.Emod*I);


