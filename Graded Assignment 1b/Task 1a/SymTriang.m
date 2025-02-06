% From lecture script

%defineisoparametriccoordinates andshapefunctions:
 xi=sym('xi',[2,1],'real');
 N1=1-xi(1)-xi(2);N2=xi(1);N3=xi(2);
 %differentiateshapefunctionswrtisoparam.coordinates
 dN1_dxi=gradient(N1,xi);
 dN2_dxi=gradient(N2,xi);
 dN3_dxi=gradient(N3,xi);
 %introducenodepositions
 xe1=sym('xe1',[2,1],'real');
 xe2=sym('xe2',[2,1],'real');
 xe3=sym('xe3',[2,1],'real');
 %introducespatialcoordinateasfcnofisoparam.coord.
 x=N1*xe1+N2*xe2+N3*xe3;
 %computeJacobian
 Fisop=jacobian(x,xi);
 %usechainruletocomputespatialderivatives
 dN1_dx=simplify(inv(Fisop)'*dN1_dxi);
 dN2_dx=simplify(inv(Fisop)'*dN2_dxi);
 dN3_dx=simplify(inv(Fisop)'*dN3_dxi);
 %defineelementB-matrix
Be=[dN1_dx(1),0, dN2_dx(1), 0, dN3_dx(1),0;
 0, dN1_dx(2), 0, dN2_dx(2), 0, dN3_dx(2);
 dN1_dx(2), dN1_dx(1), dN2_dx(2), dN2_dx(1), dN3_dx(2), dN3_dx(1)];

 matlabFunction(Be,'File','Be_cst_func','Vars',{xe1,xe2,xe3});