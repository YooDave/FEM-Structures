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

% Define node positions symbolically
xe1=sym('xe1',[2,1],'real');
xe2=sym('xe2',[2,1],'real');
xe3=sym('xe3',[2,1],'real');
xe4=sym('xe4',[2,1],'real');
xe5=sym('xe5',[2,1],'real');
xe6=sym('xe6',[2,1],'real');

% Define spatial coordinate as function of isoparam. coord.
x=N1*xe1 + N2*xe2 + N3*xe3 + N4*xe4 + N5*xe5 + N6*xe6;

% Compute Jacobian
Fisopeeee=jacobian(x,xi);

% Use chain rule to compute spatial derivatives
dN1 = simplify(inv(Fisopeeee)'*dN1_dxi);
dN2 = simplify(inv(Fisopeeee)'*dN2_dxi);
dN3 = simplify(inv(Fisopeeee)'*dN3_dxi);
dN4 = simplify(inv(Fisopeeee)'*dN4_dxi);
dN5 = simplify(inv(Fisopeeee)'*dN5_dxi);
dN6 = simplify(inv(Fisopeeee)'*dN6_dxi);

%——————————————————————————————————————————————
% Calculate element B-matrix
%——————————————————————————————————————————————
% H = 1/6; % Integration weight
IP = [1/6, 1/6; 1/6, 2/3; 2/3, 1/6].'; % Integration points

% Structure of B-matrix
B = [dN1(1), 0, dN2(1), 0, dN3(1), 0, dN4(1), 0, dN5(1), 0, dN6(1), 0 ;
0, dN1(2), 0, dN2(2), 0, dN3(2), 0, dN4(2), 0, dN5(2), 0, dN6(2);
dN1(2), dN1(1), dN2(2), dN2(1), dN3(2), dN3(1), dN4(2), dN4(1), dN5(2), dN5(1), dN6(2), dN6(1)];

% Initializing 3 empty matrices for 3 gauss points
Be = sym(zeros(size(B,1),size(B,2),3));
Fisop = sym(zeros(size(Fisopeeee,1),size(Fisopeeee,2),3));

% Computing symbolic B-matrix for all three gauss points
for i = 1:3
    Be(:,:,i) = subs(B,xi,IP(:,i));
    Fisop(:,:,i) = subs(Fisopeeee,xi,IP(:,i));
end

% Creating function file
matlabFunction(Be,Fisop,'File','Be_quad_func','Vars',{xe1,xe2,xe3,xe4,xe5,xe6});
