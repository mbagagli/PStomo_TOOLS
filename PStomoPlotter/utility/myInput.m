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
