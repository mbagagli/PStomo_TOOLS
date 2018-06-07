function [outMatrix,outSection,plotHandle,cbarHandle]=modelSection(modelPath,varargin)
%% MODELSECTION: plot a slice of the velocity model dir. E-W of the matrix-data
%   USAGE:  [matrix,SECTION]=modelSection(modelPath,varargin)
%   AUTHOR: Matteo Bagagli @ INGV.PI
%   DATE:   7/7/2016

%% Grep Parameter
Defaults=struct('PlotFunct',@imagesc, ...
    'x_km',[], ...
    'y_km',[], ...
    'z_km',[], ...
    'z0_km',[], ...
    'nx',[], ...
    'ny',[], ...
    'nz',[], ...
    'Section',[], ...
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
dz=(Args.z_km+abs(Args.z0_km))/Args.nz;
n_section=(Args.Section/dy)+1;  % piano's coordinate Y in nodes
% Axes
axes_x=0:dx:(Args.x_km-dx);         % defining x vector of the figure
axes_z=Args.z0_km:dz:(Args.z_km-dz);        % defining y vector of the figure
% Opening the file
outMatrix=modPStomo2mat(modelPath,Args.nx,Args.ny,Args.nz);

% =================================================== Load Receivers & EQs
if ~isempty(Args.Stations)
    STN=importdata(Args.Stations);
    x_r=(STN(:,2));
    y_r=(STN(:,3));
    z_r=(STN(:,4));
    
    ii=find(y_r<=(Args.Section+2) & y_r>=(Args.Section-2));
    x_r=x_r(ii);
    z_r=z_r(ii);    
end

if ~isempty(Args.Earthquakes)
    IPO=importdata(Args.Earthquakes);
    x_s=(IPO(:,5));
    y_s=(IPO(:,6));
    z_s=(IPO(:,7));
    
    ii=find(y_s<=(Args.Section+1) & y_s>=(Args.Section-1));
    x_s=x_s(ii);
    z_s=z_s(ii);
end

%% Plot
% Define section
outSection=zeros(Args.nx,Args.nz);
for i=1:Args.nx
    for k=1:Args.nz
        outSection(i,k)=outMatrix(i,n_section,k);
    end
end
% Coverage: load model and section
if Args.Coverage
    if ~isempty(Args.CoverageMod)
        covMod=modPStomo2mat(Args.CoverageMod,Args.nx,Args.ny,Args.nz);
        covModSect=zeros(Args.nx,Args.nz);
        for i=1:Args.nx
            for k=1:Args.nz
                covModSect(i,k)=covMod(i,n_section,k);
            end
        end
        GRAY=repmat(0.5,size(covModSect,1),size(covModSect,2)); % background color
        ALPHA=zeros(size(covModSect)); % The mask for coverage (1 clear, 0 opaque)
        for ii=1:size(covModSect,1)
            for jj=1:size(covModSect,2)
                if covModSect(ii,jj)>0 % if at least one ray cross the cell
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
% Plot
if isequal(Args.PlotFunct,@imagesc)
    if Args.Coverage
        colormap(gray);
        imagesc(axes_x,axes_z,GRAY'); %plot the background
        freezeColors
        hold on
    end
%     cptcmap(Args.ColorMap,'mapping','direct','ncol',200);
    axnow=gca;
    cptcmap(Args.ColorMap,axnow,'mapping','direct','ncol',200);  %new --> r2014b allows for multiple colormap
    plotHandle=imagesc(axes_x,axes_z,outSection');
    caxis(Args.Clim);
    axis ij  tight image;
    set(gca,'XAxisLocation','top');
    if Args.Coverage; set(plotHandle,'alphadata',ALPHA');end
    
elseif isequal(Args.PlotFunct,@pcolor)
    if Args.Coverage
        colormap(gray);
        pcolor(axes_x,axes_z,GRAY'); %plot the background
        freezeColors
        hold on
    end
%     cptcmap(Args.ColorMap,'mapping','direct','ncol',200);
    axnow=gca;
    cptcmap(Args.ColorMap,axnow,'mapping','direct','ncol',200);  %new --> r2014b allows for multiple colormap
    plotHandle=pcolor(axes_x,axes_z,outSection');
    caxis(Args.Clim);
    axis ij  tight image ;
    shading(gca,'interp');
    set(gca,'XAxisLocation','top');
    if Args.Coverage
        set(plotHandle,'alphadata',ALPHA', ...
            'facealpha','interp','edgecolor','none'); % if pcolor,'facealpha' MUST be interp
    end
elseif isequal(Args.PlotFunct,@contourf)
    if Args.Coverage
        disp('### modelSection: COVERAGE mode for contourf not yet implemented');
    end
    plotHandle=contourf(axes_x,axes_z,outSection');
    caxis(Args.Clim);
    axis ij  tight image;
    set(gca,'XAxisLocation','top');
else
    error('### modelSection: Invalid plotter function !!! [pcolor/imagesc/contourf]')
end
%
if Args.Colorbar; cbarHandle=colorbar('horizon'); else cbarHandle=[]; end
title(['LONGITUDINAL MODEL SECTION on Y (km) = ',num2str(Args.Section,'% 10.2f')]);
xlabel('offset X (km)');
ylabel('depth (km)');
% =================================================== Plot Receivers & EQs
if ~isempty(Args.Stations)
    hold on
    plot(x_r,z_r,'^k','MarkerSize',10,'Linewidth',2);
    hold off
end

if ~isempty(Args.Earthquakes)
    hold on
    plot(x_s,z_s,'ow','MarkerSize',2);
    hold off
end

%%% Update 05/2017
ylim([Args.z0_km Args.z_km-dz]); % hypocenters deeper than max depth NOT displayed

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
