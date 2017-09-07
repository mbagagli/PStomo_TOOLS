function [PStomoFig]=PStomoPlotter(varargin)
%% PSTOMOPLOTTER: shows a results-figure of "PStomo_eq"run.
%   Arrange a figure complete of different models defined by user.
%   and give the possibility to navigate the matrix plotted.
%
%   The input parameter can be put in the classical MATLAB pair name-value
%   format. The parameter's list and the respective defaults can be seen in
%   the first lines of the function.
%   'PlotMode' serves to state which model to be shown:
%       MODE 1: Vp
%       MODE 2: Vs
%       MODE 3: Vaux
%       MODE 4: Vp + Vs model
%       MODE 5: Vp + Vaux (e.g. Vp/Vs model)
%       MODE 6: Vs + Vaux (e.g. Vp/Vs model)
%
%   USAGE:  PStomoPlotter(varargin)
%   AUTHOR: Matteo Bagagli @ INGV.PI
%   DATE:   2016/2017
%

%% Grep Input
Defaults=struct('PlotMode',1, ...
    'VpModel',[], ...
    'VsModel',[], ...
    'VauxModel',[], ...
    'PlotFunct',@pcolor, ...
    'PlotEQ',0, ...
    'IpoOld',[], ...
    'IpoNew',[], ...
    'PlotStations',0, ...
    'Stations',[], ...
    'Coverage',0, ...
    'CoveragePModel',[], ...
    'CoverageSModel',[], ...
    'CoverageAuxModel',[], ...
    'InitVelProfile',0, ...
    'VelpFile',[], ...
    'VelsFile',[], ...
    'x_km',[], ...
    'y_km',[], ...
    'z_km',[], ...
    'z0_km',[], ...
    'nx',[], ...
    'ny',[], ...
    'nz',[], ...
    'ClimVp',[3 6] , ...
    'ClimVs',[2 5], ...
    'ClimVaux',[1.6 1.8], ...
    'MapVpVs','GMT_seis.cpt', ... % must be from the package GMT colorpalette
    'MapVaux','GMT_polar.cpt', ... % must be from the package GMT colorpalette    
    'StandAlone',0, ...
    'Navigator',0);
MainArgs=parseArgs(Defaults,varargin);
MainArgs=dataSetter(MainArgs);
% Define models and plot parameters
climCell={MainArgs.ClimVp, ...              % PlotMode 1
    MainArgs.ClimVs,...                     % PlotMode 2
    MainArgs.ClimVaux,...                   % PlotMode 3
    {MainArgs.ClimVp,MainArgs.ClimVs},...   % PlotMode 4
    {MainArgs.ClimVp,MainArgs.ClimVaux},... % PlotMode 5
    {MainArgs.ClimVs,MainArgs.ClimVaux}};   % PlotMode 6

mapCell={MainArgs.MapVpVs, ...                  % PlotMode 1
    MainArgs.MapVpVs,...                        % PlotMode 2
    MainArgs.MapVpVs,...                        % PlotMode 3
    {MainArgs.MapVpVs,MainArgs.MapVpVs},...     % PlotMode 4
    {MainArgs.MapVpVs,MainArgs.MapVaux},...     % PlotMode 5
    {MainArgs.MapVpVs,MainArgs.MapVaux}};       % PlotMode 6

switch MainArgs.PlotMode
    case 1
        model1Path=MainArgs.VpModel;
        coverage1Path=MainArgs.CoveragePModel;
    case 2
        model1Path=MainArgs.VsModel;
        coverage1Path=MainArgs.CoverageSModel;
    case 3
        model1Path=MainArgs.VauxModel;
        coverage1Path=MainArgs.CoverageAuxModel;
    case 4
        model1Path=MainArgs.VpModel;
        model2Path=MainArgs.VsModel;
        coverage1Path=MainArgs.CoveragePModel;
        coverage2Path=MainArgs.CoverageSModel;
    case 5
        model1Path=MainArgs.VpModel;
        model2Path=MainArgs.VauxModel;
        coverage1Path=MainArgs.CoveragePModel;
        coverage2Path=MainArgs.CoverageAuxModel;        
    case 6
        model1Path=MainArgs.VsModel;
        model2Path=MainArgs.VauxModel;
        coverage1Path=MainArgs.CoverageSModel;
        coverage2Path=MainArgs.CoverageAuxModel;        
