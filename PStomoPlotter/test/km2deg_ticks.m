function [varargout]=km2deg_ticks(origin,direction,varargin)
%% KM2DEG_TICKS: converts ticksmark from km to decimal degree.
%   The function need:
%       - Origin[LON,LAT] of the low-left area corner
%       - direction : ['N','E','Z']
%   Optional:
%       - axis handle (gca called if missed)
%
%   USAGE: KM2DEG_TICKS(origin,direction,varargin)
%   AUTHORE: Matteo Bagagli @ ETH- Zurich 07/2017

%% Main
if nargin >=3 && ~isempty(varargin{1})
    axh=varargin{1};
else
    axh=gca();
end
%
radius=6378.137; % earth's radius km
switch direction
    case 'N'
        tickLabel=get(axh,'xticklabel');
        tickLabel=MyCellFun(@str2num,tickLabel);
        tickLabel=MyCellFun(@my_km2deg,tickLabel,radius);
        tickLabel=MyCellFun(@mysum,tickLabel,origin(2));
        tickLabel=MyCellFun(@num2str,tickLabel,4);
        set(axh,'xticklabel',tickLabel);
        xlabel('LON (DD)');
        varargout{1}=tickLabel;        
    case 'E'
        tickLabel=get(axh,'xticklabel');
        tickLabel=MyCellFun(@str2num,tickLabel);
        tickLabel=MyCellFun(@my_km2deg,tickLabel,radius);
        tickLabel=MyCellFun(@mysum,tickLabel,origin(1));
        tickLabel=MyCellFun(@num2str,tickLabel,4);
        set(axh,'xticklabel',tickLabel);
        xlabel('LON (DD)');
        varargout{1}=tickLabel;        
    case 'Z'
        tickLabel=get(axh,'xticklabel');
        tickLabel=MyCellFun(@str2num,tickLabel);
        tickLabel=MyCellFun(@my_km2deg,tickLabel,radius);
        tickLabel=MyCellFun(@mysum,tickLabel,origin(1));
        tickLabel=MyCellFun(@num2str,tickLabel,4);
        set(axh,'xticklabel',tickLabel);
        xlabel('LON (DD)');
        varargout{1}=tickLabel;
        %
        tickLabel=get(axh,'yticklabel');
        tickLabel=MyCellFun(@str2num,tickLabel);
        tickLabel=MyCellFun(@my_km2deg,tickLabel,radius);
        tickLabel=MyCellFun(@mysum,tickLabel,origin(2));
        tickLabel=MyCellFun(@num2str,tickLabel,4);
        set(axh,'yticklabel',tickLabel);
        ylabel('LAT (DD)');
        varargout{2}=tickLabel;
    otherwise
        error('### KM2DEG_TICKS: Wrond direction specified ... [''N'',''E'',''Z'']')
end

%% Nested Function
    function [OutCell]=MyCellFun(functHandle,InCell,varargin)
        % MYCELLFUN: brilliant turn-around to use userdefined function
        %   The works is similar to 'cellfun'. The handle MUST be
        %   specified in input with @ (e.g. @mean - @sum).
        %   The varargin array will be appended to the function-call
        %
        %   USAGE: [OutCell]=MyCellFun(functHandle,InCell,varargin)
        %   AUTHOR: Matteo BAGAGLI @ INGV.PI 03/2016
        
        % Work
        OutCell=cell(size(InCell));
        for xx=1:size(InCell,1)
            for yy=1:size(InCell,2)
                OutCell{xx,yy}=functHandle(InCell{xx,yy},varargin{:});
            end
        end
    end % End MyCellFun
%
    function [outkm]=my_km2deg(km,radius)
        % MY_KM2DEG: convert a value from km to decimal degree.
        %   The parameter radius is the length of the planet's radius 
        %
        %   USAGE: [OutValue]my_km2deg(value,radius)
        %   AUTHOR: Matteo Bagagli@ETH-Zurich
        
        % Work
        rad=km/radius;
        outkm=(180/pi)*rad;
    end % end my_km2deg
%
    function [out]=mysum(val1,val2)
        out=val1+val2;
    end
end % end MAIN