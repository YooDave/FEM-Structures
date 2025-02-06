% function [fe_int,Ke] = QuadTriang()

% Element routine for quadratic triangular elements

% Define isoparametric coordinates
xi=sym('xi',[2,1],'real');

% Define six shape functions for quadratic elements
N1 = (1-xi(1)-xi(2))*(1-2*xi(1)-2*xi(2));
N2 = xi(1)*(2*xi(1)-1);
N3 = xi(2)*(2*xi(2)-1);
N4 = 4*xi(1)*(1-xi(1)-xi(2));
N5 = 4*xi(1)*xi(2);
N6 =4*xi(2)*(1-xi(1)-xi(2));

% Derivatives of shape functions
dN1_dxi=gradient(N1,xi);
dN2_dxi=gradient(N2,xi);
dN3_dxi=gradient(N3,xi);
dN4_dxi=gradient(N4,xi);
dN5_dxi=gradient(N5,xi);
dN6_dxi=gradient(N6,xi);

% Define node positions symbolicallz
xe1=sym('xe1',[2,1],'real');
xe2=sym('xe2',[2,1],'real');
xe3=sym('xe3',[2,1],'real');
xe4=sym('xe4',[2,1],'real');
xe5=sym('xe5',[2,1],'real');
xe6=sym('xe6',[2,1],'real');

% Define spatial coordinate as function of isoparam. coord.
x=N1*xe1 + N2*xe2 + N3*xe3 + N4*xe4 + N5*xe5 + N6*xe6;

% Compute Jacobian
Fisop=jacobian(x,xi);

% Use chain rule to compute spatial derivatives
dN1 = simplify(inv(Fisop)'*dN1_dxi);
dN2 = simplify(inv(Fisop)'*dN2_dxi);
dN3 = simplify(inv(Fisop)'*dN3_dxi);
dN4 = simplify(inv(Fisop)'*dN4_dxi);
dN5 = simplify(inv(Fisop)'*dN5_dxi);
dN6 = simplify(inv(Fisop)'*dN6_dxi);

% Calculate D-matrix using CALFEM
mpar.Emod = 200.e3; % Youngs modulus [MPa]
mpar.v = 0.3; % Poisson's ratio [-]
ptype=1; %ptype=1: plane stress 2: plane strain, 3:axisym, 4: 3d
D=hooke(ptype,mpar.Emod,mpar.v); % Constitutive matrix - plane stress

%——————————————————————————————————————————————
% Calculate element B-matrix
%——————————————————————————————————————————————
H = 1/6; % Integration weight
IP = [1/6, 1/6; 1/6, 2/3; 2/3, 1/6]; % Integration points


matlabFunction(Be,'File','Be_cst_func','Vars',{xe1,xe2,xe3,xe4,xe5,xe6});

