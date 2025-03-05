% Test case
Ex = [2 11 12 3]*1e-3;
Ey = [4 5 21 22]*1e-3;
t = 50e-3;
E = 80e9;
nu = 0.2;
G_modulus = E/(2*(1+nu));
G = G_modulus*eye(2,2);
D = hooke(1,E,nu); % Note: Thin plate = plane stress 2D assumption
Dbar=D*t^3/12; % Dbar matrix
sigma2D = [1 2; 2 3]*1e6; 

p = 1;

X = [Ex(1) Ey(1) Ex(2) Ey(2) Ex(3) Ey(3) Ex(4) Ey(4)]';
Ne_sec_test = sigma2D * t;

[Ge,Keww] = Buckling(Ne_sec_test,t,Ex,Ey,Dbar,p,D);
