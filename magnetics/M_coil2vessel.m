function M = M_coil2vessel(coil_data, nturns, vessel_data, vvnr, vvnz)
%
% M_COIL2VESSEL
%
%   Compute the mutual inductances between a set of coils and a set of 
%   passive conductors (such as vessel segments).
%
%   The conductor cross-sections are assumed to be represented by
%   parallelograms with geometry defined by the EFIT convention.
%
% USAGE:  M_coil2vessel.m
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
%   vessel_data...same format as coil_data
%   vvnr..........array containing number of radial subelements in each
%                     passive conductor 
%   vvnz..........array containing number of vertical subelements in each
%                     passive conductor
%
% OUTPUTS: 
%
%   M............mutual inductance matrix in units [H] with dimensions 
%                (ncoils) x (nvessel)
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

ncoils  = size(coil_data,2);
nvessel = size(vessel_data,2);

%.......................................
% Construct the mutual inductance matrix

M = zeros(ncoils,nvessel);

for ii = 1:ncoils
    for jj = 1:nvessel
        
        fprintf('Computing mutual between coil %d and vessel %d\n', ii, jj)
        
        M(ii,jj) = m_coil2vessel(coil_data(:,ii), nturns(ii), ...
            vessel_data(:,jj), vvnr(jj), vvnz(jj));
    end
end

end
