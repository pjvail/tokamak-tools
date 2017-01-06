function M = M_vessel2vessel(cond_data, nr, nz)
%
% M_VESSEL2VESSEL
%
%   Compute the mutual inductance matrix for a set of passive conductors
%   (such as vessel segments).
%
%   The conductor cross-sections are assumed to be represented by
%   parallelograms with geometry defined by the EFIT convention.
%
% USAGE:  M_vessel2vessel.m
%
% INPUTS:
%
%   cond_data....matrix with dimensions 6 x (number of conductors). 
%                The rows are arranged as follows: [z; r; dz; dr; ac; ac2] 
%                where
%                    z:   vertical position of conductor center(s)  [m]
%                    r:   major radii of conductor center(s)        [m]
%                    dz:  full height of the conductor(s)           [m]
%                    dr:  full width of the conductors(s)           [m]
%                    ac:  counterclockwise rotation (angled bottom) [deg]
%                    ac2: counterclockwise rotation (flat bottom)   [deg]
%   nr..........array containing number of radial subelements in each
%                   conductor in set cond_data
%   nz..........array containing number of vertical subelements in each
%                   conductor in set cond_data
%
% OUTPUTS: 
%
%   M............mutual inductance matrix in units [H] with dimensions
%                (nvessel) x (nvessel)
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

nvessel = size(cond_data,2);

%.......................................
% Construct the mutual inductance matrix

% (only need to compute half due to reciprocity theorem)

M = zeros(nvessel,nvessel);

for ii = 1:(nvessel-1)
    for jj = (ii+1):nvessel
        
        fprintf('Computing mutual between vessel %d and vessel %d\n', ...
            ii, jj)
        
        M(ii,jj) = m_vessel2vessel(cond_data(:,ii), nr(ii), nz(ii), ...
            cond_data(:,jj), nr(jj), nz(jj));
    end
end

% Transpose and fill in lower-triangular part

M = M + M';

% Compute the self-inductance of each individual vessel seg and fill diag

for ii = 1:nvessel
    
    fprintf('Computing self inductance of vessel %d\n', ii)
    
    M(ii,ii) = selfInd_vessel(cond_data(:,ii), nr(ii), nz(ii));
end

end
