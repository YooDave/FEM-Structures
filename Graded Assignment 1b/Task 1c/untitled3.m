function [Ke, fe_int, sigma_new, ep_new] = QuadTriang_TEP(ed, Ex, Ey, De, d, alpha, DeltaT, sigma_old, ep_old, sigma_yield, H)
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

% Loop over Gauss points
for i = 1:3
    % Compute shape functions and derivatives
    [N, dNdxi, dNdeta] = shapeFunctions(xi(i), eta(i));
    
    % Compute Jacobian and B-matrix
    J = [Ex' Ey']' * [dNdxi' dNdeta'];
    detJ = det(J);
    dNdx = J \ [dNdxi; dNdeta];
    
    % Strain-displacement matrix B
    B = zeros(4, 12);
    for j = 1:6
        B(1, 2*j-1) = dNdx(1,j);  
        B(2, 2*j) = dNdx(2,j);  
        B(3, 2*j-1) = dNdx(2,j);  
        B(3, 2*j) = dNdx(1,j);  
    end

    % Compute strain increment
    DeltaEps = B * ed;

    % Compute thermal strain increment
    DeltaEps_th = alpha * DeltaT * [1; 1; 0; 0];

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
    Ke = Ke + B' * De_tangent * B * detJ * w(i) * d;

    % Assemble internal force vector
    fe_int = fe_int + B' * sigma_corrected * detJ * w(i) * d;
end
end
%%%%


alpha = 10e-6; % Thermal expansion coefficient (1/K)
sigma_yield = 500e6; % Yield stress (Pa)
H = 40000e6; % Hardening modulus (Pa)

% Initialize stress and plastic strain storage
sigma_old = zeros(4, nelem);
ep_old = zeros(nelem, 1);
%%%%%
Tmax = 300; % Max temperature in °C
T_steps = linspace(0, Tmax, ntime); % Temperature history

for i = 1:ntime
    DeltaT = T_steps(i) - (i > 1) * T_steps(i-1); % Temperature increment

    % Initial guess for displacement
    a(dof_F) = aold(dof_F) + da(dof_F);
    a(6) = -aa(i);

    % Newton-Raphson Iteration
    unbal = 1e10; niter = 0;
    while unbal > tol
        K = K .* 0;
        fint = fint .* 0;
        fext = fext .* 0;

        % Loop over elements
        for iel = 1:nelem
            ed = a(Edof(iel, 2:end));

            % Call new thermo-elastoplastic element routine
            [Ke, fe_int, sigma_new, ep_new] = QuadTriang_TEP(ed, Ex(iel,:), Ey(iel,:), De, d, ...
                alpha, DeltaT, sigma_old(:,iel), ep_old(iel), sigma_yield, H);

            % Assembly
            fint(Edof(iel,2:end)) = fint(Edof(iel,2:end)) + fe_int;
            K(Edof(iel,2:end), Edof(iel,2:end)) = K(Edof(iel,2:end)) + Ke;

            % Store updated stress and plastic strain
            sigma_old(:,iel) = sigma_new(:,iel);
            ep_old(iel) = ep_new(iel);
        end

        % Check convergence
        g_F = fint(dof_F) - fext(dof_F);
        unbal = norm(g_F);
        if unbal > tol
            a(dof_F) = a(dof_F) - K(dof_F, dof_F) \ g_F;
        end

        niter = niter + 1;
        if niter > 20
            disp('No convergence in Newton iteration');
            break;
        end
    end

    F(i) = -fint(6);
    da = a - aold;
    aold = a;
    a_total(:,i) = a;
end
