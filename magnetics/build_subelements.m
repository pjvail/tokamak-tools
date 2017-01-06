function subgeo = build_subelements(cond_data, nz, nr)
%
% BUILD_SUBELEMENTS 
%
%   Split conductor(s) into rectangular subelements, which can then be used
%   for magnetics calculations.
%
%   The conductor cross-sections are assumed to be represented by 
%   parallelograms with geometry defined by the EFIT convention.
%
% USAGE: build_subelements.m
%
% INPUTS:
%
%   cond_data...matrix with dimensions 6 x number of conductors. The rows
%               are arranged as follows: [z; r; dz; dr; ac; ac2] where
%                   z:   vertical position of conductor center(s)  [m]
%                   r:   major radii of conductor center(s)        [m]
%                   dz:  full height of the conductor(s)           [m]
%                   dr:  full width of the conductors(s)           [m]
%                   ac:  counterclockwise rotation (angled bottom) [deg]
%                   ac2: counterclockwise rotation (flat bottom)   [deg]
%   nz..........array containing number of vertical subelements in each
%               conductor
%   nr..........array containing number of radial subelements in each
%               conductor
%
% OUTPUTS: 
%
%   subgeo.....matrix with dimensions 5 x number of subelements (for the
%              whole set of conductors in the set cond_data). The rows are
%              arranged as follows: [num; z; r; dz; dr] where
%                  num: conductor numbers to which each subelement belongs
%                  z:   vertical positions of subelement centers [m]
%                  r:   major radii of subelement centers        [m]
%                  dz:  full height of the subelements           [m]
%                  dr:  full width of the subelements            [m]
%
% AUTHOR: Patrick J. Vail
%
% DATE: 08/23/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 08/23/2016
%
%..........................................................................
        
% Unpack cond_data
Z   = cond_data(1,:);
R   = cond_data(2,:);
dZ  = cond_data(3,:);
dR  = cond_data(4,:);
ac  = cond_data(5,:); 
ac2 = cond_data(6,:); 

% Convert angles to radians
ac  = ac * pi/180;
ac2 = ac2 * pi/180;

% Number of conductors
nconductors = size(cond_data,2);

% Compute total number of subelements
nsub = sum(nz.*nr);

% Pre-allocate matrix in which to store subelement geometry data
subgeo = zeros(5,nsub);

idx = 0;

for ii = 1:nconductors
    
    nsubZ = nz(ii); % number of subelements in Z direction
    nsubR = nr(ii); % number of subelements in R direction
    
    nsubtot = nsubZ*nsubR;  % subelement total for conductor ii
    
    dz = dZ(ii)/nz(ii); % height of subelement for conductor ii
    dr = dR(ii)/nr(ii); % width  of subelement for conductor ii
    
    % square conductor cross-section
    if ac(ii) == 0 && ac2(ii) == 0 
        
        Ztopleft = Z(ii) + dZ(ii)/2; % z coordinate of top left vertex
        Rtopleft = R(ii) - dR(ii)/2; % r coordinate of top left vertex
        
        z = (Ztopleft - dz/2) - dz*(0:nsubZ-1);
        r = (Rtopleft + dr/2) + dr*(0:nsubR-1);
        
        [z2, r2] = meshgrid(z,r);
        
        z2 = reshape(z2, [1,nsubtot]);
        r2 = reshape(r2, [1,nsubtot]);
        
    end
    
    % the conductor has an angled bottom
    if ac(ii) ~= 0 && ac2(ii) == 0
        
        zc1 = Z(ii) - dZ(ii)/2 - dR(ii)*tan(ac(ii))/2; % corner 1 z-coord.
        rc1 = R(ii) - dR(ii)/2;                        % corner 1 r-coord.
        
        r = dr/2 + dr*(0:nsubR-1);
        z = tan(ac(ii))*r;
        
        % (r,z) of subelement centers
        r = rc1 + r;
        z = zc1 + z;
        
        % now offset the z-coordinates along edge of region
        z_offsets = dz/2 + dz*(0:nsubZ-1);
        
        z2 = zeros(1,nsubtot);
        for jj = 1:nsubZ
            idx2 = (1:nsubR) + (jj-1)*nsubR;
            z2(idx2) = z + z_offsets(jj);
        end
        
        r2 = repmat(r,1,nsubZ);
    
    end
    
    % the conductor has a flat bottom
    if ac(ii) == 0 && ac2(ii) ~= 0
        
        zc1 = Z(ii) - dZ(ii)/2;                         % corner 1 z-coord.
        rc1 = R(ii) - dR(ii)/2 - dZ(ii)/tan(ac2(ii))/2; % corner 1 r-coord.
        
        z = dz/2 + dz*(0:nsubZ-1);
        r = z/tan(ac2(ii));
        
        % (r,z) of subelement centers
        r = rc1 + r;
        z = zc1 + z;
        
        % now offset the r-coordinates along the edge of region
        r_offsets = dr/2 + dr*(0:nr-1);
        
        r2 = zeros(1,nsubtot);
        for jj = 1:nsubR
            idx2 = (1:nsubZ) + (jj-1)*nsubZ;
            r2(idx2) = r + r_offsets(jj);
        end
        
        z2 = repmat(z,1,nsubR);
        
    end
    
    subgeo(1, (1:nsubtot) + idx) = ii;
    subgeo(2, (1:nsubtot) + idx) = z2;
    subgeo(3, (1:nsubtot) + idx) = r2;
    subgeo(4, (1:nsubtot) + idx) = dz;
    subgeo(5, (1:nsubtot) + idx) = dr;
    
    idx = idx + nsubtot;
                  
end
    