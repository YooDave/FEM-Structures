%% Properties

% Material properties
E = 30E9; % Young's modulus
nu = 0.2; % Poisson's ratio
g = 9.81; % Gravitational accel
rho_conc = 2200; % density concrete kg/m^3
L = 1; % Thickness in z-direction

% Properties in he table
Z = 45;
B = 15;
H = 20;
D = 6;
b = 6;
h = 7;
r = 2;

% Coordinates of the triangular element nodes
x1 = 0;
y1 = 0;
x2 = 1;
y2 = 0.25;
x3 = 0.5;
y3 = 1;

% Area of triangle element using determinant method
A = 1/2 * det([x1, y1, 1; x2, y2, 1; x3, y3, 1]);

% D matrix of material properties resulting from Voigt notation
D = (E / ((1 + nu) * (1 - 2*nu))) * [1-nu, nu, 0; nu, 1-nu, 0; 0, 0, (1-2*nu)/2];

% B matrix using the code snippet of the lecture script
B = Be_cst_func([0;0],[1;0.25],[0.5;1]);

% Thickness of 1m
h = 1;

% Element stiffness matrix of single triangle
K_el = B'*D*B*h*A;

m = rho_conc * A*h;

f_e = -g*[0;m/3;0;m/3;0;m/3];