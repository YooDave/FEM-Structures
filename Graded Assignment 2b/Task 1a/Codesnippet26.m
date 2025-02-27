xi=sym('xi',[2,1],'real');

 %definebasefunctionsforisoparamquadrilateralelement
 N1=0.25*(xi(1)-1)*(xi(2)-1);
 N2=-0.25*(xi(1)+1)*(xi(2)-1);
 N3=0.25*(xi(1)+1)*(xi(2)+1);
 N4=-0.25*(xi(1)-1)*(xi(2)+1);

 %introducenodepositions
 xe1=sym('xe1',[2,1],'real');
 xe2=sym('xe2',[2,1],'real');
 xe3=sym('xe3',[2,1],'real');
 xe4=sym('xe4',[2,1],'real');

 %introducespatialcoordinateasfcnofisoparam.coord.
 x=N1*xe1+N2*xe2+N3*xe3+N4*xe4;

 %computeJacobian
 Fisop=jacobian(x,xi);
 invFisop=simplify(inv(Fisop));
 detFisop=simplify(det(Fisop));

 %createMatlabfunctionsforlateruse
 % matlabFunction(invFisop,'File','invFisop_4node_func','Vars',{xi,xe1,xe2,xe3,xe4});
 % matlabFunction(detFisop,'File','detFisop_4node_func','Vars',{xi,xe1,xe2,xe3,xe4});

 %DefinePmatrix,alphacoefficientsandw(xi)
 P(xi)=[1   xi(1)   xi(2)   xi(1)^2     xi(1)*xi(2)     xi(2)^2     xi(1)^3     xi(1)^2*xi(2)   xi(1)*xi(2)^2   xi(2)^3     xi(1)^3*xi(2)   xi(1)*xi(2)^3];
 alpha=sym('alpha',[12,1],'real');
 w(xi)=P(xi(1),xi(2))*alpha;

 %differentiatePwithrespecttox,y.Usechainrule.
 dPdxi=sym('dPxi',[12,2],'real');
 dPdxi1(xi)=diff(P(xi(1),xi(2)),xi(1));
 dPdxi2(xi)=diff(P(xi(1),xi(2)),xi(2));
 dPdx1(xi)=jacobian(P(xi(1),xi(2)),xi)*invFisop(:,1);
 dPdx2(xi)=jacobian(P(xi(1),xi(2)),xi)*invFisop(:,2);

 %initializeAmatrix
 A=sym('A',[12,12],'real');

 %givepoints(cornernodesinisoparamelement)
 np=[-1 -1;
     -1 -1;
     -1 -1;
      1 -1; 
      1 -1; 
      1 -1; 
      1 1; 
      1 1; 
      1 1; 
     -1 1;
     -1 1;
     -1 1];

 %defineAmatrixbasedonPand derivativesofP
 for i = [1 4 7 10]
    A(i,:)=P(np(i,1),np(i,2));
 end
 for i = [2 5 8 11]
    A(i,:)=dPdx1(np(i,1),np(i,2));
 end
 for i=[3 6 9 12]
    A(i,:)=dPdx2(np(i,1),np(i,2));
 end

 %Finally. solve for N and produce matlab function
 N = simplify(P*inv(A));
 % matlabFunction(N, detFisop, invFisop, 'File','Ne_Kirchoff','Vars',{xi,xe1,xe2,xe3,xe4});

 %initalizedNdx
 dNdx=sym('dNdx',[12,2],'real');

 %definedNdxbyusingthechain rule
 dNdx(:,1)=diff(N(xi(1),xi(2)),xi(1))*invFisop(1,1)+diff(N(xi(1),xi(2)),xi(2))*invFisop(2,1);
 dNdx(:,2)=diff(N(xi(1),xi(2)),xi(1))*invFisop(1,2)+diff(N(xi(1),xi(2)),xi(2))*invFisop(2,2);
 
 %nowBastcanbebecomputed
 Bast(1,:)=diff(dNdx(:,1),xi(1))*invFisop(1,1)+diff(dNdx(:,1),xi(2))*invFisop(2,1);
 Bast(2,:)=diff(dNdx(:,2),xi(1))*invFisop(1,2)+diff(dNdx(:,2),xi(2))*invFisop(2,2);
 Bast(3,:)=2*(diff(dNdx(:,1),xi(1))*invFisop(1,2)+diff(dNdx(:,1),xi(2))*invFisop(2,2));

 %anda functioncanbewritten
 matlabFunction(N, detFisop, invFisop, Bast,'File','Bast_Kirchoff','Vars',{xi,xe1,xe2,xe3,xe4});