end

%% Work - Loop infinito
% Vel1D-M0 ---> always in stand alone in new figure
if MainArgs.InitVelProfile
    [~,~]=vel1d(MainArgs.VelpFile,MainArgs.VelsFile,'standalone');
end
% Setting starting SLICE and SECTION
dx=MainArgs.x_km/MainArgs.nx;
dy=MainArgs.y_km/MainArgs.ny;
dz=(MainArgs.z_km-MainArgs.z0_km)/MainArgs.nz;
section=round(MainArgs.y_km/2);
slice=round(MainArgs.z_km/3);
        % Ipocenters --> to start I plot the final seismicity
        if MainArgs.PlotEQ
            ipocenters=MainArgs.IpoNew;
        else
            ipocenters=[];
        end
        % Station
        if MainArgs.PlotStations
            stations=MainArgs.Stations;
        else
            stations=[];
        end
% Create Main Figure
if ~(MainArgs.StandAlone)
    InvDir=strsplit(model1Path,'/');
    fig_title=['PStomo_eqPlotter: MODE - ', ...
        num2str(MainArgs.PlotMode),' INV.DIR - ', ...
        InvDir{end-2},'/',InvDir{end-1}];
    PStomoFig=figure('Units','normalized','Name',fig_title,'NumberTitle','off', ...
        'Position',[0 0 1 1],'Color',[0.95 0.95 0.95]);
    % =================================================================== Loop Mode
    while 1
        % Shrinking problem subplot 
        % https://it.mathworks.com/matlabcentral/newsreader/view_thread/310494
        
        % Switch Plot-Mode
        switch MainArgs.PlotMode
            case {1,2,3}
                h1=subplot(2,1,2);      % Save the handle of the subplot
                ax1=get(h1,'position'); % Save the position as ax
                set(h1,'position',ax1); % Manually setting this holds the position with colorbar
                subplot(2,1,1)
                modelSection(model1Path,'PlotFunct',MainArgs.PlotFunct, ...
                    'x_km',MainArgs.x_km,'y_km',MainArgs.y_km,'z_km',MainArgs.z_km, ...
                    'z0_km',MainArgs.z0_km,'nx',MainArgs.nx,'ny',MainArgs.ny, ...
                    'nz',MainArgs.nz,'Section',section,'Clim',climCell{MainArgs.PlotMode}, ...
                    'Stations',stations,'Earthquakes',ipocenters, ...
                    'Coverage',MainArgs.Coverage,'CoverageMod',coverage1Path, ...
                    'ColorMap',mapCell{MainArgs.PlotMode});
                if MainArgs.Navigator
                    VER=version;
                    hold on
                    if str2num(VER(1:3)) >= 9.0;
                        hline(slice,'r');
                    else
                        hNav = graph2d.constantline(slice, 'Color','r');
                        changedependvar(hNav,'y'); % change 'y' with 'x' for vertical line
                    end
                    hold off
                end
                
                h2=subplot(2,1,2);
                ax2=get(h2,'position');
                set(h2,'position',ax2);
                subplot(2,1,2)
                [~,~,~,hcb]=modelDepthSlice(model1Path,'PlotFunct',MainArgs.PlotFunct, ...
                    'x_km',MainArgs.x_km,'y_km',MainArgs.y_km,'z_km',MainArgs.z_km, ...
                    'z0_km',MainArgs.z0_km,'nx',MainArgs.nx,'ny',MainArgs.ny, ...
                    'nz',MainArgs.nz,'Slice',slice,'Clim',climCell{MainArgs.PlotMode}, ...
                    'Stations',stations,'Earthquakes',ipocenters,'Colorbar',1, ...
                    'Coverage',MainArgs.Coverage,'CoverageMod',coverage1Path, ...
                    'ColorMap',mapCell{MainArgs.PlotMode});
                set(hcb,'Units','Normalized', ...
                    'Position',[.4 .522 .4 .018],'FontSize',8);
                if MainArgs.Navigator
                    VER=version;
                    hold on
                    if str2num(VER(1:3)) >= 9.0;
                        hline(section,'r');
                    else
                        hNav = graph2d.constantline(section, 'Color','r');
                        changedependvar(hNav,'y'); % change 'y' with 'x' for vertical line
                    end
                    hold off
                end
                
            case {4,5,6}
                h1=subplot(2,2,1);
                ax1=get(h1,'position');
                set(h1,'position',ax1);
                subplot(2,2,1)
                modelSection(model1Path,'PlotFunct',MainArgs.PlotFunct, ...
                    'x_km',MainArgs.x_km,'y_km',MainArgs.y_km,'z_km',MainArgs.z_km, ...
                    'z0_km',MainArgs.z0_km,'nx',MainArgs.nx,'ny',MainArgs.ny, ...
                    'nz',MainArgs.nz,'Section',section,'Clim',climCell{MainArgs.PlotMode}{1}, ...
                    'Stations',stations,'Earthquakes',ipocenters, ...
                    'Coverage',MainArgs.Coverage,'CoverageMod',coverage1Path, ...
                    'ColorMap',mapCell{MainArgs.PlotMode}{1});
                if any(MainArgs.PlotMode==[5,6]) || MainArgs.Coverage; freezeColors; end
                if MainArgs.Navigator
                    VER=version;
                    hold on
                    if str2num(VER(1:3)) >= 9.0;
                        hline(slice,'r');
                    else
                        hNav = graph2d.constantline(slice, 'Color','r');
                        changedependvar(hNav,'y'); % change 'y' with 'x' for vertical line
                    end
                    hold off
                end
                                
                h2=subplot(2,2,3);
                ax2=get(h2,'position');
                set(h2,'position',ax2);
                subplot(2,2,3)
                [~,~,~,hcb1]=modelDepthSlice(model1Path,'PlotFunct',MainArgs.PlotFunct, ...
                    'x_km',MainArgs.x_km,'y_km',MainArgs.y_km,'z_km',MainArgs.z_km, ...
                    'z0_km',MainArgs.z0_km,'nx',MainArgs.nx,'ny',MainArgs.ny, ...
                    'nz',MainArgs.nz,'Slice',slice,'Clim',climCell{MainArgs.PlotMode}{1}, ...
                    'Stations',stations,'Earthquakes',ipocenters,'Colorbar',1, ...
                    'Coverage',MainArgs.Coverage,'CoverageMod',coverage1Path, ...
                    'ColorMap',mapCell{MainArgs.PlotMode}{1});
                set(hcb1,'Units','Normalized', ...
                    'Position',[.128 .522 .337 .018],'FontSize',8);
                if any(MainArgs.PlotMode==[5,6]) || MainArgs.Coverage; freezeColors,cbfreeze(hcb1); end
                if MainArgs.Navigator
                    VER=version;
                    hold on
                    if str2num(VER(1:3)) >= 9.0;
                        hline(section,'r');
                    else
                        hNav = graph2d.constantline(section, 'Color','r');
                        changedependvar(hNav,'y'); % change 'y' with 'x' for vertical line
                    end
                    hold off
                end               
                % ---:::---:::---:::---:::---:::---:::---:::---:::---:::---:::---:::---:::
                cptcmap(mapCell{MainArgs.PlotMode}{2},'mapping','direct','ncol',200);
                h3=subplot(2,2,2);
                ax3=get(h3,'position');
                set(h3,'position',ax3);
                subplot(2,2,2)
                modelSection(model2Path,'PlotFunct',MainArgs.PlotFunct, ...
                    'x_km',MainArgs.x_km,'y_km',MainArgs.y_km,'z_km',MainArgs.z_km, ...
                    'z0_km',MainArgs.z0_km,'nx',MainArgs.nx,'ny',MainArgs.ny, ...
                    'nz',MainArgs.nz,'Section',section,'Clim',climCell{MainArgs.PlotMode}{2}, ...
                    'Stations',stations,'Earthquakes',ipocenters, ...
                    'Coverage',MainArgs.Coverage,'CoverageMod',coverage2Path, ...
                    'ColorMap',mapCell{MainArgs.PlotMode}{2});
                if any(MainArgs.PlotMode==[5,6]) || MainArgs.Coverage; freezeColors; end
                if MainArgs.Navigator
                    VER=version;
                    hold on
                    if str2num(VER(1:3)) >= 9.0;
                        hline(slice,'r');
                    else
                        hNav = graph2d.constantline(slice, 'Color','r');
                        changedependvar(hNav,'y'); % change 'y' with 'x' for vertical line
                    end
                    hold off
                end
                
                h4=subplot(2,2,4);
                ax4=get(h4,'position');
                set(h4,'position',ax4);
                subplot(2,2,4)
                [~,~,~,hcb2]=modelDepthSlice(model2Path,'PlotFunct',MainArgs.PlotFunct, ...
                    'x_km',MainArgs.x_km,'y_km',MainArgs.y_km,'z_km',MainArgs.z_km, ...
                    'z0_km',MainArgs.z0_km,'nx',MainArgs.nx,'ny',MainArgs.ny, ...
                    'nz',MainArgs.nz,'Slice',slice,'Clim',climCell{MainArgs.PlotMode}{2}, ...
                    'Stations',stations,'Earthquakes',ipocenters,'Colorbar',1, ...
                    'Coverage',MainArgs.Coverage,'CoverageMod',coverage2Path, ...
                    'ColorMap',mapCell{MainArgs.PlotMode}{2});
                set(hcb2,'Units','Normalized', ...
                    'Position',[.569 .522 .337 .018],'FontSize',8);
                if any(MainArgs.PlotMode==[5,6]) || MainArgs.Coverage;freezeColors,cbfreeze(hcb2); end
                if MainArgs.Navigator
                    VER=version;
                    hold on
                    if str2num(VER(1:3)) >= 9.0;
                        hline(section,'r');
                    else
                        hNav = graph2d.constantline(section, 'Color','r');
                        changedependvar(hNav,'y'); % change 'y' with 'x' for vertical line
                    end
                    hold off
                end               
        end
        % Prompt Commands
        result=myPrompt('INS COMMAND:');
        if strcmpi(result,'w')              % north
            if section+dy<MainArgs.y_km ; section=section+dy; end
        elseif strcmpi(result,'s')          % south
            if section-dy>=0 ; section=section-dy; end
        elseif strcmpi(result,'d')          % down deep
            if slice+dz<MainArgs.z_km; slice=slice+dz; end
        elseif strcmpi(result,'a')          % upward
            if slice-dz>=0; slice=slice-dz; end
        elseif strcmpi(result,'rec on')
            if MainArgs.PlotStations; stations=MainArgs.Stations; end
        elseif strcmpi(result,'rec off')
            if MainArgs.PlotStations; stations=[]; end
        elseif strcmpi(result,'ipo old')
            if MainArgs.PlotEQ; ipocenters=MainArgs.IpoOld; end
        elseif strcmpi(result,'ipo new')
            if MainArgs.PlotEQ; ipocenters=MainArgs.IpoNew; end
        elseif strcmpi(result,'ipo off')
            if MainArgs.PlotEQ; ipocenters=[]; end
        elseif strcmpi(result,'quit')
            break
        else
            disp('DIGIT A VALID COMMAND');
        end
    end
