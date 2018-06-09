function [VELm0_P,VELm0_S]=vel1d(path_Vp,path_Vs,varargin)
%% VEL1D: function to plot velocity profile 1D of starting models.
%   output : matrix containing the coordinates "depth,velocity"
%   input  : - paths of the PStomo vel1d.par files
%            - Plot Mode: vector of subplot [1 1 1] 
%                         'standalone' (create a new figure)
%
%   USAGE:  [VELm0_P,VELm0_S]=vel1d(path_Vp,path_Vs,Plot Mode)
%   AUTHOR: Matteo Bagagli @ INGV.PI
%   DATE:   7/7/2016
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

%% Get Data

% P model
A=textread(path_Vp,'%s','delimiter','\n');
string=char(A(6));
nodes=str2num(string(1:3));     % number of lines to be read
VELm0_P=zeros(nodes,2);         % memory pre-allocation
for i=1:nodes
    getpar=char(A(6+i));
    VELm0_P(i,:)=str2num(getpar);
end

% S model
B=textread(path_Vs,'%s','delimiter','\n');
string=char(B(6));
nodes_S=str2num(string(1:3));

VELm0_S=zeros(nodes_S,2);
for i=1:nodes_S
    getpar_S=char(B(6+i));
    VELm0_S(i,:)=str2num(getpar_S);
end

%% Plot
if length(varargin)==1        
    if strcmp(varargin{1},'standalone')
        figure('Name','PStomoPlotter: vel1d profiles')
    elseif isnumeric(varargin{1})
        gcf
        subplot(vect_subplot(1),vect_subplot(2),vect_subplot(3));
    else
        gcf
        subplot(1,1,1)
    end
end

plot(VELm0_P(:,2),VELm0_P(:,1),'b',VELm0_S(:,2),VELm0_S(:,1),'r')

%% Vp/Vs
if length(VELm0_P) == length(VELm0_S) & VELm0_P(:,1)==VELm0_S(:,1)
    VP_VS=zeros(length(VELm0_P),2);
    for i=1:length(VELm0_P)
        VP_VS(i,1)=((VELm0_P(i,1))+(VELm0_S(i,1)))/2;
        VP_VS(i,2)=(VELm0_P(i,2))/(VELm0_S(i,2));
    end
hold on
plot(VP_VS(:,2),VP_VS(:,1),'-.g')
hold off
end

%% Set Plot
plt_dim=[(min(VELm0_P(:,2))-3.5) (max(VELm0_P(:,2)+0.5)) min(VELm0_P(:,1)) max(VELm0_P(:,1))];
axis([plt_dim(1) plt_dim(2) plt_dim(3) plt_dim(4)]);

% orientation
set(gca,'XAxisLocation','top');
set(gca,'YDir','reverse');
% spacing
set(gca,'XTick',[plt_dim(1):0.5:plt_dim(2)]);
set(gca,'YTick',[plt_dim(3):1:plt_dim(4)]);
grid on;

title(['VEL1D PROFILE on m_0']);
xlabel('Velocities (km/s)');
ylabel('depth (Km)');

legend('Vp','Vs','Vp/Vs');
end


