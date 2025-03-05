function sigma = Stress_2b(D,au,Ex,Ey)

xin = [0;0];

[Be,~,~]= Be_quad_func(xin,[Ex(1) Ey(1)]',[Ex(2) Ey(2)]',[Ex(3) Ey(3)]',[Ex(4) Ey(4)]');

sigma = D*Be*au;

end