else
    % =================================================================== Standalone Mode
    %       MODE 1: Vp
    %       MODE 2: Vs
    %       MODE 3: Vaux
    %   The ipocenters plotted are the newest one !!! (MainArgs.IpoNew)
    %
    if any(MainArgs.PlotMode==[1,2,3])
        [section,slice]=myInput({'Standalone Mode - Section (km)','float'}, ...
            {'Standalone Mode - Depth Slice (km)','float'});
        figure;
        %cptcmap('GMT_seis.cpt','mapping','direct','ncol',200);
        modelSection(model1Path,'PlotFunct',MainArgs.PlotFunct, ...
            'x_km',MainArgs.x_km,'y_km',MainArgs.y_km,'z_km',MainArgs.z_km, ...
            'z0_km',MainArgs.z0_km,'nx',MainArgs.nx,'ny',MainArgs.ny, ...
            'nz',MainArgs.nz,'Section',section,'Clim',climCell{MainArgs.PlotMode}, ...
            'Stations',MainArgs.Stations,'Earthquakes',MainArgs.IpoNew, ...
            'ColorMap',mapCell{MainArgs.PlotMode},'Colorbar',1, ...
            'Coverage',MainArgs.Coverage,'CoverageMod',coverage1Path);
      
        figure;
        cptcmap('GMT_seis.cpt','mapping','direct','ncol',200);
        modelDepthSlice(model1Path,'PlotFunct',MainArgs.PlotFunct, ...
            'x_km',MainArgs.x_km,'y_km',MainArgs.y_km,'z_km',MainArgs.z_km, ...
            'z0_km',MainArgs.z0_km,'nx',MainArgs.nx,'ny',MainArgs.ny, ...
            'nz',MainArgs.nz,'Slice',slice,'Clim',climCell{MainArgs.PlotMode}, ...
            'Stations',MainArgs.Stations,'Earthquakes',MainArgs.IpoNew, ...
            'Colorbar',1,'ColorMap',mapCell{MainArgs.PlotMode}, ...
            'Coverage',MainArgs.Coverage,'CoverageMod',coverage1Path);
    else
        error('### PStomoPlotter: Standalone mode support only PlotMode=[1,2,3] !!')
    end
