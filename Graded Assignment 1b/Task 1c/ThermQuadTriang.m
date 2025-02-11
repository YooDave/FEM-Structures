function [fe_int,Ke,fe_ext] = ThermQuadTriang(ed,Ex,Ey,De,d)

Ke = zeros(12);
fe_int = zeros(12,1);
H = 1/6;

[Be,Fisop] = Be_quad_func([Ex(1) Ey(1)]',[Ex(2) Ey(2)]',...
    [Ex(3) Ey(3)]',[Ex(4) Ey(4)]',[Ex(5) Ey(5)]',...
    [Ex(6) Ey(6)]');

for i = 1:3    
    % Calculation of strain and stress
    % Et = Be(:,:,i)*ed;
    % Es = De*Be(:,:,i) * ed;
    
    Ke = Ke + Be(:,:,i).' * De*Be(:,:,i)*H*d*det(Fisop(:,:,i));
    % fe_int = fe_int + Be(:,:,i).'*Es * d* det(Fisop(:,:,i))*H;
end

fe_int = Ke*ed;
fe_ext = zeros(12,1);

% Calculate D-matrix using CALFEM
% mpar.Emod = 200.e3; % Youngs modulus [MPa]
% mpar.v = 0.3; % Poisson's ratio [-]
% ptype=1; %ptype=1: plane stress 2: plane strain, 3:axisym, 4: 3d
% D=hooke(ptype,mpar.Emod,mpar.v); % Constitutive matrix - plane stress

end