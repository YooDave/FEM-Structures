function [a,b,c,d] = Solving(Ex,Ey,D,h,BottomSide,LeftSide,Coord,Edof)

ndofs = size(Ex,1)*2;
dof_F= 1:ndofs;
dof_C=[BottomSide,LeftSide];

dof_F(dof_C) =[]; 

 a_C=[]';

nel = size(Ex,1);

body=zeros(nel,2); %herezeroinallelements
 %%Setup andsolveFEequations
 %Assemblestiffnessmatrixand loadvector
 for el = 1:nel
 Ae=Area(Ex(el,1),Ey(el,1),Ex(el,2),Ey(el,2),Ex(el,3),Ey(el,3));
 Be=Be_cst_func([Ex(el,1)Ey(el,1)]',[Ex(el,2)Ey(el,2)]',...
 [Ex(el,3)Ey(el,3)]');

 Ke=Be'*D*Be*Ae*h;
 fe_ext=[body(el,:)body(el,:) body(el,:)]'*Ae/3;
 %assembling
 K(Edof(el,2:end),Edof(el,2:end))=K(Edof(el,2:end),Edof(el,2:end))+Ke;
 f_ext(Edof(el,2:end))=f_ext(Edof(el,2:end))+fe_ext;
 end

 a_F=K(dof_F,dof_F)\(f_ext(dof_F)-K(dof_F,dof_C)*a_C);
 f_extC=K(dof_C,dof_F)*a_F+K(dof_C,dof_C)*a_C-f_ext(dof_C);%reactionforces
 a(dof_F,1)=a_F;
 a(dof_C,1)=a_C;
 Q=zeros(size(f));
 Q(dof_C)=f_extC;
 Ed=extract_dofs(Edof,a); %extractelementdisplacementsforplotting
 plotpar=[110];
 sfac=1; %magnificationfactor
 eldisp2(Ex,Ey,Ed,plotpar,sfac)
 %findthestressesintheelementssigx,sigy,tauxy
 %(codeadaptedforplanestress,ptype=1,mustbemodifiedforptype=2)
 Es=zeros(nel,3);Et=zeros(nel,3);
 forel=1:nel
 Be=Be_cst_func([Ex(el,1)Ey(el,1)]',[Ex(el,2)Ey(el,2)]',...
 [Ex(el,3) Ey(el,3)]');
 Et(el,:)=Be*a(Edof(el,2:end));
 Es(el,:)=D*Be*a(Edof(el,2:end));
 end
 %forplottingofstressinelement(here:Es(el,1)=sigma_xx)
 forel=1:nel
 Esm(el,1:3)=ones(1,3)*Es(el,1);
 end
 figure(2)


 end