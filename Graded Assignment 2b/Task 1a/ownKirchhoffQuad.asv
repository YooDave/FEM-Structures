function [Ke, fe_ext] = ownKirchhoffQuad(Ex,Ey,eq,Dbar,body)
ptype = eq(1);
h = eq(2);
%gauss points
H_v = ones(1,4);
xi_v = [-1/sqrt(3) -1/sqrt(3) 1/sqrt(3) 1/sqrt(3);
-1/sqrt(3) 1/sqrt(3) -1/sqrt(3) 1/sqrt(3)];
Ke = zeros(12,12);
fe_ext = zeros(12,1);
for gp=1:4
Hgp = H_v(gp);
xin = xi_v(:,gp);
detFisop = detFisop_4node_func(xin,[ Ex(1) Ey(1) ]', ...
[ Ex(2) Ey(2) ]', ...
[ Ex(3) Ey(3) ]', ...
[ Ex(4) Ey(4) ]');
N = N_kirchoff_func(xin,[ Ex(1) Ey(1) ]',[ Ex(2) Ey(2) ]',...
[ Ex(3) Ey(3) ]',[ Ex(4) Ey(4) ]');
fe_ext = fe_ext + N'*body*detFisop*Hgp;
Bastn = Bast_kirchoff_func(xin,[ Ex(1) Ey(1) ]', ...
[ Ex(2) Ey(2) ]', ...
[ Ex(3) Ey(3) ]',...
[ Ex(4) Ey(4) ]');
Ke = Ke + Bastn'*Dbar*Bastn*detFisop*Hgp;
end