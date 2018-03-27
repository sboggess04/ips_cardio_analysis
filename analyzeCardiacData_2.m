function[] = analyzeCardiacData2()

prompt2 = 'Provide filename: ';

%%select .mat files generated from apdCalc to combine and analyze. This
%%should start with the d0 for dose curves, and file can be expanded later
%%to include more doses

[Filelist,Pathname] = uigetfile('E:\\*.mat','File Selector','MultiSelect','on');
allData  = struct();
numFiles = numel(Filelist);
for iFile = 1:numFiles              % Loop over found files
    Data = load(fullfile(Pathname, Filelist{1,iFile}));
    Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error
    Fields = fieldnames(Data);
    for iField = 1:numel(Fields)              % Loop over fields of current file
        aField = Fields{iField};
        if isfield(allData, aField)             % Attach new data:
            allData.(aField)(end+1:end+numel(Data.(aField))) = Data.(aField); %Add new data to end of previous data
        else
            allData.(aField) = Data.(aField);
        end
    end
end

filename = input (prompt2);
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

[DataAnalysis choice] = cAPstat_2 (allData , filename, Pathname);
allcAPs = normalcAP_2 (allData , filename, Pathname , choice);


%Start to analyze other data sets fo the dose curve, extending the file
choice = questdlg('Add more doses to this set?','Add more doses?', ...
    'Yes Please','No Thank You','Yes Please');

while (strcmp(choice,'Yes Please'))
    [Filelist,Pathname] = uigetfile('E:\\*.mat','File Selector','MultiSelect','on');
    allData  = struct();
    numFiles = numel(Filelist);
for iFile = 1:numFiles              % Loop over found files
    Data = load(fullfile(Pathname, Filelist{1,iFile}));
    Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error
    Fields = fieldnames(Data);
    for iField = 1:numel(Fields)              % Loop over fields of current file
        aField = Fields{iField};
        if isfield(allData, aField)             % Attach new data:
            allData.(aField)(end+1:end+numel(Data.(aField))) = Data.(aField); %Add new data to end of previous data
        else
            allData.(aField) = Data.(aField);
        end
    end
end

[DataAnalysis choice] = cAPstat_2 (allData , filename, Pathname);
allcAPs = normalcAP_2 (allData , filename, Pathname , choice);

choice = questdlg('Add more doses to this set?','Add more doses?', ...
    'Yes Please','No Thank You','Yes Please');
end