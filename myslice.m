function mydata = myslice(filePath)
%% MYSLICE
% Stocazzo daje
    mydata=loadMeBitch(filePath);
%     [lon, lat, dep, vel]
    dp = geodensityplot(mydata(:,2),mydata(:,1),mydata(:,4),'FaceColor','interp', 'Radius', 1500);
    geobasemap none
    geolimits([43.03,43.35],[10.75,11.25]);

    function matrix = loadMeBitch(filePath)
        fid=fopen(filePath);  % [x,y,lon,lat,z,vp,pvp(%),dvp(absol.),phit,pkhit,pdws,presol.,spread_p,vpvs,pvpvs(%),skhit,sdws,sresol,spread_s ]
          Vel1=textscan(fid,'%*f %*f   %f %f %f %f %f   %*f %*f %*f %*f %*f %*f %f %f %*f %*f %*f %*f','headerLines',2); %"%*f" --> skip a value
        fclose(fid);
        LON=Vel1{1};    
        LAT=Vel1{2}; 
        DEP=Vel1{3};
        vp=Vel1{4};  %v (km/s)
        dv1=Vel1{5};   %dv (%)
        vp_vs1=Vel1{6};  %vp/vs
        delta_vp_vs1=Vel1{7}; % d(vp/vs)
        matrix=[LON, LAT, DEP, vp];
    end


end