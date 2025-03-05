function sigma = Stress(D,au,aw,z,Ex,Ey)

xi_v = [-1/sqrt(3) -1/sqrt(3) 1/sqrt(3) 1/sqrt(3);
    -1/sqrt(3) 1/sqrt(3) -1/sqrt(3) 1/sqrt(3)];

sigma_matrix = zeros(3,4);

for gp=1:4
    
    xin = xi_v(:,gp);

    Bastn = Bast_kirchoff_func(xin,[ Ex(1) Ey(1) ]', ...
        [ Ex(2) Ey(2) ]', ...
        [ Ex(3) Ey(3) ]',...
        [ Ex(4) Ey(4) ]');

    [Be,~,~]= Be_quad_func(xin,[Ex(1) Ey(1)]',[Ex(2) Ey(2)]',[Ex(3) Ey(3)]',[Ex(4) Ey(4)]');

    sigma_matrix(:,gp) = D*(Be*au-z*Bastn*aw);

end

sigma = mean(sigma_matrix,2);

end