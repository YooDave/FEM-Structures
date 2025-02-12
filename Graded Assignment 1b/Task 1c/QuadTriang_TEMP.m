function [Ke, fe_int, sigma_new, ep_new] = QuadTriang_TEMP(ed, Ex, Ey, De, d, alpha, DeltaT, sigma_old, ep_old, sigma_yield, H)
% QUADTRIANG_TEP - 6-noded triangular element with thermo-elastoplastic behavior
% Inputs:
%   ed          - Element displacements
%   Ex, Ey      - Element nodal coordinates
%   De          - Elastic stiffness matrix
%   d           - Element thickness
%   alpha       - Coefficient of thermal expansion
%   DeltaT      - Temperature increment
%   sigma_old   - Stress from previous step
%   ep_old      - Equivalent plastic strain from previous step
%   sigma_yield - Yield stress
%   H           - Isotropic hardening modulus
%
% Outputs:
%   Ke      - Tangent stiffness matrix
%   fe_int  - Internal force vector
%   sigma_new - Updated stress tensor
%   ep_new  - Updated equivalent plastic strain

% Integration points (Gauss points for 6-node triangle)
xi = [1/6, 2/3, 1/6];  
eta = [1/6, 1/6, 2/3];  
w = [1/6, 1/6, 1/6];  

% Initialize matrices
Ke = zeros(12);  
fe_int = zeros(12, 1);  
sigma_new = sigma_old;
ep_new = ep_old;

[B,Fisop] = Be_quad_func([Ex(1) Ey(1)]',[Ex(2) Ey(2)]',...
    [Ex(3) Ey(3)]',[Ex(4) Ey(4)]',[Ex(5) Ey(5)]',...
    [Ex(6) Ey(6)]');

% Loop over Gauss points
for i = 1:3
    % % Compute shape functions and derivatives
    % [N, dNdxi, dNdeta] = shapeFunctions(xi(i), eta(i));
    % 
    % % Compute Jacobian and B-matrix
    % J = [Ex' Ey']' * [dNdxi' dNdeta'];
    % detJ = det(J);
    % dNdx = J \ [dNdxi; dNdeta];
    % 
    % % Strain-displacement matrix B
    % B = zeros(4, 12);
    % for j = 1:6
    %     B(1, 2*j-1) = dNdx(1,j);  
    %     B(2, 2*j) = dNdx(2,j);  
    %     B(3, 2*j-1) = dNdx(2,j);  
    %     B(3, 2*j) = dNdx(1,j);  
    % end
	
    % Compute strain increment
    DeltaEps = [B(:,:,i);zeros(1,size(B(:,:,i),2))] * ed;

    % Compute thermal strain increment
    DeltaEps_th = alpha * DeltaT * [1; 1; 1; 0];

    % Compute trial stress
    sigma_trial = sigma_old(:,i) + De * (DeltaEps - DeltaEps_th);

    % Compute von Mises equivalent stress
    s_trial = sigma_trial - mean(sigma_trial(1:2)) * [1; 1; 0; 0];
    sigma_eq = sqrt(3/2 * (s_trial(1)^2 + s_trial(2)^2 + 2*s_trial(3)^2));

    % Check yielding condition
    if sigma_eq > (sigma_yield + H * ep_old(i))
        % Plastic correction using return mapping
        DeltaGamma = (sigma_eq - (sigma_yield + H * ep_old(i))) / (3 * De(1,1) + H);
        sigma_corrected = sigma_trial - (3 * DeltaGamma * De(1,1)) * (s_trial / sigma_eq);
        ep_new(i) = ep_old(i) + DeltaGamma;
    else
        % Elastic case
        sigma_corrected = sigma_trial;
    end
    
    % Update stress
    sigma_new(:,i) = sigma_corrected;

    % Compute tangent stiffness matrix
    De_tangent = De;  
    if sigma_eq > sigma_yield  
        De_tangent = De - (3 * De(1,1) * De * (s_trial / sigma_eq) * (s_trial' / sigma_eq) * De) / (3 * De(1,1) + H);
    end

    % Assemble element stiffness
    Ke = Ke + [B(:,:,i);zeros(1,size(B(:,:,i),2))]' * De_tangent * [B(:,:,i);zeros(1,size(B(:,:,i),2))] * det(Fisop(:,:,i)) * w(i) * d;

    % Assemble internal force vector
    fe_int = fe_int + [B(:,:,i);zeros(1,size(B(:,:,i),2))]' * sigma_corrected * det(Fisop(:,:,i)) * w(i) * d;
end
end