function K = K_nagaoka(r, dz)
%
% K_NAGAOKA
%
%   Compute Nagaoka's K-factor, a quantity which is used in the calculation 
%   of the self-inductance of a cylindrical current sheet or cylindrical 
%   single-layer coil.
%
%   The K-factor is found via interpolation using a set of tabulated values
%   for the K-factor at various values of cylinder aspect ratio defined as
%   AR = length / diameter.
%
%   Warning: The data below is applicable only for short coils with AR < 1.
%
%   Tabulated data from: Grover. Inductance Calculations: Working Formulas
%                        and Tables. Dover, 1973. Page 144, Table 36.
%
% USAGE: K_nagaoka.m
%
% INPUTS:
%
%   r.........cylinder radius (array of length n)
%   dz........cylinder length (array of length n)
%
%   r and dz must have the same (arbitrary) units.
%
% OUTPUTS: 
%
%   K......Nagaoka's K-factor (array of length n)
%
% AUTHOR: Patrick J. Vail
%
% DATE: 09/13/2016
%
% MODIFICATION HISTORY:
%   Patrick J. Vail: Original File 09/13/2016
%
%.........................................................................

% Compute the aspect ratio(s)

AR = dz./(2*r);

% Warn the user if AR > 1

ARtoobig = find(AR>1,1);

if ~isempty(ARtoobig)
    disp(['WARNING K_nagaoka: a conductor aspect ratio is outside the ' ...
        'range of tabulated data'])
end

% Tabulated AR values

AR_tabulated = 0:0.01:1.00;

% K-factor values corresponding to each tabulated AR value

K1 = [0.000000 0.034960 0.061098 0.083907 0.104562 0.123615 0.141395 ...
      0.158119 0.173942 0.188980 0.203324 0.217044 0.230200 0.242842 ...
      0.255011 0.266744 0.278070 0.289019 0.299614 0.309876 0.319825 ...
      0.329479 0.338852 0.347960 0.356816 0.365432 0.373818 0.381986 ...
      0.389944 0.397703 0.405269 0.412650 0.419856 0.426890 0.433762 ...
      0.440474 0.447036 0.453450 0.459724 0.465860 0.471865 0.477742 ...
      0.483496 0.489129 0.494646 0.500052 0.505348 0.510539 0.515628 ...
      0.520617 0.525510];
           
K2 = [0.530310 0.535018 0.539637 0.544170 0.548620 0.552988 0.557278 ...
      0.561491 0.565628 0.569691 0.573683 0.577606 0.581462 0.585252 ...
      0.588976 0.592638 0.596239 0.599780 0.603263 0.606689 0.610060 ...
      0.613376 0.616639 0.619850 0.623011 0.626122 0.629185 0.632200 ...
      0.635170 0.638094 0.640974 0.643811 0.646605 0.649358 0.652070 ...
      0.654743 0.657376 0.659972 0.662532 0.665054 0.667540 0.669991 ...
      0.672408 0.674792 0.677142 0.679460 0.681747 0.684003 0.686228 ...
      0.688423];
  
K_tabulated = [K1 K2];
           
% Interpolate to find K-factor(s) at desired aspect ratio(s)

K = interp1(AR_tabulated, K_tabulated, AR, 'spline');

end
