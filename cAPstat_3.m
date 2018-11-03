function [cAPanalysis] = cAPstat_3 (allData,outputName,outputPath)

%%Take worked up data from apdCalc and combine for larger data sets
%%Define file path and outputname
%%Load the output file
fullOutputName = [outputPath outputName];
Data = load(fullOutputName);

%%load the data
apd30 = getfield(allData,'apd30');
apd50 = getfield(allData,'apd50');
apd90 = getfield(allData,'apd90');
cAPD30 = getfield(allData,'cAPD30');
cAPD50 = getfield(allData,'cAPD50');
cAPD90 = getfield(allData,'cAPD90');
FcAPD30 = getfield(allData,'FcAPD30');
FcAPD50 = getfield(allData,'FcAPD50');
FcAPD90 = getfield(allData,'FcAPD90');
BPM = getfield(allData,'BPM');
interEinter = getfield(allData,'interEinter');
chopData = getfield(allData, 'chopData');
SNR = getfield(allData, 'SNR');


if isfield (Data , 'avg_apd30') == 0   %%Check if data analysis file exists
    %%Allocate space to put incoming data not already present
    avg_apd30(1) = zeros(1);
    avg_apd50(1) = zeros(1);
    avg_apd90(1) = zeros(1);
    avg_cAPD30(1) = zeros(1);
    avg_cAPD50(1) = zeros(1);
    avg_cAPD90(1) = zeros(1);
    avg_FcAPD30(1) = zeros(1);
    avg_FcAPD50(1) = zeros(1);
    avg_FcAPD90(1) = zeros(1);
    avg_BPM(1) = zeros(1);
    avg_interEinter(1) = zeros(1);
     avg_SNR(1) = zeros(1);
    std_apd30(1) = zeros(1);
    std_apd50(1) = zeros(1);
    std_apd90(1) = zeros(1);
    std_cAPD30(1) = zeros(1);
    std_cAPD50(1) = zeros(1);
    std_cAPD90(1) = zeros(1);
    std_FcAPD30(1) = zeros(1);
    std_FcAPD50(1) = zeros(1);
    std_FcAPD90(1) = zeros(1);
    std_BPM(1) = zeros(1);
    std_interEinter(1) = zeros(1);
    std_SNR(1) = zeros(1);
    
    %Calculate mean and SD for each parameter
    avg_apd30 = mean(apd30);
    avg_apd50 = mean(apd50);
    avg_apd90 = mean(apd90);
    avg_cAPD30 = mean(cAPD30);
    avg_cAPD50 = mean(cAPD50);
    avg_cAPD90 = mean(cAPD90);
    avg_FcAPD30 = mean(FcAPD30);
    avg_FcAPD50 = mean(FcAPD50);
    avg_FcAPD90 = mean(FcAPD90);
    avg_BPM = mean(BPM);
    avg_interEinter = mean(interEinter);
    avg_SNR = mean(SNR);
    
    %Calculate standard deviations
    std_apd30 = std(apd30);
    std_apd50 = std(apd50);
    std_apd90 = std(apd90);
    std_cAPD30 = std(cAPD30);
    std_cAPD50 = std(cAPD50);
    std_cAPD90 = std(cAPD90);
    std_FcAPD30 = std(FcAPD30);
    std_FcAPD50 = std(FcAPD50);
    std_FcAPD90 = std(FcAPD90);
    std_BPM = std(BPM);
    std_interEinter = std(interEinter);
     std_SNR = std(SNR);
    
    %%save variables and traces before exit
    save(fullOutputName,'avg_apd30','-append');
    save(fullOutputName,'avg_apd90','-append');
    save(fullOutputName,'avg_apd50','-append');
    save(fullOutputName,'std_apd30','-append');
    save(fullOutputName,'std_apd50','-append');
    save(fullOutputName,'std_apd90','-append');
    save(fullOutputName,'apd30','-append');
    save(fullOutputName,'apd50','-append');
    save(fullOutputName,'apd90','-append');
    save(fullOutputName,'avg_cAPD30','-append');
    save(fullOutputName,'avg_cAPD50','-append');
    save(fullOutputName,'avg_cAPD90','-append');
    save(fullOutputName,'std_cAPD30','-append');
    save(fullOutputName,'std_cAPD50','-append');
    save(fullOutputName,'std_cAPD90','-append');
    save(fullOutputName,'avg_FcAPD30','-append');
    save(fullOutputName,'avg_FcAPD50','-append');
    save(fullOutputName,'avg_FcAPD90','-append');
    save(fullOutputName,'std_FcAPD30','-append');
    save(fullOutputName,'std_FcAPD50','-append');
    save(fullOutputName,'std_FcAPD90','-append');
    save(fullOutputName,'cAPD30','-append');
    save(fullOutputName,'cAPD50','-append');
    save(fullOutputName,'cAPD90','-append');
    save(fullOutputName,'FcAPD30','-append');
    save(fullOutputName,'FcAPD50','-append');
    save(fullOutputName,'FcAPD90','-append');
    save(fullOutputName,'avg_BPM','-append');
    save(fullOutputName,'avg_interEinter','-append');
    save(fullOutputName,'std_BPM','-append');
    save(fullOutputName,'std_interEinter','-append');
    save(fullOutputName,'BPM','-append');
    save(fullOutputName,'interEinter','-append');
      save(fullOutputName,'avg_SNR','-append');
    save(fullOutputName,'std_SNR','-append');
    
    %Create table of values
    stat = {'apd30' ; 'cAPD30' ; 'apd50' ; 'cAPD50' ; 'apd90' ; 'cAPD90' ; 'BPM' ; 'SNR'};
    Mean = {avg_apd30 ; avg_cAPD30 ; avg_apd50 ; avg_cAPD50 ; avg_apd90 ; avg_cAPD90 ; avg_BPM ; avg_SNR};
    Std = {std_apd30 ; std_cAPD30 ; std_apd50 ; std_cAPD50 ; std_apd90 ; std_cAPD90 ; std_BPM ; std_SNR};
    
    cAPanalysis = table (Mean , Std, ...
        'RowNames', stat);
    
    %Save table
    save (fullOutputName,'cAPanalysis','-append');
    
