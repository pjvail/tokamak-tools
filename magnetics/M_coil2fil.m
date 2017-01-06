function M = M_coil2fil(coil_data, nturns, fil_data)
%
% M_COIL2FIL
%
%   Compute the mutual inductance matrix between a set of coils and a set
%   of filamentary conductors (such as flux loops or plasma grid points).
%
%   The coil cross-sections are assumed to be represented by
%   parallelograms with geometry defined by the EFIT convention.
%
% USAGE:  M_coil2fil.m
%
% INPUTS:
%
%   coil_data.... matrix with dimensions 6 x (number of coils). 
%                 The rows are arranged : [z; r; dz; dr; ac; ac2] where,
%                     z:   vertical position of conductor center(s)  [m]
%                     r:   major radii of conductor center(s)        [m]
%                     dz:  full height of the conductor(s)           [m]
%                     dr:  full width of the conductors(s)           [m]
%                     ac:  counterclockwise rotation (angled bottom) [deg]
%                     ac2: counterclockwise rotation (flat bottom)   [deg]
%   nturns........array of length (number of coils) containing the
%                 number of turns for each coil
%   fil_data......matrix with dimensions 2 x (number of filaments).
%                 The rows are arranged: [z; r] where
%                     z:   vertical position of filament center(s)   [m]
%                     r:   major radii of filament center(s)         [m]
%
% OUTPUTS: 
%
%   M............mutual inductance matrix in units [H] with dimensions
%                (ncoils) x (nfilaments)
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

ncoils = size(coil_data,2);
nfils  = size(fil_data,2);

%.......................................
% Construct the mutual inductance matrix

M = zeros(ncoils,nfils);

for ii = 1:ncoils
    for jj = 1:nfils
        
        fprintf('Computing mutual between coil %d and filament %d\n', ...
            ii, jj)
        
        M(ii,jj) = m_coil2fil(coil_data(:,ii), nturns(ii), ...
            fil_data(:,jj));
    end
end

end
