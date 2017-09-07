function [outMatrix]=modPStomo2mat(modelPath,nx,ny,nz)
%% MODPSTOMO2MAT: simple routine that convert's PStomo's binary mod to MATLAB
%   
%   USAGE:  [outMatrix]=modPStomo2mat(modelPath,nx,ny,nz)
%   AUTHOR: Matteo Bagagli @ INGV PI
%   DATE:   11/07/2016
%

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
