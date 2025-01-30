function [fe_int, Ke, state] = trussElement(ex, ey, ed, L, A, state_old, mpar)

%compute strain and transformation matrix
[strain,Lmatrix]=bar2_strain(ex,ey,ed,L);
%compute stress, dstress/dstrain and state variables for a given strain
[stress,dstress_dstrain,state] = ...
    matmod_plast(strain,state_old,mpar);
%compute element force and stiffness
[fe_int,Ke]= bar2_force_stiffness(stress,dstress_dstrain,A,L,Lmatrix);
