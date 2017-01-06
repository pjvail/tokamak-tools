function aphi = aphi_fil(r1, z1, r2, z2)
%
% APHI_FIL
%
%   Compute the toroidal component of the magnetic vector potential for a
%   circular current filament carrying 1 amp of current.
%
% USAGE: aphi_fil.m
%
% INPUTS:
%
%   r1........major radius of source point (filament)        [m]
%   z1........vertical position of source point (filament)   [m]
%   r2........major radius of field point                    [m]
%   z2........vertical position of field point               [m]
%  
% OUTPUTS: 
%
%   aphi......magnetic vector potential (toroidal component) [Vsec/m]
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

% Magnetic permeability 

mu0 = 4*pi*10^-7;

% Compute distance between source point and field point

d = (r1+r2)*(r1+r2) + (z2-z1)*(z2-z1);

% Compute argument of the elliptic integrals

m = sqrt(4*r2*r1/d);

% Compute the elliptic integrals

[K,E] = ellipke(m*m);

% Compute the vector potential

aphi = mu0/(2*pi) * sqrt(r1/r2) * 1/m * ((2-m*m)*K - 2*E);

end
