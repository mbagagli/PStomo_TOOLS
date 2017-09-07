function [ArgsOut]=parseArgs(Defaults,InputArgs)
%% PARSEARGS : Utility function for parsing Name-Values inputs
%   A simple function that allows the user to set the "varargin" variable
%   of a personal function, in the classical MATLAB form Name-Value pair.
%   The function compares the line input command, with a default given one,
%   and returns a structure array. If a field given in default's array is
%   not present in the input one, the default value for that field is used.
%   Obiouvsly the order is not important, but the function is NOT case sensitive !!
%
%   USAGE: [ArgsOut]=PARSEARGS(Defaults,InputArgs)
%
%   INPUT:
%           Defaults  --->  A structure array with the field's names
%                           and the respective DEFAULT VALUE [char/real]
%           InputArgs --->  The cell array typical of the user input
%                           varargin funcion
%   OUTPUT:
%           ArgsOut   --->  A structure array containing the final values.
%
%   AUTHOR: Matteo Bagagli @ INGV.PI
%   DATE:   03/2015

%% Work
DefaultsFields=fieldnames(Defaults);
InputFields=InputArgs(1:2:end);
% ---- Checking Errors -----
for ii=1:length(InputFields)
    if ~ischar(InputFields{ii})
        error(sprintf(['parseArgs: ERROR inserting values.','\n', ...
            'Fieldtypes must be character !!!']));
    end
end
if mod(length(InputArgs),2) ~= 0
    error(sprintf(['parseArgs: ERROR inserting values.','\n', ...
        'Missing fieldtype or value !!!']));
end
% --------------------------
for ii=1:length(DefaultsFields)
    val = DefaultsFields{ii};
    test=strcmpi(val,InputFields);       % case or non-case sensitive
    if ~isempty(find(test == 1, 1))      % Searching for values
        index=find(test == 1);
        ArgsOut.(val)=InputArgs{index*2};
    else                                 % Using Default instead
        ArgsOut.(val)=Defaults.(val);
    end
    
end
%
end