else
    %Load relevant fields out of growing dataset (DATA structure)
    avg_apd30 = getfield(Data,'avg_apd30');
    avg_apd50 = getfield(Data,'avg_apd50');
    avg_apd90 = getfield(Data,'avg_apd90');
    avg_cAPD30 = getfield(Data,'avg_cAPD30');
    avg_cAPD50 = getfield(Data,'avg_cAPD50');
    avg_cAPD90 = getfield(Data,'avg_cAPD90');
    avg_FcAPD30 = getfield(Data,'avg_FcAPD30');
    avg_FcAPD50 = getfield(Data,'avg_FcAPD50');
    avg_FcAPD90 = getfield(Data,'avg_FcAPD90');
    avg_BPM = getfield(Data,'avg_BPM');
    avg_interEinter = getfield(Data,'avg_interEinter');
      avg_SNR = getfield(Data,'avg_SNR');
    std_apd30 = getfield(Data,'std_apd30');
    std_apd50 = getfield(Data,'std_apd50');
    std_apd90 = getfield(Data,'std_apd90');
    std_cAPD30 = getfield(Data,'std_cAPD30');
    std_cAPD50 = getfield(Data,'std_cAPD50');
    std_cAPD90 = getfield(Data,'std_cAPD90');
    std_FcAPD30 = getfield(Data,'std_FcAPD30');
    std_FcAPD50 = getfield(Data,'std_FcAPD50');
    std_FcAPD90 = getfield(Data,'std_FcAPD90');
    std_BPM = getfield(Data,'std_BPM');
    std_interEinter = getfield(Data,'std_interEinter');
    std_SNR = getfield(Data,'std_SNR');
    
    
    %Calculate mean and SD for each parameter
    avg_apd30 = vertcat(avg_apd30 ,(mean(apd30))); %%vertcat adds the new mean value to the end of the file
    avg_apd50 = vertcat(avg_apd50 ,(mean(apd50)));
    avg_apd90 = vertcat(avg_apd90 ,(mean(apd90)));
    avg_cAPD30 = vertcat(avg_cAPD30 ,(mean(cAPD30)));
    avg_cAPD50 = vertcat(avg_cAPD50 ,(mean(cAPD50)));
    avg_cAPD90 = vertcat(avg_cAPD90 ,(mean(cAPD90)));
    avg_FcAPD30 = vertcat(avg_FcAPD30 ,(mean(FcAPD30)));
    avg_FcAPD50 = vertcat(avg_FcAPD50 ,(mean(FcAPD50)));
    avg_FcAPD90 = vertcat(avg_FcAPD90 ,(mean(FcAPD90)));
    avg_BPM = vertcat(avg_BPM ,(mean(BPM)));
    avg_interEinter = vertcat(avg_interEinter ,(mean(interEinter)));
     avg_SNR = vertcat(avg_SNR ,(mean(SNR)));
    
    %Calculate standard deviations
    std_apd30 = vertcat(std_apd30 ,(std(apd30)));
    std_apd50 = vertcat(std_apd50 ,(std(apd50)));
    std_apd90 = vertcat(std_apd90 ,(std(apd90)));
    std_cAPD30 = vertcat(std_cAPD30 ,(std(cAPD30)));
    std_cAPD50 = vertcat(std_cAPD50 ,(std(cAPD50)));
    std_cAPD90 = vertcat(std_cAPD90 ,(std(cAPD90)));
    std_FcAPD30 = vertcat(std_FcAPD30 ,(std(FcAPD30)));
    std_FcAPD50 = vertcat(std_FcAPD50 ,(std(FcAPD50)));
    std_FcAPD90 = vertcat(std_FcAPD90 ,(std(FcAPD90)));
    std_BPM = vertcat(std_BPM ,(std(BPM)));
    std_interEinter = vertcat(std_interEinter ,(std(interEinter)));
     std_SNR = vertcat(std_SNR ,(std(SNR)));
    
    %%save variables and traces before exit
    % outputPath = 'C:\Users\Steven Boggess\Documents\Miller Lab\Data\MATLAB\apd_stats\';
    % fullOutputName2 = [outputPath2 outputName2];
    save(fullOutputName,'avg_apd30','-append');
    save(fullOutputName,'avg_apd90','-append');
    save(fullOutputName,'avg_apd50','-append');
    save(fullOutputName,'std_apd30','-append');
    save(fullOutputName,'std_apd50','-append');
    save(fullOutputName,'std_apd90','-append');
    save(fullOutputName,'apd30','-append');
    save(fullOutputName,'apd50','-append');
    save(fullOutputName,'apd90','-append');
    save(fullOutputName,'avg_cAPD30','-append');
    save(fullOutputName,'avg_cAPD50','-append');
    save(fullOutputName,'avg_cAPD90','-append');
    save(fullOutputName,'std_cAPD30','-append');
    save(fullOutputName,'std_cAPD50','-append');
    save(fullOutputName,'std_cAPD90','-append');
    save(fullOutputName,'cAPD30','-append');
    save(fullOutputName,'cAPD50','-append');
    save(fullOutputName,'cAPD90','-append');
    save(fullOutputName,'avg_FcAPD30','-append');
    save(fullOutputName,'avg_FcAPD50','-append');
    save(fullOutputName,'avg_FcAPD90','-append');
    save(fullOutputName,'std_FcAPD30','-append');
    save(fullOutputName,'std_FcAPD50','-append');
    save(fullOutputName,'std_FcAPD90','-append');
    save(fullOutputName,'FcAPD30','-append');
    save(fullOutputName,'FcAPD50','-append');
    save(fullOutputName,'FcAPD90','-append');
    save(fullOutputName,'avg_BPM','-append');
    save(fullOutputName,'avg_interEinter','-append');
    save(fullOutputName,'std_BPM','-append');
    save(fullOutputName,'std_interEinter','-append');
    save(fullOutputName,'BPM','-append');
    save(fullOutputName,'interEinter','-append');
    save(fullOutputName,'avg_SNR','-append');
    save(fullOutputName,'std_SNR','-append');
    % save(fullOutputName,'actTime','-append');
    % save(fullOutputName,'dFoverF','-append');
    % save(fullOutputName,'SNR','-append');
    % save(fullOutputName,'upstrokeDuration','-append');
    % save(fullOutputName,'wholeData','-append');
    % save(fullOutputName,'smoothData','-append');
    % save(fullOutputName,'corrData','-append');
% %     save(fullOutputName,'chopData','-append');
    
    %Create table of values
    stat = {'apd30' ; 'cAPD30' ; 'apd50' ; 'cAPD50' ; 'apd90' ; 'cAPD90' ; 'BPM' ; 'SNR'};
    Mean = {avg_apd30 ; avg_cAPD30 ; avg_apd50 ; avg_cAPD50 ; avg_apd90 ; avg_cAPD90 ; avg_BPM ; avg_SNR};
    Std = {std_apd30 ; std_cAPD30 ; std_apd50 ; std_cAPD50 ; std_apd90 ; std_cAPD90 ; std_BPM ; std_SNR};
    
    cAPanalysis = table (Mean , Std, ...
        'RowNames', stat);
    
    %Save table and choice
    save (fullOutputName,'cAPanalysis','-append');
end
end