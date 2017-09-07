function [outMatrix,outSlice,plotHandle,cbarHandle]=modelDepthSlice(modelPath,varargin)

%% Grep Parameter
Defaults=struct('PlotFunct',@imagesc, ...
    'x_km',[], ...
    'y_km',[], ...
    'z_km',[], ...
    'z0_km',[], ...
    'nx',[], ...
    'ny',[], ...
    'nz',[], ...
    'Slice',[], ...
    'Clim',[], ...
    'Stations',[], ...
    'Earthquakes',[], ...
    'Colorbar',0, ...
    'Coverage',0, ...
    'CoverageMod',[], ...
    'ColorMap','GMT_seis.cpt'); % must be taken from the package GMT colorpalette
Args=parseArgs(Defaults,varargin);

%% Load
dx=Args.x_km/Args.nx;
dy=Args.y_km/Args.ny;
dz=(Args.z_km-Args.z0_km)/Args.nz;
n_slice=((Args.Slice+abs(Args.z0_km))/dz)+1;  % piano's coordinate Y in nodes
% Axes
axes_x=0:dx:(Args.x_km-dx);                   % defining x vector of the figure
axes_y=0:dy:(Args.y_km-dy);                   % defining y vector of the figure
% Opening the file
outMatrix=modPStomo2mat(modelPath,Args.nx,Args.ny,Args.nz);

% =================================================== Load Receivers & EQs
if ~isempty(Args.Stations)
    STN=importdata(Args.Stations);
    x_r=(STN(:,2));
    y_r=(STN(:,3));
    %z_r=(STN(:,4)); --> unused here
end

if ~isempty(Args.Earthquakes)
    IPO=importdata(Args.Earthquakes);
    x_s=(IPO(:,5));
    y_s=(IPO(:,6));
    z_s=(IPO(:,7));
    
    ii=find(z_s<=(Args.Slice+1) & z_s>=(Args.Slice-1));
    x_s=x_s(ii);
    y_s=y_s(ii);
end

%% Plot
% Define slice
outSlice=zeros(Args.nx,Args.ny);
for i=1:Args.nx
    for k=1:Args.ny
        outSlice(i,k)=outMatrix(i,k,n_slice);
    end
end
% Coverage: load model and section
if Args.Coverage
    if ~isempty(Args.CoverageMod)
        covMod=modPStomo2mat(Args.CoverageMod,Args.nx,Args.ny,Args.nz);
        covModSlice=zeros(Args.nx,Args.nz);
        for i=1:Args.nx
            for k=1:Args.ny
                covModSlice(i,k)=covMod(i,k,n_slice);
            end
        end
        GRAY=repmat(0.5,size(covModSlice,1),size(covModSlice,2)); % background color
        ALPHA=zeros(size(covModSlice)); % The mask for coverage (1 clear, 0 opaque)
        for ii=1:size(covModSlice,1)
            for jj=1:size(covModSlice,2)
                if covModSlice(ii,jj)>0 % if at least one ray cross the cell
                    ALPHA(ii,jj)=1;
                else
                    ALPHA(ii,jj)=0;
                end
            end
        end
    else
        error('### modelSection: Missing coverage model !!!')
    end
end
%
if isequal(Args.PlotFunct,@imagesc)
    if Args.Coverage
        colormap(gray);
        imagesc(axes_x,axes_y,GRAY'); %plot the background
        freezeColors
        hold on
    end    
    cptcmap(Args.ColorMap,'mapping','direct','ncol',200);
    plotHandle=imagesc(axes_x,axes_y,outSlice');
    caxis(Args.Clim);
    axis xy tight image;
    set(gca,'XAxisLocation','bottom');
    if Args.Coverage; set(plotHandle,'alphadata',ALPHA');end    
    
elseif isequal(Args.PlotFunct,@pcolor)
    if Args.Coverage
        colormap(gray);
        pcolor(axes_x,axes_y,GRAY'); %plot the background
        freezeColors
        hold on
    end    
    cptcmap(Args.ColorMap,'mapping','direct','ncol',200);
    plotHandle=pcolor(axes_x,axes_y,outSlice');
    caxis(Args.Clim);
    axis xy tight image ;
    shading(gca,'interp');
    set(gca,'XAxisLocation','bottom');
    if Args.Coverage
        set(plotHandle,'alphadata',ALPHA', ...
            'facealpha','flat','edgecolor','none');
    end
    
elseif isequal(Args.PlotFunct,@contourf)
    if Args.Coverage
        disp('### modelDepthSlice: COVERAGE mode for contourf not yet implemented');
    end    
    plotHandle=contourf(axes_x,axes_y,outSlice');
    caxis(Args.Clim);
    axis xy tight image;
    set(gca,'XAxisLocation','bottom');
else
    error('### modelSection: Invalid plotter function !!! [pcolor/imagesc/contourf]')
end
%
if Args.Colorbar; cbarHandle=colorbar('horiz'); else cbarHandle=[]; end
title(['DEPTH SLICE on Z (km) = ',num2str(Args.Slice,'% 10.2f')]);
xlabel('offset X (km)');
ylabel('offset Y (km)');
% =================================================== Plot Receivers & EQs
if ~isempty(Args.Stations)
    hold on
    plot(x_r,y_r,'^k','MarkerSize',10,'Linewidth',2);
    hold off
end

if ~isempty(Args.Earthquakes)
    hold on
    plot(x_s,y_s,'ow','MarkerSize',2);
    hold off
end

%% Nested Functions
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
        for xx = 1:nx
            for yy = 1:ny
                for zz = 1:nz
                    index=((zz-1)*nxy + (yy-1)*nx + (xx-1)) + 1;
                    outMatrix(xx,yy,zz)=A(index);
                end
            end
        end
    end
%
end % End Main