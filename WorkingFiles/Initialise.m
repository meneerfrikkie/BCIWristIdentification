% add necessary paths for eeglab, eelab subfolders and netlab toolbox 
function [BaseDirectory, Endcharacter] = Initialise(OS)

[BaseDirectory, Endcharacter] = SetupDir(OS);
disp(['Base Diretory setup for: ', OS]);

if strcmp(OS, 'win')
    
    addpath(pathdef_WIN);
    disp('Pathways defined for use with windows')
    
elseif strcmp(OS, 'mac')

    addpath(pathdef_MAC);
    disp('Pathways defined for use with Mac')
    
else
    disp('ERROR is input of operating system. Enter either win or mac')
end




% Problem 23 Nov 2018 - basedirectory var is not showing up