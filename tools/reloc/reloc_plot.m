function [h_x,h_y,h_z,h_t]=reloc_plot(name)
%%% RICORDATI l'asterisco alla fine del "name"  !!!! 
clc

files = dir(name);
files = {files.name};

RELOC=cell(length(files),1);

XlimKm= [-1 1 0 200];
XlimSec= [-0.3 0.3 0 200];
hyst=60;

%keyboard
% creo 4 figure: dX dY dZ dT

fig_title=['Relocalization in X dimension: ', name];
h_x=figure('Units','normalized','Name',fig_title,'NumberTitle','off', ...
    'Position',[0.0 0.0 0.25 1 ]);

fig_title=['Relocalization in Y dimension: ', name];
h_y=figure('Units','normalized','Name',fig_title,'NumberTitle','off', ...
    'Position',[0.25 0 0.25 1]);

fig_title=['Relocalization in Z dimension: ', name];
h_z=figure('Units','normalized','Name',fig_title,'NumberTitle','off', ...
    'Position',[0.50 0 0.25 1 ]);

fig_title=['Temporal Relocalization: ', name];
h_t=figure('Units','normalized','Name',fig_title,'NumberTitle','off', ...
    'Position',[0.75 0 0.25 1 ]);


% i=1:length(files)
for i=1:length(files)
    RELOC{i}=load(files{i});
    
    figure(h_x);
    subplot(length(files),1,i)
    hist(RELOC{i}(:,1),hyst);
    axis(XlimKm);
    if i ==   (length(files))
        xlabel('\Delta{x} km');
    end
    
    figure(h_y);
    subplot(length(files),1,i)
    hist(RELOC{i}(:,2),hyst);
    axis(XlimKm);
    if i ==   (length(files))
        xlabel('\Delta{y} km');
    end
    
    figure(h_z)
    subplot(length(files),1,i)
    hist(RELOC{i}(:,3),hyst);
    axis(XlimKm);
    if i ==   (length(files))
        xlabel('\Delta{z} km');
    end
    
    figure(h_t)
    subplot(length(files),1,i)
    hist(RELOC{i}(:,4),hyst);
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','r','EdgeColor','k'); 
    axis(XlimSec);  
    if i ==   (length(files))
        xlabel('\Delta{t} s');
    end
end