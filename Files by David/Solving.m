%function [a,b,c,d] = Solving(Ex,Ey,D,h,BottomSide,LeftSide,Coord,Edof)

BottomSide = BottomSide_nodes;
LeftSide = LeftSide_nodes;
TopSide = TopSide_nodes;
RightSide = RightSide_nodes;

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
    % BC_dof(temp) = 2*LeftSide(i);
    % temp = temp+1;
end

 dof_C=BC_dof';

dof_F(dof_C) =[]; 

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
    f_ext(2*RightSide(i)-1) = f1x;
    f_ext(2*RightSide(i)) = f1y;
    f_ext(2*RightSide(i+1)-1) = f2x;
    f_ext(2*RightSide(i+1)) = f2y;
end

a = zeros(ndofs,1);

body=zeros(nel,2); %herezeroinallelements
 %%Setup andsolveFEequations
 %Assemblestiffnessmatrixand loadvector
 for el = 1:nel
 Ae=Area(Ex(el,1),Ey(el,1),Ex(el,2),Ey(el,2),Ex(el,3),Ey(el,3));
 Be=Be_cst_func([Ex(el,1) Ey(el,1)]',[Ex(el,2) Ey(el,2)]',...
 [Ex(el,3) Ey(el,3)]');

 Ke=Be'*D*Be*Ae*h;
 fe_ext=[body(el,:) body(el,:) body(el,:)]'*Ae/3;
 %assembling
 K(Edof(el,2:end),Edof(el,2:end))=K(Edof(el,2:end),Edof(el,2:end))+Ke;
 f_ext(Edof(el,2:end))=f_ext(Edof(el,2:end))+fe_ext;
 end

 a_F= K(dof_F,dof_F)\(f_ext(dof_F)-K(dof_F,dof_C)*a_C);
 f_extC=K(dof_C,dof_F)*a_F+K(dof_C,dof_C)*a_C-f_ext(dof_C);%reactionforces
 a(dof_F,1)=a_F;
 a(dof_C,1)=a_C;
 Q=zeros(size(f_ext));
 Q(dof_C)=f_extC;
 Ed=extract_dofs(Edof,a); %extractelementdisplacementsforplotting
 plotpar=[1 1 0];
 sfac=0.5; %magnificationfactor
 eldisp2(Ex,Ey,Ed,plotpar,sfac)
 %findthestressesintheelementssigx,sigy,tauxy
 %(codeadaptedforplanestress,ptype=1,mustbemodifiedforptype=2)
 Es=zeros(nel,3);Et=zeros(nel,3);
 for el=1:nel
 Be=Be_cst_func([Ex(el,1) Ey(el,1)]',[Ex(el,2) Ey(el,2)]',...
 [Ex(el,3) Ey(el,3)]');
 Et(el,:)=Be*a(Edof(el,2:end));
 Es(el,:)=D*Be*a(Edof(el,2:end));
 end
 %forplottingofstressinelement(here:Es(el,1)=sigma_xx)
 for el=1:nel
 Esm(el,1:3)=ones(1,3)*Es(el,1);
 end
 figure(2)

 fill(Ex',Ey',Esm')
title('axial stress [MPa]')
colorbar
axis equal
% now plot displacement as a function of x for the lower boundary
w=a([4 6 10 14]);
x=[0 L/3 2*L/3 L];
figure(3)
plot(x,w,'g-')
xlabel('x [mm]')


 % end