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
P = -20000; % Force in [N]

% D matrix of material properties for plane strain
De = (mpar.Emod / ((1 + nu) * (1 - 2*nu))) * [1-nu, nu, 0; nu, 1-nu, 0; 0, 0, (1-2*nu)/2];

% Length
L = 2;

% Height
h = 2;

% Depth
d = 1;

% Element connectivity Edof
Edof = [1 1 2 5 6 7 8;2 1 2 3 4 5 6];

% No. of elements
nelem = size(Edof,1);

% Position of nodes
Coord = [0 0; L 0; L h; 0 h];
nnodes = size(Coord,1);
ndofs = 2*nnodes;

% DoFs in each node
dof = [1 2; 3 4; 5 6; 7 8];

% Compute Ex and Ey from CALFEM routine
[Ex,Ey]=coordxtr(Edof,Coord,dof,3);

% eldraw2(Ex,Ey);
% xlabel('x-coordinate [m]');
% ylabel('y-coordinate [m]')

scatter(Ex,Ey,"k");
hold on;
xlabel('x-coordinate [m]');
ylabel('y-coordinate [m]')
% plot([0,2,0,2,0,0,0,0,2,2],[0,2,2,2,0,2,2,2,0,2],"k")
plot([0,2,0,0,2,2],[0,2,2,0,0,2],"k")
xlim([-0.5, 2.5]);
ylim([-0.5 2.5]);

% Initialize displacements
a=zeros(ndofs,1);
aold=zeros(ndofs,1);  %old displacements (from previous timestep)
da=a-aold;


% Define free dofs and constrained dofs
dof_F=[1:ndofs]; 
dof_C=[1 2 6 7 8];
dof_F(dof_C) = []; %removing the prescribed dofs from dof_F

% Time stepping
ntime=100; %number of timesteps
tend=ntime; %end of time [s]
t=linspace(0,tend,ntime);

% Test run
a_total = zeros(ndofs,ntime);

% Displacement control
amax = 1E-3;
aa = linspace(0,amax,ntime);

% Initialize variables for post processing
K = spalloc(ndofs,ndofs,20*ndofs); % defines K as a sparse matrix and sets the size
                                   % to (ndof x ndof) with initial zero value
                                   % No. of estimated non-zero entries is 20*ndofs

% Initialize internal and external force
fint = zeros(ndofs,1);
fext = fint;
F=zeros(size(aa));

% Vector of applied external forces
f_ext = [0;0;0;0;0;P;0;0];

%tolerance value for Newton iteration
tol=1e-6;

% Initializing stress and strain matrices
Et = zeros(nelem,3); % Strain
Es = zeros(nelem,3); % Stress

niter_total = 0;

%---------------------------------------------------
% Newton iteration for solving Non-Linear problem
%---------------------------------------------------

for i=1:ntime
    % Initial guess of unknown displacement field
    a(dof_F)=aold(dof_F)+da(dof_F);

    a(6) = -aa(i);
	
    % Newton iteration to find unknown displacements
    unbal=1e10; niter=0;
    while unbal > tol
        K=K.*0; 
        fint=fint.*0; %nullify
        % fext = f_ext;
		fext = f_ext;

        % Loop over elements
        for iel=1:nelem
		
            % Extract element diplacements
            ed=a(Edof(iel,2:end));
			
            % Element calculations for CST
            [Ae,Be,Ke,fe_int,fe_ext] = CST_Calc(ed,iel,Ex,Ey,De,d,dens,g,grav);

            % Assembling
            fint(Edof(iel,2:end))=fint(Edof(iel,2:end))+fe_int;
            fext(Edof(iel,2:end))=fext(Edof(iel,2:end))+fe_ext;
			
            K(Edof(iel,2:end),Edof(iel,2:end))=...
                K(Edof(iel,2:end),Edof(iel,2:end))+Ke;

            % Calculation of strain and stress
            Et(iel,:) = Be*a(Edof(iel,2:end)); % Strain
            Es(iel,:) = De*Be*a(Edof(iel,2:end)); % Stress
				
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
		
        if niter>20
            disp('no convergence in Newton iteration')
            break
        end

        f_extC = fint(dof_C)- fext(dof_C);


    end
    
    niter_total = cat(1,niter_total,niter);
    F(i)=-fint(6);

    da=a-aold;
    aold = a;
    a_total(:,i) = a;    
    plot(aa,F,'-') %for plotting during simulation
    drawnow
end


close all
plot(aa,F,'linewidth',2)
set(gca,'FontSize',14,'fontname','Times New Roman')
xlabel('$a$ [m]','FontSize',16,'interpreter','latex')
ylabel('$F$ [N]','FontSize',16,'interpreter','latex')
grid on

niter_total(1) = [];
plot(t,niter_total)
xlabel('Time step')
ylabel('Number of iterations')

P = F(end);

% Analytical solution of cantilever beam
% https://www.engineeringtoolbox.com/cantilever-beams-d_1848.html
I = 1/12 * d*h^3;
defl = abs(P)*L^3 /(3*mpar.Emod*I);

P = (amax * 3*mpar.Emod*I)/L^3;
