function [Keww, few_ext,Keuu,Be] = StressKirchhoffQuad(Ex,Ey,Dbar,p,t,D)

%gauss points
H_v = ones(1,4);
xi_v = [-1/sqrt(3) -1/sqrt(3) 1/sqrt(3) 1/sqrt(3);
    -1/sqrt(3) 1/sqrt(3) -1/sqrt(3) 1/sqrt(3)];

Keww= zeros(12,12); %initializing out of plane stiffness

few_ext = zeros(12,1);  %initializing external force

Keuu=zeros(8,8);%initializing in-plane stiffness


for gp=1:4

    %Out of plane
    Hgp = H_v(gp);
    xin = xi_v(:,gp);
    detFisop = detFisop_4node_func(xin,[ Ex(1) Ey(1) ]', ...
        [ Ex(2) Ey(2) ]', ...
        [ Ex(3) Ey(3) ]', ...
        [ Ex(4) Ey(4) ]');
    N = N_kirchoff_func(xin,[ Ex(1) Ey(1) ]',[ Ex(2) Ey(2) ]',...
        [ Ex(3) Ey(3) ]',[ Ex(4) Ey(4) ]');

    Bastn = Bast_kirchoff_func(xin,[ Ex(1) Ey(1) ]', ...
        [ Ex(2) Ey(2) ]', ...
        [ Ex(3) Ey(3) ]',...
        [ Ex(4) Ey(4) ]');
    Keww= Keww + Bastn'*Dbar*Bastn*detFisop*Hgp;

    %iNPLANe
    [Be,detFisop_uu,~]= Be_quad_func(xin,[Ex(1) Ey(1)]',[Ex(2) Ey(2)]',[Ex(3) Ey(3)]',[Ex(4) Ey(4)]');
    Keuu= Keuu + Be'*D*t*Be*detFisop_uu*Hgp;

    %finding Force external
    few_ext = few_ext + N'*detFisop_uu*Hgp*p;
    
end