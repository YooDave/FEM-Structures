function [M,I,a,maxSig] = Solving(Ex,Ey,De,Z,L,g,BottomSide,LeftSide,RightSide,TopSide,Coord,Edof,rho_water,rho_conc,nu,E)

% BottomSide = BottomSide_nodes;
% LeftSide = LeftSide_nodes;
% TopSide = TopSide_nodes;
% RightSide = RightSide_nodes;

ndofs = 2*size(Coord,1);
dof_F= 1:ndofs;

p = Z*rho_water*g;


BC_dof = zeros(2*(size(BottomSide,1)) + size(LeftSide,1),1);

a_C = zeros(2*(size(BottomSide,1)) + size(LeftSide,1),1);

temp = 1;

for i = 1:size(BottomSide,1)
    BC_dof(temp) = 2*BottomSide(i)-1;
    a_C(temp) = 0;
    temp = temp+1;
    BC_dof(temp) = 2*BottomSide(i);
    a_C(temp) = 0;
    temp = temp+1;
end

for i = 1:size(LeftSide,1)
    BC_dof(temp) = 2*LeftSide(i)-1;
    a_C(temp) = 0;
    temp = temp+1;
end

 dof_C=BC_dof';

dof_F(unique(dof_C)) =[]; 

nel = size(Ex,1);



K = spalloc(ndofs,ndofs,20*ndofs);

temp = size(TopSide,1)+size(RightSide,1);

f_ext = zeros(ndofs,1);

for i = 1: size(TopSide,1)-1
    [f1x,f1y,f2x,f2y]= PressureLoad(Coord(TopSide(i),1),Coord(TopSide(i),2),...
        Coord(TopSide(i+1),1),Coord(TopSide(i+1),2),L,p);
    f_ext(2*TopSide(i)-1) = f_ext(2*TopSide(i)-1)+ f1x;
    f_ext(2*TopSide(i)) =f_ext(2*TopSide(i))+ f1y;
    f_ext(2*TopSide(i+1)-1) = f_ext(2*TopSide(i+1)-1)+ f2x;
    f_ext(2*TopSide(i+1)) =f_ext(2*TopSide(i+1))+ f2y;
end

for i = 1: size(RightSide,1)-1
    [f1x,f1y,f2x,f2y]= PressureLoad(Coord(RightSide(i),1),Coord(RightSide(i),2),...
        Coord(RightSide(i+1),1),Coord(RightSide(i+1),2),L,p);
    f_ext(2*RightSide(i)-1) =f_ext(2*RightSide(i)-1)+ f1x;
    f_ext(2*RightSide(i)) =f_ext(2*RightSide(i))+ f1y;
    f_ext(2*RightSide(i+1)-1) = f_ext(2*RightSide(i+1)-1)+f2x;
    f_ext(2*RightSide(i+1)) =f_ext(2*RightSide(i+1))+ f2y;
end

a = zeros(ndofs,1);

 %%Setup andsolveFEequations
 %Assemblestiffnessmatrixand loadvector

 

%tolerance value for Newton iteration
tol=1e-6;

