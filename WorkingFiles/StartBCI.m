if ispc
    % For Windows
    [BaseDir, endchar] = Initialise('win');
    
elseif ismac
    % For macOS
    [BaseDir, endchar] = Initialise('mac');
    
elseif isunix
    % For Unix-based systems (including Linux)
     % For macOS
     [BaseDir, endchar] = Initialise('mac');
    
else
    % For other operating systems
    disp('ERROR: Unsupported operating system. This script is designed for Windows or macOS only.');
end
