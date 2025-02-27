%% function [mesh, coord, Edof_ip, Edof_oop]=rectMesh(xmin, xmax, ymin, ymax, nelx, nely)
%----------------------------------------------------------------------------
% INPUT:
%          xmin,xmax: min/max x-coordinates of planar plate in xy-plane
%          ymin,ymax: min/max y-coordinates of planar plate in xy-plane
%
%          nelx: number of elements along the x-direction 
%          nely: number of elements along the y-direction 
%
% OUTPUT:          
%          
%          mesh:  array where each column corresponds to an element and  
%                 where the rows indicates the nodes associated with that 
%                 element.
%
%          coord: Nnode x 2 array containing the x and y coordinates of
%                 each node (Nnode = total number of nodes)
%
%          Edof_ip: Element topology matrix for in-plane degrees of freedom
%                   according to CALFEM
%                   Each row correpsonds to an element and for that row
%                   columns 2:end gives the associated degrees-of-freedom (5
%                   dofs per node)
%
%          Edof_ip = [ 1, u1, v1 
%                      2, u1, v1 
%                      . ,  .,  . 
%                      .,  .,  . 
%                      nel, u1, v1];
%          Edof_oop: Element topology matrix for out-of-plane degrees of 
%                   freedom according to CALFEM.
%                   Each row correpsonds to an element and for that row
%                   columns 2:end gives the associated degrees-of-freedom (5
%                   dofs per node)
%
%          Edof_oop = [ 1,   w1, thetax1, thetay1, w2, thetax2, thetay2, ..., w4, thetax4, thetay4
%                       2,   ....                                                        , thetay4
%                       .,   ....                                                        , .
%                       .,   ....                                                        , .
%                       nel, w1, thetax1, thetay1, w2, thetax2, thetay2, ..., w4, thetax4, thetay4];
%----------------------------------------------------------------------------

function [mesh, coord, Edof_ip, Edof_oop]=rectMesh(xmin, xmax, ymin, ymax, nelx, nely)
j=1;
k=1;
for i=1:nelx*nely
    mesh(:,i)=[(j-1)+nelx*j-(nelx-k);(j-1)+nelx*j+1-(nelx-k);(nelx+1)*(j+1)-(nelx-k);(nelx+1)*(j+1)-1-(nelx-k)];
    k=k+1;
    if (k>nelx)
        k=1;
        j=j+1;
        if(j>nely)
            break
        end
    end
end

[X,Y]=meshgrid(linspace(xmin,xmax,nelx+1),linspace(ymin,ymax,nely+1));
X=X';
Y=Y';
coord=[X(:),Y(:)];
nodedof=2;
Edof_ip=zeros(nelx*nely,nodedof*4+1);
Edof_ip=sparse(Edof_ip);
Edof_ip(:,1)=[[1:1:(nelx)*(nely)]'];
for i=1:nodedof
Edof_ip(:,[i+1:nodedof:4*(nodedof)+1])=mesh'*nodedof-(nodedof-i);
end

nodedof=3;
Edof_oop=zeros(nelx*nely,nodedof*4+1);
Edof_oop=sparse(Edof_oop);
Edof_oop(:,1)=[[1:1:(nelx)*(nely)]'];
for i=1:nodedof
Edof_oop(:,[i+1:nodedof:4*(nodedof)+1])=mesh'*nodedof-(nodedof-i);
end
