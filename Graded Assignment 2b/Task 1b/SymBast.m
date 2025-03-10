%initalize dNdx
dNdx=sym('dNdx',[12,2],'real');
%define dNdx by using the chain rule
dNdx(:,1) = diff(N(xi(1),xi(2)),xi(1))*invFisop(1,1) + ...
diff(N(xi(1),xi(2)),xi(2))*invFisop(2,1);
dNdx(:,2) = diff(N(xi(1),xi(2)),xi(1))*invFisop(1,2) + ...
diff(N(xi(1),xi(2)),xi(2))*invFisop(2,2);
%now Bast can be be computed
Bast(1,:) = diff(dNdx(:,1),xi(1))*invFisop(1,1) + ...
diff(dNdx(:,1),xi(2))*invFisop(2,1);
Bast(2,:) = diff(dNdx(:,2),xi(1))*invFisop(1,2) + ...
diff(dNdx(:,2),xi(2))*invFisop(2,2);
Bast(3,:) = 2*(diff(dNdx(:,1),xi(1))*invFisop(1,2) + ...
diff(dNdx(:,1),xi(2))*invFisop(2,2));
%and a function can be written

B = dNdx;

matlabFunction(Bast,'File','Bast_kirchoff_func','Vars',{xi,xe1,xe2,xe3,xe4});
matlabFunction(B,'File','B_matrix','Vars',{xi,xe1,xe2,xe3,xe4});