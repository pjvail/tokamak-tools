function M = M_vessel2fil(vessel_data, vvnr, vvnz, fil_data)
%
% M_VESSEL2FIL
%
%   Compute the mutual inductance matrix between a set of passive
%   conductors (such as vessel segments) and a set of filamentary 
%   conductors (such as flux loops or plasma grid points).
%
%   The conductor cross-sections are assumed to be represented by
%   parallelograms with geometry defined by the EFIT convention.
%
% USAGE:  M_vessel2fil.m
%
% INPUTS:
%
%   vessel_data.. matrix with dimensions 6 x (number of conductors). 
%                 The rows are arranged : [z; r; dz; dr; ac; ac2] where,
%                     z:   vertical position of conductor center(s)  [m]
%                     r:   major radii of conductor center(s)        [m]
%                     dz:  full height of the conductor(s)           [m]
%                     dr:  full width of the conductors(s)           [m]
%                     ac:  counterclockwise rotation (angled bottom) [deg]
%                     ac2: counterclockwise rotation (flat bottom)   [deg]
%   vvnr..........array containing number of radial subelements in each
%                     passive conductor 
%   vvnz..........array containing number of vertical subelements in each
%                     passive conductor
%   fil_data......matrix with dimensions 2 x (number of filaments).
%                 The rows are arranged: [z; r] where
%                     z:   vertical position of filament center(s)   [m]
%                     r:   major radii of filament center(s)         [m]
%
% OUTPUTS: 
%
%   M............mutual inductance matrix in units [H] with dimensions
%                (nvessel) x (nfilaments)
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

nvessel = size(vessel_data,2);
nfils  = size(fil_data,2);

%.......................................
% Construct the mutual inductance matrix

M = zeros(nvessel,nfils);

for ii = 1:nvessel
    for jj = 1:nfils
        
        fprintf('Computing mutual between vessel %d and filament %d\n', ...
            ii, jj)
        
        M(ii,jj) = m_vessel2fil(vessel_data(:,ii), vvnr(ii), vvnz(ii), ...
            fil_data(:,jj));
    end
end

end
