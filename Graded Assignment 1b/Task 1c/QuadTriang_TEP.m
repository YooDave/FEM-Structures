function [fe_int, Ke, fe_ext] = QuadTriang_TEP(ed, Ex, Ey, De, d, alpha, DeltaT, sigma_old, ep_old, sigma_yield, mpar)

Ke = zeros(12);
fe_int = zeros(12,1);
H = 1/6;  % Integration weight

[Be, Fisop] = Be_quad_func([Ex(1) Ey(1)]', [Ex(2) Ey(2)]', ...
    [Ex(3) Ey(3)]', [Ex(4) Ey(4)]', [Ex(5) Ey(5)]', ...
    [Ex(6) Ey(6)]');

for i = 1:3    
    % Compute strain increment
    DeltaEps = Be(:,:,i) * ed;

    % Compute thermal strain increment
    DeltaEps_th = alpha * DeltaT * [1; 1; 1];

    % Compute trial stress
    Sigma_trial = sigma_old(:,i) + De * (DeltaEps - DeltaEps_th);

    % Use CALFEM function to check if yielding occurs
    [Sigma_new, ep_new, D_tangent] = mises(Sigma_trial, ep_old(i), sigma_yield, mpar.Hmod);

    % Update element stiffness matrix using tangent stiffness
    Ke = Ke + Be(:,:,i)' * D_tangent * Be(:,:,i) * H * d * det(Fisop(:,:,i));

    % Update internal force vector
    fe_int = fe_int + Be(:,:,i)' * Sigma_new * d * det(Fisop(:,:,i)) * H;

    % Store updated stress and plastic strain
    sigma_old(:,i) = Sigma_new;
    ep_old(i) = ep_new;
end

fe_ext = zeros(12,1);

end
