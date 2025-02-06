function [Ae,Be,Ke,fe_int,fe_ext] = CST_Calc(ed,iel,Ex,Ey,De,d,dens,g,grav)

% Area of element
Ae=Area(Ex(iel,1),Ey(iel,1),Ex(iel,2),Ey(iel,2),Ex(iel,3),Ey(iel,3));

% B-Matrix of element
Be=Be_cst_func([Ex(iel,1) Ey(iel,1)]',[Ex(iel,2) Ey(iel,2)]',...
    [Ex(iel,3) Ey(iel,3)]');

% Element stiffness matrix
Ke=Be'*De*Be*Ae*d;

% Internal force vector of element
fe_int = Ke*ed;

% Gravitational force vector of element
fe_ext = zeros(6,1);
if grav == 1
    fe_ext = d*dens*Ae*g*1/3 *[0;-1;0;-1;0;-1];
end

end