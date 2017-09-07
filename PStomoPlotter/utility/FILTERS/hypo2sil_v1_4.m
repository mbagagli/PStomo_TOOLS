function [out_file]=hypo2sil(input,index_phase,n_event,station_number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% FORMAT CONVERTER hypoellipse --> sil (ARI TRIGVASON) %%%%%%%%%
%%%%%%%    VERSION 1.4 (aggiunto caso P_RES/S_RES blank!!)   %%%%%%%%%
%%%%%%%                (aggiunto caso PWEIGTH/SWEIGHT blank!!) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT =   - string_matrix in cell arrays;
%           - index_phase = line number where it begins the phase block
%           - n_event = number ID of the event (to enumerate the cicle)
%           - station_number = total receiver/station of the area
% ############################################################
% If receiver > 999 && events > 9999 ---> CHANGE ID in FPRINTF
% ############################################################


file_name='PHASEALL';

%%  DATA ACQUISITION %%%%%

header=char(input(2));  % faccio riferimento alla prima riga utile P(2)
header2=char(input(3)); % sempre ok
header3=char(input(5)); % sempre ok
header4=char(input(index_phase+1)); % DA GENERALIZZARE

DATE=str2num(header(1:8));
HOUR=str2num(header(10:11));
MIN=str2num(header(12:13));
SEC=str2num(header(15:19));
DEPTH=str2num(header(41:45));
GAP=str2num(header(60:62));
LAT=str2num(header2(1:8));
LON=str2num(header2(11:17));


TOT_PHASE=str2num(header3(24:25));

%%%%%%%%%%%%%%%%%%%% STATION COUNTER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stn_index=1;
for j=1:TOT_PHASE
    string=char(input(index_phase+j));
    receiver(j)=str2num(string(1:3));
    phase(j)=string(7);
    if j >= 2
        if receiver(j) ~= receiver(j-1)
            stn_index=stn_index + 1 ;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DIST=str2num(header4(46:50));
TOT_REC= stn_index ; % numero totale di stazioni che hanno visto l'evento
MAG=-9.0;
ZEROES=0.0000;
ID_event=n_event;

middle=fopen('phase','w');

%% INNER CYCLE -->  creo file intermedio

% inizializzo gli indici del ciclo.
k=1;
while k <= TOT_PHASE
    if ischar(char(input(index_phase+k)));
        string=char(input(index_phase+k));
        STN=str2num(string(1:3));
        % Checking the EOF & iteration number
        if k >= 2 && STN == receiver(k-1)
            if  k == TOT_PHASE
                break;
            else
                k=k+1;   % se due stazioni consecutive sono uguali incrementa la variabile.
            end
        end
        
        string=char(input(index_phase+k));
        STN=str2num(string(1:3));
        P_WEIGHT=9;
        S_WEIGHT=9;
        
        PHASE=char(string(7));
        % ciclo controllo per due fasi alla stessa stazione
        if k <= (TOT_PHASE - 1) && ischar(char(input(index_phase+(k+1))))   % definisco la riga successiva se esiste
            string2=char(input(index_phase+(k+1)));
            
            if isempty(string2) ~= 1
                STN2=str2num(string2(1:3));
                PHASE2=char(string2(7));
            end
        end
        if k <= (TOT_PHASE - 2) % (TOT_PHASE - 2)
            if ischar(char(input(index_phase+(k+2)))) && k <= TOT_PHASE   % definisco 2 RIGA SUCC se esiste
                string3=char(input(index_phase+(k+2)));                   % prendila
                
                if isempty(string3) ~= 1
                    STN3=str2num(string3(1:3));
                    PHASE3=char(string3(7));
                end
            end
        end
        %%%% PHASE STUDY
        if PHASE == ' '  %phase P (and grep the S after)
            P_RESID=str2num(string(30:34));
            if  isempty(P_RESID)
                P_RESID=0;
            end
            P_TT=str2num(string(73:77));
            if str2num(string(14))~=' '; P_WEIGHT=str2num(string(14));end %v1.4 Avoid mismatch in DATA_2 matrix
            if STN2 == STN && PHASE2 == 's'
                S_RESID=str2num(string2(30:34));
                if isempty(S_RESID)
                    S_RESID=0;
                end
                S_TT=str2num(string2(73:77));
                if str2num(string2(14))~=' '; S_WEIGHT=str2num(string2(14)); end %v1.4
                k=k+1; %incremento variabile controllo (caso std P-s)
            elseif k <= (TOT_PHASE-2) && STN3 == STN && PHASE3 == 's'
                S_RESID=str2num(string3(30:34));
                if  isempty(S_RESID)
                    S_RESID=0;
                end
                S_TT=str2num(string3(73:77));
                S_WEIGHT=str2num(string3(14));
                k=k+2; %incremento variabile controllo   (caso di P-P-S )
            else
                S_RESID=0;
                S_TT=0;
                k=k+1; %incremento variabile controllo (solo FASE P)
            end
            
        else
            disp('ci sono eventi che hanno solo fase S ');
        end
        
        fprintf(middle,'%03d \t%8.6f \t%8.6f \t%1d \t%1d \t%5.2f \t%5.2f\n', ...
            STN,P_TT,S_TT,P_WEIGHT,S_WEIGHT,P_RESID,S_RESID);
    end
end

fclose(middle);

%% SORT CYCLE  ---> aggiungo le righe delle stazioni mancanti

DATA=importdata('phase','\n');

DATA_2=unique(DATA);  % evito la doppia ripetizione in sequenza di P&S alla
% stessa stazione
%
for i=1:size(DATA_2,1)
    string_data=char(DATA_2(i));
    station(i,:)=str2num(string_data); % creo la matrice caratteri
end

matrix=sortrows(station,1); % si può bypassare

FINAL=zeros(station_number,7); % pre-alloco la memoria

for i=1 : station_number % STAZIONI TOTALI DEL DATASET
    
    if any(matrix(:,1) == i)
        x=find(matrix(:,1) == i);   % i,2 evita rip di fase P dopo che la
        y=x(end);                    % stessa stazione è stata già presa,
        % UNIQUE mette prima la riga sbagliata
        % di quella corretta..
        
        FINAL(i,:)=matrix(y,:);
        
    else
        FINAL(i,1)=i;
    end
    
end

remove=find(FINAL(:,2) == 0 );  % v 1.2  Elimino le righe delle stazioni
FINAL(remove,:)=[]   ;          % che non ricevono, e le elimino.

%count new_phases (in caso di righe doppie) --> 2°-3° colonna
% v 1.2

new_TOT_PHASE=0;
for i=1:TOT_REC
    if FINAL(i,2) ~= 0
        new_TOT_PHASE=new_TOT_PHASE+1;
    end
end
for i=1:TOT_REC
    if FINAL(i,3) ~= 0
        new_TOT_PHASE=new_TOT_PHASE+1;
    end
end

%% WRITE OUTPUT

out_file=fopen(file_name,'a'); % PRIMA DI INIZIARE IL CICLO, APRO IL FILE!!!
%%%%%%%%%%%%%%%%%%%%% HEADER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pad to field width with zeros. Example: %05.2f
fprintf(out_file,'%8d %02d%02d%06.3f %7.4f %7.4f %6.4f %3.1f %4.1f %3d %2d %3d  %6.4f %04d\n', ...
    DATE,HOUR,MIN,SEC,LAT,LON,DEPTH,MAG,DIST,GAP,TOT_REC,new_TOT_PHASE,ZEROES,ID_event);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(out_file,' %03d %8.6f %8.6f %1d %1d %5.2f %5.2f\n',FINAL');
fclose(out_file);


%% RIFERIMENTI

% Il comando quà sotto consente di visualizzare tutta la linea in argomento
%
% CS=char(P(1))

% header=char(P(ID(2)+2))

% PER OGNI EVENTO DEVO RAGGIUNGERE QUESTA FORMA
%   date    origin_time     LAT         LON       DEP   MAG     ?    GAP n°stat  n°phase     ??   n°EVE
% 20020101 120000.000     63.9282    -21.2320   3.8969 -9.0    0.0   0.0  12     24        0.0000  001

%  001  5.712300 10.109300 0 0  0.00  0.00
%  002  7.065300 12.555300 0 0  0.00  0.00
%  003 10.443900 18.583799 0 0  0.00  0.00
%  004  1.046600  1.934300 0 0  0.00  0.00
%  005  2.852500  5.036800 0 0  0.00  0.00
%  006  3.834300  6.814000 0 0  0.00  0.00
%  007 10.380800 18.415701 0 0  0.00  0.00
%  008  8.839100 15.753600 0 0  0.00  0.00
%  009  3.732100  6.568200 0 0  0.00  0.00
%  010  3.942100  7.010700 0 0  0.00  0.00
%  011  4.479200  7.911800 0 0  0.00  0.00
%  012  6.134100 10.941200 0 0  0.00  0.00

% STN     P_tt      S_tt   USED R_res S_res

% path=(path)
% files = dir( fullfile(path,'*.jpg') );   %# list all *.xyz files
% files = {files.name}';                      %'# file names
%
% data = cell(numel(files),1);%# store file contents
%
% a=zeros(numel(files),3);

% for j=1:length(P)
%     CS=char(P(j)); % memorizza linea in array di caratteri
%     LCS(j)=length(CS); % conta il numero dei caratteri contenuti nella riga
% end
