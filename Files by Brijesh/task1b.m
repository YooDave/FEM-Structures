% Coordinates of the triangular element nodes
x1 = 0;
y1 = 0;
x2 = 1;
y2 = 0.25;
x3 = 0.5;
y3 = 1;

% Material and thickness parameters
E = 30e9;  % Young's modulus [MPa]
nu = 0.2;   % Poisson's ratio
h = 1;     % Thickness [m]
% Plane strain
D = (E / ((1 + nu) * (1 - 2*nu))) * [1-nu  nu    0;
    nu   1-nu   0;
    0    0   (1-2*nu)/2];


% Area of the triangle
A = 0.5 * det([1 x1 y1;
    1 x2 y2;
    1 x3 y3]);

% B-matrix components
b1 = y2 - y3; 
b2 = y3 - y1; 
b3 = y1 - y2;
c1 = x3 - x2;
c2 = x1 - x3;
c3 = x2 - x1;

% B-matrix (strain-displacement matrix)
B = (1 / (2 * A)) * [b1  0   b2  0   b3  0;
    0   c1  0   c2  0   c3;
    c1  b1  c2  b2  c3  b3];

% Element stiffness matrix
Ke = h * A * (B' * D * B);

% Display results
disp('Element stiffness matrix Ke:');
disp(Ke);
