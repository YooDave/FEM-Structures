%% Material model parameters
mpar.Emod=210e9; % Young's modulus [Pa]
mpar.Sy=500e6; % Sigma yield [Pa]
mpar.Hmod=40000E6; % H-modulus [Pa]
mpar.nu = 0.3;
alpha_s = 10e-6; % Thermal expansion coefficient (K^-1)

mpar2.Emod = 80e9;
mpar2.Sy = 200e6;
mpar2.nu = 0.2;
mpar2.Hmod = 1000e6;
alpha_a = 20e-6;

load("bimetal_coarse.mat");

Coord = 1E-3*Coord;

% External force P acting on node 3
P = 0; % Force in [N]

% D matrix of material properties for plane strain
% ptype=1: plane stress ||| 2: plane strain ||| 3:axisym ||| 4: 3d
ptype=2; 
Ds =hooke(ptype,mpar.Emod,mpar.nu); % Constitutive matrix - plane strain
Da =hooke(ptype,mpar2.Emod,mpar2.nu); % Constitutive matrix - plane strain

% Length
L = 0.15;

% Height
h = 0.01;

% Depth
d = 0.04;

% No. of elements
nelem = nel;

% DoFs in each node
dof = Dof;

% Compute Ex and Ey from CALFEM routine
[Ex,Ey]=coordxtr(Edof,Coord,dof,6);

% Initialize displacements
a=zeros(ndofs,1);
aold=zeros(ndofs,1);  %old displacements (from previous timestep)
da=a-aold;


% Define free dofs and constrained dofs
dof_F=[1:ndofs]; 
dof_C= leftNodes;
dof_F(dof_C) = []; %removing the prescribed dofs from dof_F

% Time stepping
% ----------------------------------------------------
ntime=100; %number of timesteps
tend=ntime; %end of time [s]
t=linspace(0,tend,ntime);
% ----------------------------------------------------

% Test run
a_total = zeros(ndofs,ntime);

% Initialize variables for post processing
K = spalloc(ndofs,ndofs,20*ndofs); % defines K as a sparse matrix and sets the size
                                   % to (ndof x ndof) with initial zero value
                                   % No. of estimated non-zero entries is 20*ndofs

% Initialize internal and external force
fint = zeros(ndofs,1);
fext = fint;
F=zeros(1,ntime);

% Vector of applied external forces
f_ext = fint;
f_ext(6) = P;

% Temperature control
Tmin = 0;
Tmax = 300;
RiseFall = 0;
if RiseFall == 1
    T1 = linspace(Tmin,Tmax,ntime/2);
    T2 = linspace(Tmax,Tmin,ntime/2);
    T = cat(2,T1,T2);
else
    T = linspace(Tmin,Tmax,ntime);
end
dT = 0;

%tolerance value for Newton iteration
tol=1e-6;

%initialize state variables
no_state=3;
state=zeros(no_state, 3, nelem);
state_old=zeros(no_state, 3, nelem); %old state variables
state_old(2,:,:) = mpar.Sy;

for i = 1:nelem
    if max(Ey(i,:))>0.01
        state_old(2,:,i) = mpar.Sy;
    else
        state_old(2,:,i) = mpar2.Sy;
    end
end

% Initializing stress and strain matrices
stress_old = zeros(4, 3, nelem);
stress = stress_old;

niter_total = 0;

%---------------------------------------------------
% Newton iteration for solving Non-Linear problem
%---------------------------------------------------

for i=1:ntime
    % Initial guess of unknown displacement field
    a(dof_F)=aold(dof_F)+da(dof_F);
    
    if i>1
        dT = T(i)-T(i-1);
    end


    % Newton iteration to find unknown displacements
    unbal=1e10; niter=0;
    while unbal > tol
        K=K.*0; 
        fint=fint.*0; %nullify
        fext = f_ext;
        % fext(6) = PP(i);

        % Loop over elements
        for iel=1:nelem

            % Extract element diplacements
            ed=a(Edof(iel,2:end));
            d_ae = a(Edof(iel,2:end)) - aold(Edof(iel,2:end));

            % Element calculations for
            [fe_int, Ke,fe_ext, state_new, stress_new] = BiThermQuadTriang(ed,...
                d_ae,Ex(iel,:),Ey(iel,:),Ds,Da,d,state_old(:,:,iel),...
                stress_old(:,:,iel), mpar, mpar2,dT,alpha_s,alpha_a);

            % Assembling
            fint(Edof(iel,2:end))=fint(Edof(iel,2:end))+fe_int;
            fext(Edof(iel,2:end))=fext(Edof(iel,2:end))+fe_ext;

            K(Edof(iel,2:end),Edof(iel,2:end))=...
                K(Edof(iel,2:end),Edof(iel,2:end))+Ke;
            

            % temporarily updating state
            state(:,:,iel) = state_new;
            stress(:,:,iel) = stress_new;

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

        if niter>40
            disp('no convergence in Newton iteration')
            break
        end

        % f_extC = fint(dof_C)- fext(dof_C);


    end

    niter_total = cat(1,niter_total,niter);
    F(i) = -fint(5);
    
    stress_old = stress;
    state_old = state;
    da=a-aold;
    aold = a;
    a_total(:,i) = a;    
    % plot(T,F,'-') %for plotting during simulation
    % drawnow
end

close all
plot(T(1:end/2),F(1:end/2),'linewidth',2)
% hold on;
% plot(T(end/2:end),F(end/2:end),'linewidth',2,'r')
set(gca,'FontSize',14,'fontname','Times New Roman')
xlabel('$T$ [K]','FontSize',16,'interpreter','latex')
ylabel('$F$ [N]','FontSize',16,'interpreter','latex')
grid on
% 
% P = F(end);

stress_total = zeros(4,1,nelem);
stress_avg = zeros(nelem,1);
for i = 1:nelem
    stress_total(:,:,i) = stress(:,1,i) + stress(:,2,i) + stress(:,3,i);
    stress_avg(i,1) = (stress_total(1,1,i)+stress_total(2,1,i)+stress_total(3,1,i))/3;
end

niter_total(1) = [];

% Analytical solution of cantilever beam
% https://www.engineeringtoolbox.com/cantilever-beams-d_1848.html
sigma = mpar.Emod * alpha_s * (Tmax-Tmin);
F_anal = sigma * h*d;
F_FE = fint(5) + fint(9) + fint(3);

% Check stress_avg, min(a), fint, generally all results