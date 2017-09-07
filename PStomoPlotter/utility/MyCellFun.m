function [OutCell]=MyCellFun(functHandle,InCell,varargin)
% MYCELLFUN: brilliant turn-around to use userdefined function 
%   The works is similar to 'cellfun'. The handle MUST be 
%   specified in input with @ (e.g. @mean - @sum).
%   The varargin array will be appended to the function-call
%
%   USAGE: [OutCell]=MyCellFun(functHandle,InCell,varargin)
%
%   AUTHOR: Matteo BAGAGLI @ INGV.PI 03/2016

%% Work
OutCell=cell(size(InCell));
for xx=1:size(InCell,1)
    for yy=1:size(InCell,2)
        OutCell{xx,yy}=functHandle(InCell{xx,yy},varargin{:});
    end
end
%
end % End Main