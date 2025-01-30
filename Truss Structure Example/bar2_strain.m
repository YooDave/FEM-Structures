function [strain,Lmatrix]=bar2_strain(ex,ey,ed,L)
%----------------------------------------------------------------------
% INPUT:  ex = [x1 x2];
%         ey = [y1 y2];      element node coordinates
%         ed =[u1 u2 u3 u4]' element displacements
%         L initial length of bar
%
% OUTPUT: strain
%         Lmatrix, dim: 4x4
%----------------------------------------------------------------------
  direction=[ ex(2)-ex(1); ey(2)-ey(1) ]./L;
  cos_phi=(ex(2)-ex(1))/L; sin_phi=(ey(2)-ey(1))/L;
  Lmatrix=  [ cos_phi  sin_phi        0        0;
             -sin_phi  cos_phi        0        0;
                    0        0  cos_phi  sin_phi;
                    0        0 -sin_phi  cos_phi];
  ed_prime=Lmatrix*ed;
  strain=(ed_prime(3)-ed_prime(1))/L;
  
