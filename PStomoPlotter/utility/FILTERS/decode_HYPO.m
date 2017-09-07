%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   ROUTINE DI FORMATTAZIONE EVENTI ---> 1 sec / 10 events (legnata)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% &&&&&&&&&&&&&&&&&&& PATH EVENTI

clear all
clc

%%% --------------------------------------------------------------- NEW
PATH='/home/matteo/PStomo_ingv2016/data/events';
cd(PATH)
%%% --------------------------------------------------------------- OLD
%PATH='/home/billy/tesi/pstomo/projects/uff_DATA_NEW/EVENTS';
%PATH='/home/billy/TRIFFROS/EVENTS';
%cd '/home/billy/tesi/pstomo/projects/uff_DATA_NEW/EVENTS';
%cd '/home/billy/TRIFFROS/EVENTS';
%cd '/home/matteo/PStomo_ingv2016/data/events'

files = dir( fullfile(PATH,'*.hypo') );
files = {files.name};

% &&&&&&&&&&& NUMBER TOTAL STATION

stat_num = 22 ; %new2016
% stat_num = 20 ; %old

%%%%%%%%%%% routine %%%%%%%%%%%%%%

for i=1:length(files)
    A=textread(files{i},'%s','delimiter','\n'); % leggi l'evento // in alternativa anche
    % IMPORTDATA('file','\n') và
    % bene!!
    
    %%% per controllare l'inizio delle fasi
    for index=1:length(A)
        string_test=char(A(index));
        if length(string_test) >= 1
            test=string_test(1:5);
            if strcmp(test,'stn c') == 1
                break
            end
        end
    end
    %%%%%%%%%% CORPO DEL FILTRO %%%%%%%%%%%%
    hypo2sil_v1_4(A,index,i,stat_num);
    c=num2str(i);
    disp(strcat('done ', c,' file'));
end

