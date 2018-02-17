function[] = combValue()

%%Combine a APDS values from a .mat file and normalize to the vehicle value
%%
%select .mat files generated from apdCalc to combine and analyze
[Filelist,Pathname] = uigetfile('Z:\Steven\Data\Jessie\*.mat','File Selector','MultiSelect','on');
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

%%load the data
all_cAPD90 = getfield(allData,'cAPD90');

%%Find mean value (if vehicle). Normalize data to mean value
choice = questdlg('Is this the vehicle?','Query', ...
    'Yes','No','No');

if (strcmp(choice,'Yes'))
    vehicleMeanAPD90 = mean(all_cAPD90);
    normalcAPD90 = ((all_cAPD90)./vehicleMeanAPD90);
    meanNormalcAPD90 = mean(normalcAPD90);
    std_allcAPD90 = std(all_cAPD90);
    std_normalcAPD90 = std(normalcAPD90);
    
    
else if (strcmp(choice,'No'))
        meanVehiclecAPD90 = input('What is the mean vehicle cAPD90?   ');
        normalcAPD90 = ((all_cAPD90)./meanVehiclecAPD90);
        meanNormalcAPD90 = mean(normalcAPD90);
        std_allcAPD90 = std(all_cAPD90);
        std_normalcAPD90 = std(normalcAPD90);
        
    end
end
end