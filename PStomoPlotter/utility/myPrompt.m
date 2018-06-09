function [R] = myPrompt(St,D)
%% MYPROMPT: custom single Input Dialogue
%   Simple window where user can input a char command.
%
%   USAGE:  result=MYPROMPT(St,D)
%   AUTHOR: Matteo Bagagli @ INGV.PI
%   DATE:   03/2014
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

%% Built-Widget
if nargin<2  % Default values if called without args.
    D = '';
elseif nargin<1
    St = 'myinput';
end

if ~ischar(D)
    D = num2str(D);
end

R =[];  % In case the user closes the GUI.
S.fh = figure('Units','normalized',...
    'position',[0.02 0 0.12 0.085],...
    'menubar','none',...
    'numbertitle','off',...
    'name',St,...
    'resize','off');
S.ed = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.10 0.60 0.80 0.30],...
    'string',D);
S.pb = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.10 0.20 0.80 0.30],...
    'string','Push to Return Data',...
    'callback',{@pb_call});
set(S.ed,'call',@ed_call)
uicontrol(S.ed)  % Make the editbox active.
uiwait(S.fh)     % Prevent all other processes from starting until closed.

%% Nested Functions
    function [] = pb_call(varargin)
        R = get(S.ed,'string');
        close(S.fh);  % Closes the GUI, allows the new R to be returned.
    end
%
    function [] = ed_call(varargin)
        uicontrol(S.pb)
        drawnow
        R = get(S.ed,'string');
        close(gcbf)
    end
%
end % End Main