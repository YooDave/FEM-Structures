function [Et,Es,sig33,sigma] = StressTest(a,De,E,nu)

Es=zeros(1,3);Et=zeros(1,3);
 Be = Be_cst_func([0;0],[1;0.25],[0.5;1]);
 Et=Be*a;
 Es=De*Be*a;

sig33 = (nu*E)/((1+nu)*(1-2*nu))*(Et(1)+Et(2));

sigma = [Es(1), Es(3), 0; Es(3),Es(2),0;0,0,sig33];


end