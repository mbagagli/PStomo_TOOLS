%%% SILSTRIB %%% (mif?? una...)
%%% - Scompatta il file di uscita di HYPOELLIPSE.
%%% - Salva i singoli eventi in una dir. 

clear all
clc
%%% --------------------------------------------------------------- NEW
path_file='/home/matteo/PStomo_ingv2016/data/out.out';
path_eventi='/home/matteo/PStomo_ingv2016/data/events/';
%%% --------------------------------------------------------------- OLD
% path_file='~/tesi/pstomo/projects/uff_DATA_NEW/data/OUT.official';
% path_eventi='~/tesi/pstomo/projects/uff_DATA_NEW/EVENTS/';
% %path_eventi='~/TRIFFROS/EVENTS/';
%%% --------------------------------------------------------------- REGEXP
expression_header='    date    origin      lat';
expression_end='-- magnitude data --';

data = fopen(path_file);
tline = fgetl(data);  % diventa la mia varibile di lettura!

% inizializzo a zero il contatore utilizzato per generare il nome dei files
numero_file = 0;

% definisco la variabile che andr?? a contenere gli identificativi dei files
fid=0;

% inizializzo la variabile controllo dentro/fuori ciclo
in = 0 ;

while ischar(tline)
    % check se sono dentro
    if in == 1
        % controllo se sono arrivato alle lineette
         startIndex = regexp(tline,expression_end);
         % se sono arrivato esco, rimetto la variabile ciclo a 0 e chiudo
         % il file
         if startIndex ~= 0 
             in = 0;
             fclose(fid);
         else
             % se non sono al bottom ho gia aperto il file e ...
             % ... stampo la riga
             fprintf(fid,'%s\n',tline);
         end
    else
        %controllo se sono arrivato all'HEADER
        startIndex = regexp(tline,expression_header);
        if startIndex ~= 0 
             in = 1;
             % apriamo il file per la scrittura
             numero_file=numero_file+1;
             fid=fopen(strcat(path_eventi,num2str(numero_file),'_evento.txt'),'w');
             % e stampo la riga
             fprintf(fid,'%s\n',tline);
        end
    end
    % questo lo deve leggere sempre
    tline = fgetl(data);
end
fclose(data);