function [N, dNdxi, dNdeta] = shapeFunctions(xi, eta)
% SHAPEFUNCTIONS - Computes shape functions and their derivatives 
% for a 6-noded isoparametric triangular element.
%
% Inputs:
%   xi, eta - Local coordinates in the reference element (range: 0 to 1)
%
% Outputs:
%   N       - Shape function values [1x6]
%   dNdxi   - Derivative of shape functions w.r.t. xi [1x6]
%   dNdeta  - Derivative of shape functions w.r.t. eta [1x6]

% Shape functions for a 6-noded triangle
N = [
    (1 - xi - eta) * (1 - 2*xi - 2*eta); % N1
    xi * (2*xi - 1);                     % N2
    eta * (2*eta - 1);                    % N3
    4 * xi * (1 - xi - eta);              % N4
    4 * xi * eta;                         % N5
    4 * eta * (1 - xi - eta)              % N6
];

% Derivatives of shape functions w.r.t. xi
dNdxi = [
    - (1 - 4*xi - 4*eta);  % dN1/dxi
    4*xi - 1;              % dN2/dxi
    0;                     % dN3/dxi
    4*(1 - 2*xi - eta);    % dN4/dxi
    4*eta;                 % dN5/dxi
    -4*eta                 % dN6/dxi
];

% Derivatives of shape functions w.r.t. eta
dNdeta = [
    - (1 - 4*xi - 4*eta);  % dN1/deta
    0;                     % dN2/deta
    4*eta - 1;             % dN3/deta
    -4*xi;                 % dN4/deta
    4*xi;                  % dN5/deta
    4*(1 - xi - 2*eta)     % dN6/deta
];

end
