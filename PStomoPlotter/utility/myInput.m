function [varargout]=myInput(varargin)
%% MYINPUT: simple inputdlg utility. (GUI)
%   INPUT:  cell containing string titles, and output
%           specifier. Possible output  as string or float ['str'/'float'],
%           to be specified!
%           A default can be appended in the THIRD position.
%   OUTPUT: ordered output.
%
%   USAGE: [name,age]=myInput({'Name',['str'[,'defaultVal']]}, ... );
%   AUTHOR: Matteo Bagagli @ INGV.PI
%

%    PStomo_TOOLS: plot routines for seismic tomography
%    Copyright (C) 2018  Matteo Bagagli
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% ================================================= Work
% Foundamental use of cellfun
if nargout~=nargin || nargout==0
    error('### myInput: ERROR !!! Inputs & Output must be of the same length...')
end
%
Inputs=cell(length(varargin),1);
Outputs=cell(length(varargin),1);
Defaults=cell(length(varargin),1);
for xx=1:length(varargin)
    vector=varargin{xx};
    Inputs(xx)=vector(1);
    %
    if length(vector)>=2
        Outputs(xx)=vector(2);
    end
    %
    if length(vector)==3
        Defaults(xx)=vector(3);
    else
        Defaults{xx}='';
    end
end
%
OutCell=inputdlg(Inputs,'INPUT',1,Defaults);
% Canc button
if isempty(OutCell); 
    varargout(1:nargout)={[]};
    return 
end
%
for xx=1:length(OutCell)
    if strcmp(Outputs(xx),'float')
        varargout(xx)=cellfun(@str2num,OutCell(xx),'UniformOutput',0);
    else
        varargout(xx)=OutCell(xx);
    end
end
