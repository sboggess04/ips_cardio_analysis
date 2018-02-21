function [traceAnalysis] = normalcAP_2 (allData , outputName , outputPath , choice)
%%normalization and plotting of worked up cardiac data

%%load the data
if (strcmp(choice,'No Thank You'))
    cAPtraces = getfield(allData,'chopData');
    %%1st run-through of data set
    %%rename and define variables
    A = cAPtraces;
    numEvents = length(A);
    normcAP = cell(numEvents,1);
    
    k = 1;
    %normalize each cAP in array to 1, store data
    for i= 1:numEvents
        normalcAP = A{i} ;%load relevant cAP
        minimum = min(A{i,1});
        maximum = max(A{i,1});
        difference = maximum-minimum;
        normcAP{i} = (normalcAP-minimum)./difference;
        k = k + 1 ;
    end
    
    %calculate and plot avg normalized cAP
    n = max(cellfun(@(x) size(x,1),normcAP));
    fillcAP_Data = cellfun(@(x) [x;zeros(n-size(x,1),1)],normcAP,'un',0);
    meancAP = mean(cat(3,fillcAP_Data{:}),3);
    
    %%save variables and traces before exit
    fullOutputName = [outputPath outputName];
    save(fullOutputName,'normcAP','-append');
    save(fullOutputName,'meancAP','-append');
    
    %define output
    traceAnalysis = meancAP;
    
else
    [Filelist2,Pathname2] = uigetfile('F:\\*.mat','Select growing data set','MultiSelect','off');
    Data = load(fullfile(Pathname2, Filelist2));
    cAPtraces = getfield(allData,'chopData');
    %     cAPtraces = getfield(Data,'chopData');
    normcAP = getfield(Data,'normcAP');
    meancAP = getfield(Data, 'meancAP');
    %%Each subsequent run-through will add to selected data set. Need to
    %%optimize the file selection more...
    
    %%rename and define variables. Have to make a new array each time for
    %%normcAP and new vector for meancAP in order to add as a new column to the
    %%growing data set
    A = cAPtraces;
    numEvents = length(A);
    normcAP_N = cell(numEvents,1);
    
    k = 1;
    %normalize each cAP in array to 1, store data
    for i= 1:numEvents
        normalcAP_N = A{i} ;%load relevant cAP
        minimum = min(A{i,1});
        maximum = max(A{i,1});
        difference = maximum-minimum;
        normcAP_N{i} = (normalcAP_N-minimum)./difference;
        k = k + 1 ;
    end
    
    %calculate and plot avg normalized cAP
    n = max(cellfun(@(x) size(x,1),normcAP_N));
    fillcAP_Data = cellfun(@(x) [x;zeros(n-size(x,1),1)],normcAP_N,'un',0);
    
    %%With the normalized data from this set (normcAP_N), add it as a new
    %%column to dataset normcAP cell array. To do this, we must make sure
    %%our two matricies are the same height.
    %check lengths of both matricies:
    sizeNorm = size(normcAP , 1);
    sizeNorm_N = size(normcAP_N , 1);
    XsizeNorm = size (normcAP , 2);
    
    if sizeNorm == sizeNorm_N
        normcAP = horzcat (normcAP,normcAP_N);
        
    elseif sizeNorm > sizeNorm_N
        size_diff = (sizeNorm - sizeNorm_N);
        temp_cell = cell(size_diff , 1 , 1);
        normcAP_N = vertcat(normcAP_N , temp_cell);
        normcAP = horzcat (normcAP , normcAP_N);
        
    elseif sizeNorm < sizeNorm_N
        size_diff = (sizeNorm_N - sizeNorm);
        temp_cell = cell(size_diff , XsizeNorm , 1);
        normcAP = vertcat(normcAP , temp_cell);
        normcAP = horzcat (normcAP , normcAP_N);
    else
    end
    
    %%Go through the same process with meancAP
    meancAP_N = mean(cat(3,fillcAP_Data{:}),3);
    sizeMean = size(meancAP,1);
    sizeMean_N = size(meancAP_N,1);
    XsizeMean = size(meancAP,2);
    
    if sizeMean == sizeMean_N
        meancAP = horzcat (meancAP , meancAP_N);
    elseif sizeMean > sizeMean_N
        size_diffMean = (sizeMean - sizeMean_N);
        temp_vect = zeros(size_diffMean , 1);
        meancAP_N = vertcat(meancAP_N , temp_vect);
        meancAP = horzcat(meancAP , meancAP_N);
    elseif sizeMean < sizeMean_N
        size_diffMean = (sizeMean_N - sizeMean);
        temp_vect = zeros(size_diffMean , XsizeMean , 1);
        meancAP = vertcat(meancAP , temp_vect);
        meancAP = horzcat(meancAP , meancAP_N);
    else
    end
    
end

%%save variables and traces before exit
fullOutputName = [outputPath outputName];
save(fullOutputName,'normcAP','-append');
save(fullOutputName,'meancAP','-append');

%define output
traceAnalysis = meancAP;
end