end

%% Nested Function
    function [structOut]=dataSetter(structIn)
        %% DATASETTER: utility for finishing uploading data for the function
        %   input: structure ; OUTPUT: structure
        %
        %   AUTHOR: Matteo Bagagli @ INGV.PI
        %   DATE:   7/7/2006
        
        %% Work
%         Dir=fullfile('/home/matteo/PStomo_ingv2016/work/','*.*');
        Dir=fullfile('.','*.*');
        % Models
        switch structIn.PlotMode
            case 1
                if isempty(structIn.VpModel)
                    disp('@@@ SELECT Vp MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vp MODEL');
                    structIn.VpModel=[p,f];
                end
                % Coverage
                if structIn.Coverage && isempty(structIn.CoveragePModel)
                    disp('@@@ SELECT Coverage P-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage P-MODEL');
                    structIn.CoveragePModel=[p,f];
                end
            case 2
                if isempty(structIn.VsModel);
                    disp('@@@ SELECT Vs MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vs MODEL');
                    structIn.VsModel=[p,f];
                end
                % Coverage
                if structIn.Coverage && isempty(structIn.CoverageSModel)
                    disp('@@@ SELECT Coverage S-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage S-MODEL');
                    structIn.CoverageSModel=[p,f];
                end
            case 3
                if isempty(structIn.VauxModel)
                    disp('@@@ SELECT Vaux MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vaux MODEL');
                    structIn.VsModel=[p,f];
                end
                % Coverage
                if structIn.Coverage && isempty(structIn.CoverageAuxModel)
                    disp('@@@ SELECT Coverage Aux-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage Aux-MODEL');
                    structIn.CoverageAuxModel=[p,f];
                end
            case 4
                if isempty(structIn.VpModel)
                    disp('@@@ SELECT Vp MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vp MODEL');
                    structIn.VpModel=[p,f];
                end
                if isempty(structIn.VsModel)
                    disp('@@@ SELECT Vs MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vs MODEL');
                    structIn.VsModel=[p,f];
                end
                % Coverage
                if structIn.Coverage && isempty(structIn.CoveragePModel)
                    disp('@@@ SELECT Coverage P-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage P-MODEL');
                    structIn.CoveragePModel=[p,f];
                end
                if structIn.Coverage && isempty(structIn.CoverageSModel)
                    disp('@@@ SELECT Coverage S-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage S-MODEL');
                    structIn.CoverageSModel=[p,f];
                end   

            case 5
                if isempty(structIn.VpModel);
                    disp('@@@ SELECT Vp MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vp MODEL');
                    structIn.VpModel=[p,f];
                end
              
                if isempty(structIn.VauxModel);
                    disp('@@@ SELECT Vaux MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vaux MODEL');
                    structIn.VauxModel=[p,f];
                end
                % Coverage
                if structIn.Coverage && isempty(structIn.CoveragePModel)
                    disp('@@@ SELECT Coverage P-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage P-MODEL');
                    structIn.CoveragePModel=[p,f];
                end
                if structIn.Coverage && isempty(structIn.CoverageAuxModel)
                    disp('@@@ SELECT Coverage Aux-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage Aux-MODEL');
                    structIn.CoverageAuxModel=[p,f];
                end
            case 6
                if isempty(structIn.VsModel);
                    disp('@@@ SELECT Vs MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vs MODEL');
                    structIn.VsModel=[p,f];
                end
                if isempty(structIn.VauxModel);
                    disp('@@@ SELECT Vaux MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Vaux MODEL');
                    structIn.VauxModel=[p,f];
                end
                % Coverage
                if structIn.Coverage && isempty(structIn.CoverageSModel)
                    disp('@@@ SELECT Coverage S-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage S-MODEL');
                    structIn.CoverageSModel=[p,f];
                end
                if structIn.Coverage && isempty(structIn.CoverageAuxModel)
                    disp('@@@ SELECT Coverage Aux-MODEL');
                    [f,p]=uigetfile(Dir,'SELECT Coverage Aux-MODEL');
                    structIn.CoverageAuxModel=[p,f];
                end  

        end
