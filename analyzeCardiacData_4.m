function[] = analyzeCardiacData_4()

%%select .mat files generated from apdCalc to combine and analyze. This
%%should start with the d0 for dose curves, and file can be expanded later
%%to include more doses
%%Output as .mat and .csv

%%Determine number of entries in experiment for files to be grouped into
numEntry = input('How many entries for this experiment analysis?   ');

filename = input('Give the output file a name for the analysis?   ');
if isempty(filename) == 1
    disp ('Please provide a string');
    filename = input(prompt2);
else
end
if ischar(filename) == 0
    disp ('Please provide a character in single quotations');
    filename = input(prompt2);
else
end

%%
%%Start for loop for picking files, to be called again later
for filePicker = 1:numEntry
    disp(filePicker);
    if ispc
        [Filelist,Pathname] = uigetfile('E:\\*.mat','File Selector','MultiSelect','on'); %%Select and get files to be combined and analyzed further
    elseif ismac
        [Filelist,Pathname] = uigetfile('/**/*.mat','File Selector','MultiSelect','on'); %%Select and get files to be combined and analyzed further
    else
        disp('Platform not supported');
    end
    fileList(filePicker , 1:length(Filelist)) = Filelist;
    pathName = char(Pathname);  %%will save to the path of the last chosen file
end
tic
%%Transpose fileList
fileList = fileList' ;
%%Save the list of files to the new output file for bookkeeping, and as a
%%handle for later analysis
fullOutputName = [pathName filename];
save(fullOutputName,'fileList');

%%
%%Start looping for each set of grouped files to fill out each data entry
%%for the experiment
for entryNumber = 1:numEntry
    allData  = struct(); %%Create a data structure for each data field you are about to open
    indexFileList = cellfun(@isempty , fileList) == 0 ;
    numFiles = sum(indexFileList(:,entryNumber)); %%Counts how many files you open for indexing
    for iFile = 1:numFiles              % Loop over found files
        Data = load(fullfile(Pathname, fileList{iFile,entryNumber})); %%Open the ith file in the list
        Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error
        Fields = fieldnames(Data); %% Get all the field names available in the file
        for iField = 1:numel(Fields)              % Loop over fields of current file
            aField = Fields{iField};
            if isfield(allData, aField)             % Attach new data:
                allData.(aField)(end+1:end+numel(Data.(aField))) = Data.(aField); %Add new data to end of previous data (concatenate files)
            else
                allData.(aField) = Data.(aField);
            end
        end
    end  %%All data from each file in this group should be together for the entry
    
    %%Data gets passed to two other scripts for analysis here
    [DataAnalysis] = cAPstat_3 (allData , filename, Pathname); %1st time, goes into cAPStat with the allData stuc with concatenated data, 2nd time depends on Choice
    allcAPs = normalcAP_3 (allData , filename, pathName );
    
end

%%
%%Save output as csv here (.mat made in the loop)
fullOutputName = [Pathname filename];
%%re-load data (could optimize here)
saveData = load(fullOutputName);
avg_apd30 = getfield(saveData,'avg_apd30');
avg_apd50 = getfield(saveData,'avg_apd50');
avg_apd90 = getfield(saveData,'avg_apd90');
avg_cAPD30 = getfield(saveData,'avg_cAPD30');
avg_cAPD50 = getfield(saveData,'avg_cAPD50');
avg_cAPD90 = getfield(saveData,'avg_cAPD90');
avg_FcAPD30 = getfield(saveData,'avg_FcAPD30');
avg_FcAPD50 = getfield(saveData,'avg_FcAPD50');
avg_FcAPD90 = getfield(saveData,'avg_FcAPD90');
avg_BPM = getfield(saveData,'avg_BPM');
avg_interEinter = getfield(saveData,'avg_interEinter');
avg_SNR = getfield(saveData,'avg_SNR');
std_apd30 = getfield(saveData,'std_apd30');
std_apd50 = getfield(saveData,'std_apd50');
std_apd90 = getfield(saveData,'std_apd90');
std_cAPD30 = getfield(saveData,'std_cAPD30');
std_cAPD50 = getfield(saveData,'std_cAPD50');
std_cAPD90 = getfield(saveData,'std_cAPD90');
std_FcAPD30 = getfield(saveData,'std_FcAPD30');
std_FcAPD50 = getfield(saveData,'std_FcAPD50');
std_FcAPD90 = getfield(saveData,'std_FcAPD90');
std_BPM = getfield(saveData,'std_BPM');
std_interEinter = getfield(saveData,'std_interEinter');
std_SNR = getfield(saveData,'std_SNR');

meancAP = getfield(saveData,'meancAP');

%%Write into text file
dataHead = {'avg_apd30' 'std' 'avg_apd50' 'std' 'avg_apd90' 'std' ...
    'avg_cAPD30' 'std' 'avg_cAPD50' 'std' 'avg_cAPD90' 'std' ...
    'avg_FcAPD30' 'std' 'avg_FcAPD50' 'std' 'avg_FcAPD90' 'std' ...
    'avg_BPM' 'std' 'avg_IEI' 'std' 'avg_SNR' 'std'};

% dataValues = {avg_apd30 , std_apd30 , avg_apd50 , std_apd50 , avg_apd90 , std_apd90 ...
%      , avg_cAPD30 , std_cAPD30 , avg_cAPD50 , std_cAPD50 , avg_cAPD90 , std_cAPD90 ...
%      , avg_FcAPD30 , std_FcAPD30 , avg_FcAPD50 , std_FcAPD50 , avg_FcAPD90 , std_FcAPD90 ...
%      , avg_BPM , std_BPM , avg_interEinter , std_interEinter , 'avg_SNR' 'std'};

dataValues(:,1) = avg_apd30 ;
dataValues(:,2) = std_apd30 ;
dataValues(:,3) = avg_apd50 ;
dataValues(:,4) = std_apd50 ;
dataValues(:,5) = avg_apd90 ;
dataValues(:,6) = std_apd90 ;
dataValues(:,7) = avg_cAPD30 ;
dataValues(:,8) = std_cAPD30 ;
dataValues(:,9) = avg_cAPD50 ;
dataValues(:,10) = std_cAPD50 ;
dataValues(:,11) = avg_cAPD90 ;
dataValues(:,12) = std_cAPD90 ;
dataValues(:,13) = avg_FcAPD30 ;
dataValues(:,14) = std_FcAPD30 ;
dataValues(:,15) = avg_FcAPD50 ;
dataValues(:,16) = std_FcAPD50 ;
dataValues(:,17) = avg_FcAPD90 ;
dataValues(:,18) = std_FcAPD90 ;
dataValues(:,19) = avg_BPM ;
dataValues(:,20) = std_BPM ;
dataValues(:,21) = avg_interEinter ;
dataValues(:,22) = std_interEinter ;
dataValues(:,23) = avg_SNR ;
dataValues(:,24) = std_SNR ;

saveOutputName = [fullOutputName '.txt'];
fid = fopen(saveOutputName , 'w');
fprintf(fid, '%s,', dataHead{1,1:end-1}) ;
fprintf(fid, '%s\n', dataHead{1,end}) ;

fclose(fid) ;
dlmwrite(saveOutputName, dataValues ,  'roffset' , 0 , 'coffset' , 0 ,  '-append') ;
% dlmwrite(saveOutputName, std_apd30 , 'delimiter' , ' ' , 'roffset' , 0 , 'coffset' , 1 ,  '-append') ;

%%
%%Saving traces into csv files
meanTraceOutputName = [fullOutputName '_mean_traces.txt'];
dlmwrite(meanTraceOutputName , meancAP);
toc
end



