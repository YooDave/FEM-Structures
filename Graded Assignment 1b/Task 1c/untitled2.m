% Material properties
alpha = 10e-6; % Thermal expansion coefficient (K^-1)
sigma_yield = 500e6; % Yield stress (Pa)
H = 40000e6; % Hardening modulus (Pa)

% Initialize stress and plastic strain storage
sigma_old = zeros(3, nelem);
ep_old = zeros(nelem, 1);

% Apply temperature increase up to 300°C
Tmax = 300; % Max temperature
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

            % Use new element routine with thermo-elastoplasticity
            [fe_int, Ke, fe_ext] = QuadTriang_TEP(ed, Ex(iel,:), Ey(iel,:), De, d, ...
                alpha, DeltaT, sigma_old(:,iel), ep_old(iel), sigma_yield, H);

            % Assembly
            fint(Edof(iel,2:end)) = fint(Edof(iel,2:end)) + fe_int;
            fext(Edof(iel,2:end)) = fext(Edof(iel,2:end)) + fe_ext;
            K(Edof(iel,2:end), Edof(iel,2:end)) = K(Edof(iel,2:end), Edof(iel,2:end)) + Ke;

            % Store updated stress and plastic strain
            sigma_old(:,iel) = fe_int(1:3);
            ep_old(iel) = fe_int(4);
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
