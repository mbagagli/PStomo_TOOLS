%% Nested Functions
    function [covMatrix]=coverage2mask(modelPath)
        %% COVERAGE2MATRIX: create a mask to be applied to a precise plane of the model.
        %
        %   USAGE:  [covMatrix]=coverage2matrix(modelPath,plane,plotHandle)
        %   AUTHOR: Matteo Bagagli@ INGV.PI
        %   DATE:   11/07/2016
        %
        
        %% Load
        dx=x_km/nx;
        dy=y_km/ny;
        dz=(z_km-z0_km)/nz;
        n_slice=((Slice+abs(z0_km))/dz)+1;  % piano's coordinate Y in nodes
        % Axes
        axes_x=0:dx:(x_km-dx);         % defining x vector of the figure
        axes_y=0:dy:(y_km-dy);        % defining y vector of the figure
        % Opening the file
        nxy=nx*ny;
        nxyz=nx*ny*nz;
        fid=fopen(modelPath);
        A=fread(fid,nxyz,'float');
        fclose(fid);
        % Convert to MATLAB format
        % PStomo_eq index: m * nxy + l*nx + k;
        outMatrix=zeros(nx,ny,nz);
        for i = 1:nx
            for j = 1:ny
                for k = 1:nz
                    index=((k-1)*nxy + (j-1)*nx + (i-1) ) +1;
                    outMatrix(i,j,k)=A(index);
                end
            end
        end
        
        %% Work

        
    end