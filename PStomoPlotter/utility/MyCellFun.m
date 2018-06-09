function [OutCell]=MyCellFun(functHandle,InCell,varargin)
% MYCELLFUN: brilliant turn-around to use userdefined function 
%   The works is similar to 'cellfun'. The handle MUST be 
%   specified in input with @ (e.g. @mean - @sum).
%   The varargin array will be appended to the function-call
%
%   USAGE: [OutCell]=MyCellFun(functHandle,InCell,varargin)
%
%   AUTHOR: Matteo BAGAGLI @ INGV.PI 03/2016

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

%% Work
OutCell=cell(size(InCell));
for xx=1:size(InCell,1)
    for yy=1:size(InCell,2)
        OutCell{xx,yy}=functHandle(InCell{xx,yy},varargin{:});
    end
end
%
end % End Main