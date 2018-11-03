
function [corrected] = CorrectBleach(y)

%make a variable y or another name in the work space
%copy and paste values to be bleach corrected into y

%n is the total number of values in y i.e frames
n = length(y);
x(:, 1) = 1:1:n ;
%time is given in sec multiple x by your exp time in sec
time = x * 0.004;

for lambda = [1e3 1e4 1e5 1e6 1e7 1e8 1e9]
    for p = [1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8]
        %   asymmLSF(y, lambda, p) spits out bleach correction
        bleach_correction = asymmtLSF(y, lambda, p);
        
        %makes plots of y, bleach correction and bleach corrected traces
        figTitle = ['Lambda: ', num2str(lambda,'%1.0e'), ' p: ', num2str(p,'%1.0e')];
        f1 = figure('NumberTitle', 'off', 'Name', figTitle);
        subplot(2,2,1)
        plot(time, y)
        title('Raw Data')
        
        subplot(2,2,2)
        plot(time, bleach_correction)
        title('Bleach Correction')
        
        subplot(2,2,3)
        plot(time, y, time,bleach_correction)
        title('Raw Data & Bleach Correction')
        
        subplot(2,2,4)
        corrected = y - bleach_correction;
        plot (time, corrected)
        title ('Bleach Corrected data')
        
        filename = ['Lambda_', num2str(lambda,'%1.0e'), ' p_', num2str(p,'%1.0e')];
        saveas(f1,filename);
        save(filename,'corrected');
        save(filename,'bleach_correction','-append');
        save(filename,'f1','-append');
        
    end
end

end
