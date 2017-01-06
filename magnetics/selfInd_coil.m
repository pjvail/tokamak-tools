function selfInd = selfInd_coil(coil_data, nturns)
%
% SELFIND_COIL
%
%   Compute the self-inductance of a circular coil with rectangular
%   cross-section and nturns.
%
% USAGE: selfInd_coil.m
%
% METHOD: The coil is partitioned into nturns rectangular subelements.
%         The self-inductance of the coil is the sum of the self-inductance
%         of each subelement plus the mutual inductances between all pairs
%         of subelements.
%
% INPUTS:
%
%   coil_data.....array of length 6 with entries that are arranged
%                 as follows: [z; r; dz; dr; ac; ac2] where
%                     z:   vertical position of conductor center(s)  [m]
%                     r:   major radii of conductor center(s)        [m]
%                     dz:  full height of the conductor(s)           [m]
%                     dr:  full width of the conductors(s)           [m]
%                     ac:  counterclockwise rotation (angled bottom) [deg]
%                     ac2: counterclockwise rotation (flat bottom)   [deg]
%   nturns......number of coil turns
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

% Determine the radial-vertical partitioning

if coil_data(3) > coil_data(4) % dz > dr (tall, skinny rectangle)
    dim = coil_data(4);
    nr  = 1;
    while dim > 0.031
        dim = dim/2;
        nr  = 2*nr;
    end
    nz = nturns/nr;
else                           % dr > dz (short, fat, rectangle)
    dim = coil_data(3);
    nz  = 1;
    while dim > 0.035
        dim = dim/2;
        nz  = 2*nz; 
    end
    nr = nturns/nz;
end

% Split conductor into rectangular subelements

subgeo = build_subelements(coil_data, nz, nr);

r  = subgeo(3,:);
dz = subgeo(4,:);
dr = subgeo(5,:);

nsub = size(subgeo,2);  % total number of subelements

% Compute the self-inductance of each individual subelement 

selfInd_subs = selfInd_smallrect(r, dr, dz);

% Compute the mutuals between all subelements

mutInd_subs = zeros(nsub,nsub);

for ii = 1:(nsub-1)
    
    z1  = subgeo(2,ii);
    r1  = subgeo(3,ii);
    dz1 = subgeo(4,ii);
    dr1 = subgeo(5,ii);
    
    for jj = (ii+1):nsub
        
        z2  = subgeo(2,jj);
        r2  = subgeo(3,jj);
        dz2 = subgeo(4,jj);
        dr2 = subgeo(5,jj);
        
        mutInd_subs(ii,jj) = m_rect2rect(r1, z1, dr1, dz1, ...
            r2, z2, dr2, dz2);
    end
end

mutInd_subs = mutInd_subs(:);

% Compute the total self-inductance of the coil

selfInd = sum(selfInd_subs) + 2*sum(mutInd_subs);
    
end
