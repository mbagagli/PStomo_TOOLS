function [outMatrix]=modPStomo2mat(modelPath,nx,ny,nz)
%% MODPSTOMO2MAT: simple routine that convert's PStomo's binary mod to MATLAB
%   
%   USAGE:  [outMatrix]=modPStomo2mat(modelPath,nx,ny,nz)
%   AUTHOR: Matteo Bagagli @ INGV PI
%   DATE:   11/07/2016
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

%% Load 
nxy=nx*ny;
nxyz=nx*ny*nz;
fid=fopen(modelPath);
A=fread(fid,nxyz,'float');
fclose(fid);
% Convert to MATLAB format
% PStomo_eq index: m * nxy + l*nx + k;
outMatrix=zeros(nx,ny,nz);
for xx=1:nx
    for yy=1:ny
        for zz=1:nz
            index=((zz-1)*nxy + (yy-1)*nx + (xx-1)) + 1;
            outMatrix(xx,yy,zz)=A(index);
        end
    end
end
%
end
