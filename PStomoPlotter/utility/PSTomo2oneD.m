function [OUT,oneD]=PSTomo2oneD(dataFile,nx,ny,nz,mode)
% PSTOMO2ONED: convert PSTomo vel model from 3D to 1D node profile
%   USAGE:     PSTomo2oneD(fileName,nx,ny,nz)
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

%% LOAD
M=modPStomo2mat(dataFile,nx,ny,nz);

%% CONVERT
oneD=[];
for zz=1:nz
    if strcmpi(mode,'all')
        % WEIGHTED FOR ALL NODES
        PlaneMean=mean(M(:,:,zz));
        oneD=[oneD,mean(PlaneMean)];
    else
        % LOG in middle of model
        PlaneMean=M(round(nx/2),round(ny/2),zz);
        oneD=[oneD,PlaneMean];
    end
end

%% LAYERING
depthVector=[-1,0,1,2,4,6,9,12,20,40];
OUT=[mean(oneD(1:3)),  % -1
    mean(oneD(3:5)),   %  0
    mean(oneD(5:7)),   %  1
    mean(oneD(7:11)),  %  2
    mean(oneD(11:15)), %  4
    mean(oneD(15:21)), %  6
    mean(oneD(21:27)), %  9
    mean([oneD(27:end),6.30]), %  12
    6.36,  %  20
    7.50   %  40
    ];
%
oneD=[[-1:0.5:13.5]',oneD'];
OUT=[depthVector',OUT];
    
%% PLOT
figure('Units','normalized','Position',[0. 0. 0.25 0.51])
stairs(oneD(:,1),oneD(:,2)); hold on; stairs(OUT(:,1),OUT(:,2));
view([-270 90]);
xlabel('Depth (km)');
ylabel('Velocities (km/s)')
grid on
set(gca,'yaxislocation','right')

%
end