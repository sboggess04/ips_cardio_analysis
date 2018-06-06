function [EAD , chopData] = EADdetect(AP)

%%EAD sorting of cut APs by Local Max detection
EAD{1} = [];
chopData{1} = [];
numEvents = length(AP);
for i= 1:numEvents
    y = AP{i,1};
    [LMax] = islocalmax(y , 'MaxNumExtrema' , 10 , 'MinProminence' , 1.5, 'MinSeparation', 80);
    Peaks = sum(LMax);
    if Peaks > 1
        if isempty(EAD{1,1}) == 1
            EAD{1,1} = y;
        elseif isempty(EAD{1,1}) == 0
            EAD{end+1,1} = y;
        end
    elseif Peaks == 1
        if isempty(chopData{1,1}) == 1
            chopData{1,1} = y;
        elseif isempty(chopData{1,1}) == 0
            chopData{end+1,1} = y;
        end
    end
end


end
    