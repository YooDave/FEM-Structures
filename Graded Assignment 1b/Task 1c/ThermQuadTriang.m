function [fe_int,Ke,fe_ext,state,stress] = ThermQuadTriang(ed,da,Ex,Ey,De,...
    d,state_old,stress_old, mpar, T, dT,alpha)

% Gauss weights for quadratic triangles
H = 1/6; 

% Initializing a bunch of variables
Ke = zeros(12);
fe_int = zeros(12,1);
state = zeros(size(state_old));
stress = zeros(size(stress_old));

% Calculating area of element
% Ae=Area(Ex(1),Ey(1),Ex(2),Ey(2),Ex(3),Ey(3));

% Determining B-matrix and Fisop-matrix for all three gauss points
[Be,Fisop] = Be_quad_func([Ex(1) Ey(1)]',[Ex(2) Ey(2)]',...
    [Ex(3) Ey(3)]',[Ex(4) Ey(4)]',[Ex(5) Ey(5)]',...
    [Ex(6) Ey(6)]');
sizeBe = zeros(1,size(Be(:,:,1),2));

for i = 1:3    
    
    strain = [Be(:,:,i);sizeBe] * ed;
    dstrain = [Be(:,:,i);sizeBe] * da;
    
    % Compute trial stress (and add zero zz-strain component using D as 4x4 matrix
    % stress_trial = stress_old(:,i) + De*[dstrain(1:3);0];
    stress_trial = stress_old(:,i) + De*(dstrain -alpha*dT*[1;1;1;0]);

    % Compute updated stress and updated state variables from trial stress
    [stress(:,i),deps,state(:,i)]=mises(2,[mpar.Emod;mpar.nu;mpar.Hmod],stress_trial',...
        state_old(:,i)');

    % Compute tangent material behaviour
    dstress_dstrain = dmises(2,[mpar.Emod mpar.nu mpar.Hmod],stress(:,i)',state(:,i)');

    % Ke = Ke + Be(:,:,i).' * De*Be(:,:,i)*H*d*det(Fisop(:,:,i));

    fe_int = fe_int + [Be(:,:,i);sizeBe].'* stress(:,i)*d*H*det(Fisop(:,:,i));
    Ke = Ke + [Be(:,:,i);sizeBe].' * dstress_dstrain * H * [Be(:,:,i);sizeBe] * d* det(Fisop(:,:,i));
    
end

fe_ext = zeros(12,1);

end