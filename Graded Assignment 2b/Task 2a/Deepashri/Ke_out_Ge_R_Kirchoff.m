function [Ke_outplane, Ge_R] = Ke_out_Ge_R_Kirchoff(X,D,h,Ne_sec_R)
 
xe1n = X(1:2);
xe2n = X(3:4);
xe3n = X(5:6);
xe4n = X(7:8);

% Calculating reference geometric stiffness 
Ge_R = zeros(12,12);

gp = [-sqrt(3/5) 0 sqrt(3/5) -sqrt(3/5) 0 sqrt(3/5) -sqrt(3/5) 0 sqrt(3/5);
      -sqrt(3/5) -sqrt(3/5) -sqrt(3/5) 0 0 0 sqrt(3/5) sqrt(3/5) sqrt(3/5)];
Hgp = [0.309 0.494 0.309 0.494 0.790 0.494 0.309 0.494 0.309];


for i = 1:length(Hgp)
    xin = gp(:,i);
    [~, detFisop, ~, ~, Be_buckling] = Bast_Kirchoff(xin, xe1n, xe2n, xe3n, xe4n);
    Ge_R = Ge_R + detFisop * Hgp(i) * Be_buckling * Ne_sec_R * Be_buckling';
end

% Calculating Ke_ww
Ke_outplane = zeros(12,12);

gp = [-1/sqrt(3) -1/sqrt(3) 1/sqrt(3) 1/sqrt(3);
      -1/sqrt(3) 1/sqrt(3) -1/sqrt(3) 1/sqrt(3)];
Hgp = ones(1,4);

for i = 1:length(Hgp)
    xin = gp(:,i);
    [~, detFisop_outplane, ~, Be_ast, ~] = Bast_Kirchoff(xin, xe1n, xe2n, xe3n, xe4n);
    Ke_outplane = Ke_outplane + detFisop_outplane * Hgp(i) * Be_ast' * D*(h^3/12)*Be_ast;
end