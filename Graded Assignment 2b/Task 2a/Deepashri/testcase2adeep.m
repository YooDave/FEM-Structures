% Task 2A test case 
% Test case
Ex = [2 11 12 3]*1e-3;
Ey = [4 5 21 22]*1e-3;
t = 50e-3;
E = 80e9;
nu = 0.2;
G_modulus = E/(2*(1+nu));
G = G_modulus*eye(2,2);
D = hooke(1,E,nu); % Note: Thin plate = plane stress 2D assumption
sigma2D = [1 2; 2 3]*1e6;
X = [Ex(1) Ey(1) Ex(2) Ey(2) Ex(3) Ey(3) Ex(4) Ey(4)]';
Ne_sec_test = sigma2D * t;

[Ke_op_test_2, Ge_R_test] = Ke_out_Ge_R_Kirchoff(X,D,t,Ne_sec_test);

disp('K_ww : '); disp(Ke_op_test_2);
disp('Ge_R : '); disp(Ge_R_test);

% End of Test Case
