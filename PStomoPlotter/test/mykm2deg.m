function [outkm]=mykm2deg(km,varargin)
%% MY_KM2DEG: convert a value from km to decimal degree.
%   The parameter radius is the length of the planet's radius
%
%   USAGE: [OutValue]my_km2deg(value,radius)
%   AUTHOR: Matteo Bagagli@ETH-Zurich

%% Work
if nargin >=2 && ~isempty(varargin{1})
    radius=varargin{1};
else
    radius=6371; % km earth's radiuse
end
%
rad=km/radius;
outkm=(180/pi)*rad;
end % end my_km2deg

