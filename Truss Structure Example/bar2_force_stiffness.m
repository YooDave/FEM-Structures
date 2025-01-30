function [fe,Ke]=bar2_force_stiffness(stress,dstress_dstrain,A,L,Lmatrix)
% INPUT:  stress (along bar)
%         dstress_dstrain   (stress-strain stiffness)
%         A: area of bar
%         L: initial length of bar
%         Lmatrix, dim: 4x4
%
% OUTPUT: fe, dim: 4x1 element force
%         Ke, dim: 4x4 element stiffness
%----------------------------------------------------------------------
N=stress*A; %normal force
P_prime=[-N 0 N 0]';
fe=Lmatrix'*P_prime;
Ke_prime=[ 1 0 -1 0;
           0 0  0 0;
          -1 0  1 0;
           0 0  0 0]*dstress_dstrain*A/L;
Ke=Lmatrix'*Ke_prime*Lmatrix;
  

