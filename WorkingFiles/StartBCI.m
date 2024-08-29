if ispc
    % For Windows
    [BaseDir, endchar] = Initialise('win');
    
elseif ismac
    % For macOS
    [BaseDir, endchar] = Initialise('mac');
    
else
    % For other operating systems (e.g., Linux)
    disp('ERROR: Unsupported operating system. This script is designed for Windows or macOS only.');
end
