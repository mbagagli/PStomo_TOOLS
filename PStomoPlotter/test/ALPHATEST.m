clear all, close all

DATA=load('MOD_sect.mat');
DATA=DATA.MOD_sect;
BOOL=load('COV_sect.mat');
BOOL=BOOL.COV_sect;


GRAY=repmat(0.5,size(DATA,1),size(DATA,2));

ALPHA=zeros(size(BOOL));
for ii=1:size(BOOL,1)
    for jj=1:size(BOOL,2)
        if BOOL(ii,jj)>0
            ALPHA(ii,jj)=1;
        else
            ALPHA(ii,jj)=0;
        end
    end
end

figure
colormap(gray);
pcolor(GRAY');
freezeColors
hold on;
cptcmap('GMT_seis.cpt','mapping','direct','ncol',200);
hplt=pcolor(DATA');axis ij image tight;caxis([3 6]);shading interp
set(hplt,'alphadata',ALPHA','facealpha','interp','edgecolor','none');
colorbar

% 1)plottare la maschera
% 2)plottare immagine
% 3)creare matrice 0-1 
% 4) set(plot,'alphadata',maschera(3))

figure
colormap(gray);
imagesc(GRAY');
freezeColors
hold on;
cptcmap('GMT_seis.cpt','mapping','direct','ncol',200);
hplt=imagesc(DATA');axis ij image tight;caxis([3 6]);
set(hplt,'alphadata',ALPHA')
colorbar

% figure
% colormap(gray);
% contourf(GRAY');
% freezeColors
% hold on;
% cptcmap('GMT_seis.cpt','mapping','direct','ncol',200);
% hplt=contourf(DATA');axis ij image tight;caxis([3 6]);
% set(hplt,'alphadata',ALPHA')
% colorbar


%% FROM INTERNET

% z = peaks;
% [c,h] = contourf(z); clabel(c,h), colorbar
% % Set the figure Renderer to OpenGL, which supports transparency
% set(gcf, 'Renderer', 'OpenGL');
% % Find all the objects that are children of the contourgroup that have the
% alphable = findobj(h, '-property', 'FaceAlpha');
% for k = [1:-0.1:0.1 0.1:0.1:1]
%     % Change the FaceAlpha property, which will change the objects' 
%     set(alphable, 'FaceAlpha',k);
%     pause(0.5)
% end






