function psi = psi_fil(r1, z1, r2, z2)
%
% PSI_FIL
%
%   Compute the magnetic flux (per radian) produced by a circular current 
%   filament carrying 1 amp of current.
%
%   Psi = R * A_phi = major radius * toroidal component of vector potential
%
% USAGE: psi_fil.m
%
% INPUTS:
%
%   r1.............major radius of source point (filament)      [m]
%   z1.............vertical position of source point (filament) [m]
%   r2.............major radius of field point                  [m]
%   z2.............vertical position of field point             [m]
%
% OUTPUTS: 
%
%   psi............magnetic flux [Wb/rad]
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

% Compute the magnetic flux (per radian)

psi = r2 * aphi_fil(r1, z1, r2, z2);

end
