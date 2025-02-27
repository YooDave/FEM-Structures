
xi=sym('xi',[2,1],'real');
N1=0.25*(xi(1)-1)*(xi(2)-1);N2=-0.25*(xi(1)+1)*(xi(2)-1);
N3=0.25*(xi(1) +1)*(xi(2)+1);N4=-0.25*(xi(1)-1)*(xi(2)+1);
%defineN-matrixfortheelement
Ne=[N1 0 N2 0 N3 0 N4 0;
    0 N1 0 N2 0 N3 0 N4];
%differentiateshapefunctionswrtisoparam.coordinates
dN1_dxi=gradient(N1,xi);
dN2_dxi=gradient(N2,xi);
dN3_dxi=gradient(N3,xi);
dN4_dxi=gradient(N4,xi);
%introducenodepositions
xe1=sym('xe1',[2,1],'real');
xe2=sym('xe2',[2,1],'real');
xe3=sym('xe3',[2,1],'real');
xe4=sym('xe4',[2,1],'real');
%introducespatialcoordinateasfcnofisoparam.coord.
x=N1*xe1+N2*xe2+N3*xe3+N4*xe4;
%computeJacobian
Fisop=jacobian(x,xi);
detFisop=det(Fisop);
%usechainruletocomputespatialderivatives
dN1_dx=simplify(inv(Fisop)'*dN1_dxi);
dN2_dx=simplify(inv(Fisop)'*dN2_dxi);
dN3_dx=simplify(inv(Fisop)'*dN3_dxi);
dN4_dx=simplify(inv(Fisop)'*dN4_dxi);
%defineB-matrixofelement
Be=[dN1_dx(1),0,dN2_dx(1),0,dN3_dx(1),0,dN4_dx(1),0;
    0,dN1_dx(2),0,dN2_dx(2),0,dN3_dx(2),0,dN4_dx(2);
    dN1_dx(2),dN1_dx(1),dN2_dx(2),dN2_dx(1),dN3_dx(2),dN3_dx(1),...
    dN4_dx(2),dN4_dx(1)];
matlabFunction(Be,detFisop,Ne,'File','Be_quad_func','Vars',{xi,xe1,xe2,xe3,xe4});