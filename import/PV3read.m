function PV3data=PV3read(Studydirectory,Scannumber)
% -------------------------------------------------------------------------
% function PV3data=PV3read(Studydirectory,Scannumber)
% 
% Version 1.0 - Original
% Version 2.0 - Modified to read 2nd reco from DW SE DTI sequence
% Version 3.0 - This file is used to read data from Bruker into Matlab.
%
% The 2nd reconstruction of the DTI data set is scaled with the correct
% scaling factors. Results are saved in:
% -- data{1}.Scan{15}.Reconstruction{2}.imscaled
% 
% B.J. van Nierop
% March, 2008
%
% TU/eindhoven
% Biomedical NMR
% ------------------------------------------------------------------------- 
    
if nargin == 0
% GUI for selecting directory
    [fname,Studydirectory] = uigetfile('*.*','Select file in Study directory');
end;

if nargin < 2   
% Looking for the number of scans in a study
    Studyinfo=dir(Studydirectory);
end;

if nargin == 2
   Studyinfo.name=num2str(Scannumber);
   Studyinfo.isdir=1;
end;

% Creating cells: PV3data{1} with the scan data 
%                 PV3data{2} study parameters
% Create empty structure element that will contain all the measurement
% parameters as well as the actual images!
PV3data=cell(1,2);
% The first element (PV3data{1}) will contain as much empty elements as
% there are scans in the exam.
PV3data{1}.Scan=cell(1,sum([Studyinfo.isdir])-2);

% Writing the study information in PV3data{2}. The file jcampread collects
% a lot of information from the experiment and writes it to the second
% structure element in PV3read.
subjectinformation=jcampread([Studydirectory '/subject']);
if isstruct(subjectinformation)
    PV3data{2}=subjectinformation;
end;

% Counter for scan number
Scan=0;

% Writing the scan data in PV3data{1}.Scan{number}. In the next step the
% first structure element will be filled with all the images as well as
% some parameters for each experiment.
for i=1:length(Studyinfo)
    Scandirectory=getfield(Studyinfo,{i,1},'name');
    if Studyinfo(i).isdir && ~strcmp(Scandirectory,'.') && ~strcmp(Scandirectory,'..') && ~isempty(str2num(Scandirectory))
        % Looking for the number of reconstructions in a scan
        if nargin == 2
            Scan=Scan+1;
        else
            Scan=str2num(Scandirectory);
        end;
        % Scaninfo bevat informatie over de verschillende reco's van een
        % scan
        Scaninfo=dir([Studydirectory '/' Scandirectory '/pdata/']);
        % Als bepaald is hoeveel reconstructies een exam bevat, wordt er
        % een lege array aangemaakt via het commando cell.
        PV3data{1}.Scan{Scan}.Reconstruction=cell(1,sum([Scaninfo.isdir])-2);

        % Acquisition information
        acqpinformation=jcampread([Studydirectory '/' Scandirectory '/acqp']);
        if isstruct(acqpinformation)
            PV3data{1}.Scan{Scan}.acqp=acqpinformation;
        else
            %disp(['Scan ' Scandirectory ' :acqp file not found (PV3read)' ])
        end;

        % PVM information
        if exist([Studydirectory '/' Scandirectory '/method'])
            methodinformation=jcampread([Studydirectory '/' Scandirectory '/method']);
            if isstruct(methodinformation)
                PV3data{1}.Scan{Scan}.method=methodinformation;
            else
                %disp(['Scan ' Scandirectory ' :method file not found (PV3read)' ])
            end;
        end;
        % IMND information
        if exist([Studydirectory '/' Scandirectory '/imnd'])
            imndinformation=jcampread([Studydirectory '/' Scandirectory '/imnd']);
            if isstruct(imndinformation)
                PV3data{1}.Scan{Scan}.imnd=imndinformation;
            else
                %disp(['Scan ' Scandirectory ' :IMND file not found (PV3read)' ])
            end;
        end;

        % Writing reconstruction data in the PV3data{1}.Scan{number}.Reconstruction{number}.
        % Voor elke scan bepalen we het aantal mappen == aantal
        % reconstructies via de lengte van Scaninfo
        for j=1:length(Scaninfo)
            Reconstructiondirectory=getfield(Scaninfo,{j,1},'name');
            % Om een of andere reden staan er bij de directories ook een
            % map '.' en '..', deze slaan we dus mooi over, want bevat geen
            % zinnige info.
            if Scaninfo(j).isdir && ~strcmp(Reconstructiondirectory,'.') && ~strcmp(Reconstructiondirectory,'..')
                fullpath=[Studydirectory '/' Scandirectory '/pdata/' Reconstructiondirectory];
                %disp('-------------------------------------------')
                %disp(['Read data from: ', fullpath])
                % Reconstruction information. N/A for 2nd reconstruction of DW SE DTI dataset
                recoinformation=jcampread([fullpath '/reco']);
                % Reconstruction information
                d3procinformation=jcampread([fullpath '/d3proc']);
                % Visupars information
                visupars=jcampread([fullpath '/visu_pars']);
                % Check if there was made a succesful reconstruction. If so, we can use this information to load
                % the dataset regardless of dimensions etc because this
                % information is captured in reco and d3proc
                if isstruct(recoinformation) && isstruct(d3procinformation) && isstruct(visupars)
                    %disp(['Scan: ' Scandirectory ', Reco: ' Reconstructiondirectory])
                    PV3data{1}.Scan{Scan}.Reconstruction{str2num(Reconstructiondirectory)}=load2dseq([fullpath '/2dseq'],d3procinformation,recoinformation);            
                    PV3data{1}.Scan{Scan}.Reconstruction{str2num(Reconstructiondirectory)}.reco=recoinformation;
                    PV3data{1}.Scan{Scan}.Reconstruction{str2num(Reconstructiondirectory)}.d3proc=d3procinformation;
                    PV3data{1}.Scan{Scan}.Reconstruction{str2num(Reconstructiondirectory)}.visupars=visupars;
                elseif isstruct(d3procinformation) && isstruct(visupars)
                    %disp(['Scan: ' Scandirectory ', Reco: ' Reconstructiondirectory])
                    recoinfo.reco.byte_order=       'littleEndian';
                    recoinfo.reco.wordtype=         '_32BIT_SGN_INT';
                    recoinfo.reco.image_type=       'MAGNITUDE_IMAGE';  
                    recoinfo.reco.transposition=    d3procinformation.im.siz;
                    %disp('The previous information about the file "reco" is assumed, which is not necessarily')
                    %disp('correct for other reconstructions than a 2nd reco from a DW SE DTI dataset.')
                    %disp(recoinfo.reco)
                    PV3data{1}.Scan{Scan}.Reconstruction{str2num(Reconstructiondirectory)}=load2dseq([fullpath '/2dseq'],d3procinformation,recoinfo);            
                    PV3data{1}.Scan{Scan}.Reconstruction{str2num(Reconstructiondirectory)}.d3proc=d3procinformation;
                    PV3data{1}.Scan{Scan}.Reconstruction{str2num(Reconstructiondirectory)}.visupars=visupars;
                else
                    %disp(['Scan ' Scandirectory ', Reco ' Reconstructiondirectory ' :reco file not found (PV3read)' ])
                end;
                %disp('-------------------------------------------')
            end;
        end;
    end;
end;
% -----------------------------------------------------------------       
        

end