%         % Coverage
%         if structIn.Coverage && isempty(structIn.CoverageModel)
%             [f,p]=uigetfile(Dir,'SELECT Coverage MODEL');
%             structIn.CoverageModel=[p,f];
%         end
        % Velocities
        if structIn.InitVelProfile
            if isempty(structIn.VelpFile)
                disp('@@@ SELECT M0-P vel1d par MODEL');
                [f,p]=uigetfile(Dir,'SELECT M0-P vel1d par MODEL');
                structIn.VelpFile=[p,f];
            end
            if isempty(structIn.VelsFile)
                disp('@@@ SELECT M0-S vel1d par MODEL');
                [f,p]=uigetfile(Dir,'SELECT M0-S vel1d par MODEL');
                structIn.VelsFile=[p,f];
            end
        end
        % Ipocenter
        if structIn.PlotEQ
            if isempty(structIn.IpoOld)
                disp('@@@ SELECT Old SEISMICITY');
                [f,p]=uigetfile(Dir,'SELECT Old SEISMICITY');
                structIn.IpoOld=[p,f];
            end
            if isempty(structIn.IpoNew)
                disp('@@@ SELECT New SEISMICITY');
                [f,p]=uigetfile(Dir,'SELECT New SEISMICITY');
                structIn.IpoNew=[p,f];
            end
        end
        % Station
        if structIn.PlotStations
            if isempty(structIn.Stations)
                disp('@@@ SELECT Station FILE');
                [f,p]=uigetfile(Dir,'SELECT Station FILE');
                structIn.Stations=[p,f];
            end
        end        
        % Area parameter
        if isempty(structIn.x_km); structIn.x_km=input('### MODEL x (km) ? '); end
        if isempty(structIn.y_km); structIn.y_km=input('### MODEL y (km) ? '); end
        if isempty(structIn.z0_km); structIn.z0_km=input('### MODEL z0 (km,negative) - altitude ? '); end        
        if isempty(structIn.z_km); structIn.z_km=input('### MODEL z (km) ? '); end
        % Models parameter
        if isempty(structIn.nx); structIn.nx=input('### nx ? '); end
        if isempty(structIn.ny); structIn.ny=input('### ny ? '); end
        if isempty(structIn.nz); structIn.nz=input('### nz ? '); end
        %
        structOut=structIn;
    end
end % End MAIN