for i=1:ntime
    %initial guess of unknown displacement field
    a(dof_F)=aold(dof_F)+da(dof_F);
	
    %%updated prescribed values
    a(6)=-uu(i);    
	
    %Newton iteration to find unknown displacements
    unbal=1e10; niter=0;
    while unbal > tol
        K=K.*0; fint=fint.*0; %nullify
		
        %loop over elements
        for iel=1:nelem
		
            %extract element diplacements
            ed=a(Edof(iel,2:end));
			
            % [fe_int, Ke, state_new, stress_temp] = trussElement(Ex(iel,:), Ey(iel,:), ed, L(iel), A(iel), state_old(iel,:), mpar);
			
            Ae=Area(Ex(iel,1),Ey(iel,1),Ex(iel,2),Ey(iel,2),Ex(iel,3),Ey(iel,3));
            Be=Be_cst_func([Ex(iel,1) Ey(iel,1)]',[Ex(iel,2) Ey(iel,2)]',...
            [Ex(iel,3) Ey(iel,3)]');
            Ke=Be'*De*Be*Ae*L;
            fe_int = Ke*ed;

            % stress(iel,i) = stress_temp;

            %assembling
            fint(Edof(iel,2:end))=fint(Edof(iel,2:end))+fe_int;
			
            K(Edof(iel,2:end),Edof(iel,2:end))=...
                K(Edof(iel,2:end),Edof(iel,2:end))+Ke;
				
            % temporarily updating state
            % state(iel,:) = state_new;
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
    % state_old=state;
    %save how large the displacement has changed during the timesstep
    % to get a good initial guess for next timesteps
    da=a-aold;
    aold = a;
    a_total(:,i) = a;    
end

 % for el = 1:nel
 % Ae=Area(Ex(el,1),Ey(el,1),Ex(el,2),Ey(el,2),Ex(el,3),Ey(el,3));
 % Be=Be_cst_func([Ex(el,1) Ey(el,1)]',[Ex(el,2) Ey(el,2)]',...
 % [Ex(el,3) Ey(el,3)]');
 % A_total = A_total +Ae;
 % Ke=Be'*De*Be*Ae*L;
 % m_node=-L*rho_conc*Ae/3;
 % fe_ext=g*[0;m_node;0;m_node;0;m_node];
 % %assembling
 % K(Edof(el,2:end),Edof(el,2:end))=K(Edof(el,2:end),Edof(el,2:end))+Ke;
 % f_ext(Edof(el,2:end))=f_ext(Edof(el,2:end))+fe_ext;
 % end


 a_F= K(dof_F,dof_F)\(f_ext(dof_F)-K(dof_F,dof_C)*a_C);
 f_extC=K(dof_C,dof_F)*a_F+K(dof_C,dof_C)*a_C-f_ext(dof_C);%reactionforces
 a(dof_F,1)=a_F;
 a(dof_C,1)=a_C;
 [M,I] = max(a,[],"ComparisonMethod","abs");

 
 Ed=extract_dofs(Edof,a); %extractelementdisplacementsforplotting
 plotpar=[1 1 0];
 sfac=2000; %magnificationfactor
 eldisp2(Ex,Ey,Ed,plotpar,sfac);


 %find the stresses in the elements sigx,sigy,tauxy
 %(code adapted for plane stress, ptype=1, must be modified for ptype=2)
 Es=zeros(nel,3);
 Et=zeros(nel,3);
 sig33=zeros(nel,1);
 sigma=zeros(3,3,nel);
 V = zeros(nel,3);
 for el=1:nel
 Be=Be_cst_func([Ex(el,1) Ey(el,1)]',[Ex(el,2) Ey(el,2)]',...
 [Ex(el,3) Ey(el,3)]');
 Et(el,:)=Be*a(Edof(el,2:end));
 Es(el,:)=De*Be*a(Edof(el,2:end));

 sig33(el) = (nu*E)/((1+nu)*(1-2*nu))*(Et(el,1)+Et(el,2));

 sigma(:,:,el) = [Es(el,1), Es(el,3), 0; Es(el,3),Es(el,2),0;0,0,sig33(el)];
 V(el,:) = eig(sigma(:,:,el));

 end

 % for plotting of stress in element (here: Es(el,1) = sigma_xx)
 for el=1:nel
 Esm1(el,1:3)=ones(1,3)*V(el,1);
 Esm2(el,1:3)=ones(1,3)*V(el,2);
 Esm3(el,1:3)=ones(1,3)*V(el,3);
 end
 figure(2)

 fill(Ex',Ey',Esm1')
title('Principal Stress 1 [Pa]')
colorbar
axis equal

figure(3)

 fill(Ex',Ey',Esm2')
title('Principal Stress 2 [Pa]')
colorbar
axis equal

figure(4)

 fill(Ex',Ey',Esm3')
title('Principal Stress 3 [Pa]')
colorbar
axis equal

maxSig = [max(V(:,1),[],"ComparisonMethod","abs");...
    max(V(:,2),[],"ComparisonMethod","abs");max(V(:,3),[],"ComparisonMethod","abs")];


 end