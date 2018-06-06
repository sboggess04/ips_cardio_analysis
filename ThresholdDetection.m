function [cutdata, start1, end1] = ThresholdDetection( vector, UL, LL, Fs )
%ThresholdDetection( Vector, threshold ) Takes Vector parts above threshold
%   [ parts, starts, ends ] = ThresholdDetection( Vector, threshold )

%%Input Variables:
%Vector = corrData from apdCalc. This is the bleach corrected and filtered
%data vector
%threshold: hard-coded value passed from apdCalc, percentage of maximum
%value
%Fs: hardcoded value passed from getCardiacData, acq frequency

%Turn Fs into a time. We want about 60 ms (for now) before the ap crossed the threshold and 60 ms
%at the end %%note%% put this to 5000ms 05/7/2018 for analysis of extended
%aps. Seems ok at the front, but might consider splitting into 2 variables
%if the end of previous APs becomes included.
% apExtendEnd = (500*(Fs/1000)); %% 500 ms --> frames %% have the issue here with higher beating frequency, starts to include the next AP in the frame.
apExtendEnd = (50*(Fs/1000));
apExtendFront = (50*(Fs/1000));

%% find start and end points
% a=vector>=threshold; %%when above threshold, a=1, when below, a=0
% a=a(:);
% a=[0;a;0]; %converts to vector
% a=diff(a); %%Makes a mark of "1" when vector goes above threshold %%Makes a mark of "-1" when vector deflects below threshold(moves frame back one)
% starts=find(a==1);
% ends=find(a==-1)-1;
%%Below is new schmitt trigger script (draft)
Limit = 0 ;
N = length(vector);
y = [length(vector)];
for i=1:N
    if (Limit ==0) %%making terms for triggering
        y(i)=0;
    elseif (Limit == 1)
        y(i)=1;
    end
    
    if (vector(i)<=LL) %%searching through vector for points above/below
        Limit=0;
        y(i)=0;
    elseif (vector(i)>= UL)
        Limit=1;
        y(i)=1;
    end
end

y1=diff(y); %%Makes a mark of "1" when vector goes above threshold %%Makes a mark of "-1" when vector deflects below threshold(moves frame back one)
starts=find(y1==1) ;
ends=find(y1==-1)-1 ;

% figure
% plot(vector,'r','DisplayName','plot of vector'); hold on;
% plot(y,'blue','DisplayName','plot of y','LineWidth',2); hold on;
% plot(y1,'g','DisplayName','plot of y1','LineWidth',2); hold off;
% legend('show');

%%Problem with this for of "ends": if APD90 is hyperextended, you end up
%%cutting the AP too early, even with hard-coded extension
%with assumption that each AP will reach the baseline each time:
% bottom = min(vector)+3;
% b=vector>=bottom;
% b=b(:);
% b=[0;b;0];
% b=diff(b);
% ends2=find(b==-1)-1; %ends2 finds where the AP actually reaches the baseline again.

%move the start and end point of each event to capture whole event
start1=(starts - apExtendFront);
end1=(ends + apExtendEnd);

%%check for out of range events
firstEvent = 1;
lastEvent = length(ends); %orginally looked at the starts, trying using ends2 now
if isempty(end1) == 0
    if ends(1)<starts(1) %%if the trace start above UL, remove first end
        end1(1) = [] ;
        lastEvent = length(end1) ;
    end
    if (start1(1) < 0) %%this term is bogus for the schmitt trigger in current form
        firstEvent = firstEvent + 1; %if the trace starts in the middle of an event, that event is thrown out
    end
    if (length(end1)<length(start1))
        lastEvent = length(start1) - 1; %if there is an event that doesn't "end", at the end of a trace, it is thrown out
    end
    if (end1(end)>length(vector))
        lastEvent = lastEvent - 1; %if the end point for cutting is moved past the end of the original trace, the last event is thrown out
    end
    while start1(1) <= 0
        start1(1) = (start1(1) + 1);
    end
    
    eventsInRange = lastEvent - firstEvent + 1;
    
    %%Check if trace starts above threshold, get rid of 1st event
    %  if vector(1) > threshold
    
    
    %% cutting
    %Need to do some cleanup here
    cutdata={};
    for i = 1:eventsInRange
        if isempty (start1) == 0
            ap = vector(start1(i):end1(i));
            cutdata{length(cutdata)+1,1} = ap ;
           
        elseif isempty(start1) == 1  %Adds in a blank value if no APs are detected
                cutdata = [] ;
                start1 = [] ;
                end1 = [] ;
      
            end
    end
end

%     winlen = floor(150*(Fs/1000)); %length of window equals 150 ms time sampling rate (Fs)
%
%
%     for i=1:eventsInRange
%         try
%             ap = vector(start1(i+firstEvent-1):end1(i+firstEvent-1));
%             apTrue = 0;
%             for j = winlen:winlen:floor(length(ap)/winlen)*winlen-winlen
%                 if (min(ap(j:(j+winlen),1))>threshold)
%                     apTrue = 1;
%                 end
%             end
%             if apTrue>0
%                 cutdata{length(cutdata)+1,1}=vector(start1(i+firstEvent-1):end1(i+firstEvent-1));
%             end
%         catch ME
%             disp('Error occured in batch');
%         end
%     end
%
% else if isempty(end1) == 1  %Adds in a blank value if no APs are detected
%         cutdata = [] ;
%         start1 = [] ;
%         end1 = [] ;
%
%     end
% end
