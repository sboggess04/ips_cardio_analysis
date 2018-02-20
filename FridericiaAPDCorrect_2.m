function [] = FridericiaAPDCorrect_2()
%Do a correction for each avg APD value calculated for a file. Saves the
%cAPD (F_cAPD) to each individual file.
[Filelist,Pathname] = uigetfile('C:\Users\Steven Boggess\Documents\Miller Lab\Data\*.mat','Select files to correct','MultiSelect','on');

%Define variables
allAvg_apd30 = zeros(1);
allAvg_apd50 = zeros(1);
allAvg_apd90 = zeros(1);
allCL = zeros(1);
allstd_apd30 = zeros(1);
allstd_apd50 = zeros(1);
allstd_apd90 = zeros(1);

for q = 1:length(Filelist)
    %do your shenanigans
    Data = load(fullfile(Pathname, Filelist{1,q}));
    Fields = fieldnames(Data);
    
    for iField = 1:numel(Fields)              % Loop over fields of current file
        aField = Fields{iField};
        switch (aField)
            case 'cAP_Data'
                Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error. might need to move this around
            case 'apd30'
                apd30 = Data.(aField);
            case 'apd50'
                apd50 = Data.(aField);
            case 'apd90'
                apd90 = Data.(aField);
            case 'BPM'
                BPM = Data.(aField);
        end
    end
    %Taking values from file in current loop, calculate CL and APD values.
    %plot these values
    %Calculate mean APD
    avg_apd30 = mean(apd30);
    avg_apd50 = mean(apd50);
    avg_apd90 = mean(apd90);
    
    %Calculate standard deviations
    std_apd30 = std(apd30);
    std_apd50 = std(apd50);
    std_apd90 = std(apd90);
    
    %Calculate Cycle Length (CL)
    CL = 60/(BPM);
        
    %Insert and combine values
    if   (allAvg_apd50(1,1) == 0)
        allAvg_apd30 = avg_apd30;
        allAvg_apd50 = avg_apd50;
        allAvg_apd90 = avg_apd90;
        allCL = CL;
        allstd_apd30 = std_apd30;
        allstd_apd50 = std_apd50;
        allstd_apd90 = std_apd90;
    else
        allAvg_apd30(end+1) = avg_apd30;
        allAvg_apd50(end+1) = avg_apd50;
        allAvg_apd90(end+1) = avg_apd90;
        allCL(end+1) = CL;
        allstd_apd30(end+1) = std_apd30;
        allstd_apd50(end+1) = std_apd50;
        allstd_apd90(end+1) = std_apd90;
    end
    
            %Correct each apd value in the current file
    %Now find FcAPD50 values
    FcAPD50 = zeros(length(apd50),1);
    
    for j = 1:length(apd50)
        FcAPD50(j) = (apd50(j)/((CL)^(1/3))) ;
    end
    
    %Now find FcAPD90 values
    FcAPD90 = zeros(length(apd90),1);
    
    for k = 1:length(apd90)
        FcAPD90(k) = (apd90(k)/((CL)^(1/3))) ;
    end
    
    %Now find FcAPD30 values
    FcAPD30 = zeros(length(apd30),1);
    
    for kk = 1:length(apd30)
        FcAPD30(kk) = (apd30(kk)/((CL)^(1/3)));
    end
    %append the calculated cAPD values to the current file
    currentFileName = [Pathname Filelist{1,q}];
    save(currentFileName,'FcAPD30','-append');
    save(currentFileName,'FcAPD50','-append');
    save(currentFileName,'FcAPD90','-append');

end
end
%end of file loop. From here, everything is one file of mean corrected values


%Plot values
% 
% allAvg_apd90 = allAvg_apd90.';
% allAvg_apd50 = allAvg_apd50.';
% allAvg_apd30 = allAvg_apd30.';
% allCL = allCL.';
% 
% figure('name','cAPD data','numbertitle','off');
% subplot(3,1,2);
% hold on;
% title('APD50');
% xlabel('Cycle Length');
% ylabel('APD50(ms)');
% scatter(allCL , allAvg_apd50 , 'r' , 's' , 'filled');
% %     plot(NallCL , polyval(polyAPD50,NallCL), '--'); %plot the line of best fit
% scatter(allCL , cAPD50,'o','o','filled'); %plot corrected values
% legend('Data' , 'Linear fit' , 'Corrected Data' ,'Location' , 'best');
% 
% subplot(3,1,3);
% hold on;
% title('APD90');
% xlabel('Cycle Length');
% ylabel('APD90(ms)');
% scatter(allCL , allAvg_apd90 , 'b' , 's' , 'filled');
% %     plot(NallCL , polyval(polyAPD90,NallCL), '--');  %plot the line of best fit
% scatter(allCL , cAPD90,'m','o','filled');
% legend('Data','Linear fit' , 'Corrected Data','Location','best');
% 
% subplot(3,1,1);
% hold on;
% title('APD30');
% xlabel('Cycle Length');
% ylabel('APD30(ms)');
% scatter(allCL , allAvg_apd30 , 'b' , 's' , 'filled');
% %     plot(NallCL , polyval(polyAPD90,NallCL), '--');  %plot the line of best fit
% scatter(allCL , cAPD30,'m','o','filled');
% legend('Data','Linear fit' , 'Corrected Data','Location','best');
% 
% %Save the corrected data to input file
% outputName = input('provide output name for all corrected values  ');
% fullOutputName = [Pathname outputName];

%Not saving the avg cAPD values for now, may replace depending on how
%data analysis flow works
%     save(fullOutputName,'NallCL');
%     save(fullOutputName,'NAPD50c','-append');
%     save(fullOutputName,'NAPD90c','-append');
%
%Save figure, can come back and check for fit later
% saveas(gcf,fullOutputName,'pdf'); %save as a pdf
% saveas(gcf,fullOutputName); %save as matlab fig