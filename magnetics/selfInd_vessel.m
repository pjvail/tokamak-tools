function selfInd = selfInd_vessel(cond_data, nr, nz)
%
% SELFIND_VESSEL
%
%   Compute the self-inductance of a circular conductor with rectangular
%   cross-section. 
%
%   This function is suitable for computing the self-inductances of passive
%   elements (such as vessel segments) in which subelement inductances add
%   in parallel.
%
% USAGE: selfInd_vessel.m
%
% METHOD: The coil is partitioned into nturns rectangular subelements.
%
% INPUTS:
%
%   cond_data....array of length 6 with entries that are arranged 
%                as follows: [z; r; dz; dr; ac; ac2] where
%                    z:   vertical position of conductor center(s)  [m]
%                    r:   major radii of conductor center(s)        [m]
%                    dz:  full height of the conductor(s)           [m]
%                    dr:  full width of the conductors(s)           [m]
%                    ac:  counterclockwise rotation (angled bottom) [deg]
%                    ac2: counterclockwise rotation (flat bottom)   [deg]
%   nr..........number of radial   subelements in conductor
%   nz..........number of vertical subelements in conductor
%
% OUTPUTS: 
%
%   selfInd...self-inductance [H]
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

% Split conductor into rectangular subelements

subgeo = build_subelements(cond_data, nz, nr);

z  = subgeo(2,:);
r  = subgeo(3,:);
dz = subgeo(4,:);
dr = subgeo(5,:);

nsub = size(subgeo,2);  % total number of subelements

%...........................................................
% Construct the mutual inductance matrix (M1) for all subelements

M1 = zeros(nsub,nsub);

% Compute the mutuals between all subelements
% (only need to compute half due to reciprocity theorem)

for ii = 1:(nsub-1)
    for jj = (ii+1):nsub
        M1(ii,jj) = m_rect2rect(r(ii), z(ii), dr(ii), dz(ii), ...
            r(jj), z(jj), dr(jj), dz(jj));
    end
end

% Transpose and fill in lower-triangular part of M1

M1 = M1 + M1';

% Compute the self-inductance of each individual subelement and fill diag

for ii = 1:nsub
    M1(ii,ii) = selfInd_smallrect(r(ii), dr(ii), dz(ii));
end

%..........................
% Construct the matrix (M2)

M2 = zeros(nsub-1,nsub-1);

for ii = 1:(nsub-1)
    for jj = 1:(nsub-1)
        M2(ii,jj) = M1(1,1) + M1(ii+1,jj+1) - M1(ii+1,1) - M1(1,jj+1);
    end
end

%..............................................
% Compute the total self-inductance of the coil

selfInd = det(M1)/det(M2);
   
end
