function [Ge,Keww] = Buckling(sigma,t,Ex,Ey,Dbar,p,D)

sigma_mat = [sigma(1), sigma(3); sigma(3), sigma(2)];

Nsec = sigma_mat*t;

ngp=9;

xi_v=[-sqrt(3/5), 0, sqrt(3/5), -sqrt(3/5), 0, sqrt(3/5), -sqrt(3/5), 0, sqrt(3/5);
    -sqrt(3/5), -sqrt(3/5), -sqrt(3/5), 0, 0,0, sqrt(3/5), sqrt(3/5), sqrt(3/5)
    ] ;

H_v=[0.309 0.494 0.309 0.494 0.790 0.494 0.309 0.494 0.309];

Ge = zeros(12);

for gp = 1:ngp
    
    Hgp = H_v(gp);
    xin = xi_v(:,gp);

    [~,detFisop,~]= Be_quad_func(xin,[Ex(1) Ey(1)]',[Ex(2) Ey(2)]',[Ex(3) Ey(3)]',[Ex(4) Ey(4)]');
    B = B_matrix(xin,[Ex(1) Ey(1)]',[Ex(2) Ey(2)]',[Ex(3) Ey(3)]',[Ex(4) Ey(4)]');

    Ge = Ge + B.'*Nsec*B*detFisop * Hgp;

end

[Keww, ~,~,~] = StressKirchhoffQuad(Ex,Ey,Dbar,p,t,D);

end