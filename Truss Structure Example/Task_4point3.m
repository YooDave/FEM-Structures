clear all
close all
format short e
%% Material model parameters
mpar.Emod=200e9; %Pa
mpar.Sy=400e6; %Pa
mpar.Hmod=mpar.Emod/20;

%%Lengths 
Length1 = 2;
Length2 = 1;

% Length of bars
L1=Length1; %m
L2=Length1*sqrt(2); %m
L3=Length2*2; 
L=[L1 L2 L3];

%%Areas of bars
A=[5E-4 5E-4 5E-4]; %m^2

%%Element connectivity
Edof=[1 1 2 5 6;2 3 4 5 6; 3 7 8 5 6];

%%Number of elements
nelem=size(Edof,1);

%%Position of nodes
Coord=[0 Length1; 0 0; Length1 Length1; Length1+Length2 0];
nnodes=size(Coord,1); ndofs=2*nnodes;

%%Dof's in each node
Dof=[1 2; 3 4; 5 6; 7 8];

%compute Ex and Eu from Calfem routine
[Ex,Ey]=coordxtr(Edof,Coord,Dof,2);

%time stepping
ntime=100; %number of timesteps
tend=100; %end of time [s]
t=linspace(0,tend,ntime);

%Initialize displacements
a=zeros(ndofs,1);
aold=zeros(ndofs,1);  %old displacements (from previous timestep)
da=a-aold;

%initialize state variables
state=zeros(nelem,2);
state_old=zeros(nelem,2); %old state variables

%define free dof and prescribed dof
dof_F=[1:ndofs]; dof_C=[1 2 3 4 7 8];
dof_F(dof_C) = []; %removing the prescribed dofs from dof_F


% Test run
a_total = zeros(ndofs,ntime);

%displacement control of dof 6:
Pmax = 500000;
PP=Pmax*t./tend;

%Initialize varaible for post.processing

aa=zeros(size(PP)); %initialize variable for post-processing
K = spalloc(ndofs,ndofs,20*ndofs); % defines K as a sparse matrix and sets the size
                                   % to (ndof x ndof) with initial zero value
                                   % No. of estimated non-zero entries is 20*ndofs
% Initialize internal and external force
fint = zeros(ndofs,1);
fext = fint;

stress = zeros(nelem,ntime);


%tolerance value for Newton iteration
tol=1e-6;

for i=1:ntime
    %initial guess of unknown displacement field
    a(dof_F)=aold(dof_F)+da(dof_F);

    % %%updated prescribed values
    % a(6)=-uu(i);    
	
    fext(5) = PP(i)*sqrt(3)/2;
    fext(6) = PP(i)*0.5;

    %Newton iteration to find unknown displacements
    unbal=1e10; niter=0;
    while unbal > tol
        K=K.*0; fint=fint.*0; %nullify
		
        %loop over elements
        for iel=1:nelem
		
            %extract element diplacements
            ed=a(Edof(iel,2:end));
			
            [fe_int, Ke, state_new, stress_temp] = trussElement(Ex(iel,:), Ey(iel,:), ed, L(iel), A(iel), state_old(iel,:), mpar);
			
            stress(iel,i) = stress_temp;

            %assembling
            fint(Edof(iel,2:end))=fint(Edof(iel,2:end))+fe_int;
			
            K(Edof(iel,2:end),Edof(iel,2:end))=...
                K(Edof(iel,2:end),Edof(iel,2:end))+Ke;
				
            % temporarily updating state
            state(iel,:) = state_new;
        end
        %unbalance equation
        g_F=fint(dof_F)-fext(dof_F);
		
        unbal=norm(g_F);
        if unbal > tol
            %Newton update
            a(dof_F)=a(dof_F)-K(dof_F,dof_F)\g_F;
        end 
		
        niter=niter+1; %update iter counter
        [niter unbal]  %print on screen
		
        if niter>20
            disp('no convergence in Newton iteration')
            pause
        end
        
    end
    
    %save data for post-processing and update state variables now
    % (when Newton iteration has converged in the time increment)
    P(i)=-fint(6);
    state_old=state;
    %save how large the displacement has changed during the timesstep
    % to get a good initial guess for next timesteps
    da=a-aold;
    aold = a;
    a_total(:,i) = a;
    aaa = sqrt(a(5)^2 + a(6)^2);
    plot(aaa,P,'-') %for plotting during simulation
    drawnow
end

close all
plot(aaa,P,'linewidth',2)
set(gca,'FontSize',14,'fontname','Times New Roman')
xlabel('$u$ [m]','FontSize',16,'interpreter','latex')
ylabel('$P$ [N]','FontSize',16,'interpreter','latex')
grid on

%% Task 4.2
% Force needed if u = L2/50
[val,ind] = max(P);

% Stress at this condition
stress_ind = stress(:,ind)*10^-6;
