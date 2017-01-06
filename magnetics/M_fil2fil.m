function M = M_fil2fil(fil_data)
%
% M_FIL2FIL
%
%   Compute the mutual inductance matrix for a set of filamentary
%   conductors.
%
% USAGE:  M_fil2fil.m
%
% INPUTS:
%
%   fil_data......matrix with dimensions 2 x (number of filaments).
%                 The rows are arranged: [z; r] where
%                     z:   vertical position of filament center(s)   [m]
%                     r:   major radii of filament center(s)         [m]
%
% OUTPUTS: 
%
%   M............mutual inductance matrix in units [H] with dimensions
%                (nfilaments) x (nfilaments)
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

nfils  = size(fil_data,2);

%.......................................
% Construct the mutual inductance matrix

% (only need to compute half due to reciprocity theorem)

M = zeros(nfils,nfils);

for ii = 1:(nfils-1)
    for jj = (ii+1):nfils
        
        fprintf(['Computing mutual between filament %d and '...
            'filament %d\n'], ...
            ii, jj)
        
        M(ii,jj) = m_fil2fil(fil_data(2,ii), fil_data(1,ii), ...
            fil_data(2,jj), fil_data(1,jj));
    end
end

% Transpose and fill in lower-triangular part

M = M + M';

% Compute the self-inductance of each individual filament and fill diag

for ii = 1:nfils
    
    fprintf('Computing self inductance of filament %d\n', ii)
    
    M(ii,ii) = selfInd_smallrect(fil_data(2,ii), 0.002, 0.002);
end

end
