function [] = getCardiacData ()

%% REMEMBER TO SET CORRECT FS!!!
%User input variables
Fs = 1000/400 ; %sampling rate (in Hz or fps)
UL = 0.45 ; %Up
LL = 0.1 ;
tic

%%Hopefully this wrapper script will allow for user to select folders
%%containing tiff stacks of CM data to analyze, then run through specific
%%cAP data scripts to analyzed APD, risetime, etc.

%Author: Steven Boggess (sboggess@berkeley.edu)
%%Thanks to Julia and Ben for their guidance and support~

%%Input variables to change:
%% Find FS to set the aqc frequency. All tiff stacks must be of the same frequency to work with this current configuration
if ispc
    %Get all tif filenames from a selected folder
    folder_name = uigetdir('C:\Users\Steven Boggess\Documents\Miller Lab\Data\', 'Select Folder Containing Tiff Stacks to Analyze');
    f = rdir ([folder_name,'\**\*.tif']);% Will search all subfolders as well.
elseif ismac
    folder_name = uigetdir('/**/', 'Select Folder Containing Tiff Stacks to Analyze');
    f = rdir ([folder_name,'/**/*.tif']);% Will search all subfolders as well.
else
    disp('Platform not supported');
end

filenames = {f.name}; %tif filenames collected

disp(folder_name);

tifStacks = cell(numel(filenames),1);
for i=1:numel(filenames)
    if strfind(filenames{i} , 'KCL')
        tiffname = fullfile(filenames{i});
        [pathstr,name,ext] = fileparts(filenames{i});
        filename = name;
        disp (tiffname); %Show the file you are working with
        tifStacks = apdCalc(Fs, UL, LL, tiffname, filename, folder_name);
    else if strfind(filenames{i} , 'fvf2')
            tiffname = fullfile(filenames{i});
            [pathstr,name,ext] = fileparts(filenames{i});
            filename = name;
            disp (tiffname); %Show the file you are working with
            tifStacks = apdCalc(Fs, UL, LL, tiffname, filename,folder_name);
        else if strfind(filenames{i} , 'std')
                tiffname = fullfile(filenames{i});
                [pathstr,name,ext] = fileparts(filenames{i});
                filename = name;
                disp (tiffname); %Show the file you are working with
                tifStacks = apdCalc(Fs, UL, LL, tiffname, filename,folder_name);
            else
                disp ('not a vm trace');
            end
        end
        
    end
    
end
fprintf(['While it is always best to believe in one�s self, \n' ...
    ' a little help from others can be a great blessing. --Iroh  \n' ...
    '   ']);

toc
end
