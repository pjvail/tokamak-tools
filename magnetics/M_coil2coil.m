function M = M_coil2coil(coil_data, nturns)
%
% M_COIL2COIL
%
%   Compute the mutual inductance matrix for a set of coils.
%
%   The coil cross-sections are assumed to be represented by
%   parallelograms with geometry defined by the EFIT convention.
%
% USAGE:  M_coil2coil.m
%
% INPUTS:
%
%   coil_data....matrix with dimensions 6 x (number of coils). 
%                The rows are arranged: [z; r; dz; dr; ac; ac2] where,
%                    z:   vertical position of conductor center(s)  [m]
%                    r:   major radii of conductor center(s)        [m]
%                    dz:  full height of the conductor(s)           [m]
%                    dr:  full width of the conductors(s)           [m]
%                    ac:  counterclockwise rotation (angled bottom) [deg]
%                    ac2: counterclockwise rotation (flat bottom)   [deg]
%   nturns.......array of length (number of coils) containing the
%                number of turns for each coil
%
% OUTPUTS: 
%
%   M............mutual inductance matrix in units [H] with dimensions
%                (ncoils) x (ncoils)
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

ncoils = length(nturns);

%.......................................
% Construct the mutual inductance matrix

% (only need to compute half due to reciprocity theorem)

M = zeros(ncoils,ncoils);

for ii = 1:(ncoils-1)
    for jj = (ii+1):ncoils
        
        fprintf('Computing mutual between coil %d and coil %d\n', ii, jj)
        
        M(ii,jj) = m_coil2coil(coil_data(:,ii), nturns(ii), ...
            coil_data(:,jj), nturns(jj));
    end
end

% Transpose and fill in lower-triangular part

M = M + M';

% Compute the self-inductance of each individual coil and fill diag

for ii = 1:ncoils
    
    fprintf('Computing self inductance of coil %d\n', ii)
    
    M(ii,ii) = selfInd_coil(coil_data(:,ii), nturns(ii));
end

end
