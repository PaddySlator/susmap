function delta_chi = calculate_delta_chi(interface,options)

%allowed interfaces
allowed_interfaces = {'bloodtissue','airtissue'};

%make sure input is character array
interface = char(interface);

%check if 

if strcmp(interface,'bloodtissue')
    %define the hematocrit fraction
    options.HCT = 0.5;
    %magnetic susceptibilty of deoxyhaemaglobin is 2.26 ppm
    options.X_dHb = 2.26 * 10^-6;
    %Fractional oxygenation
    options.Y = 0.95;
    %difference in magnetic susceptibility between vessel and tissue
    deltaChi = options.HCT * (1 - options.Y) * options.X_dHb;
    
    % deltaChi_Blood/Tissue value from Pathak et al.
    % deltaChi = 3 * 10^-8;
elseif strcmp(interface,'airtissue')



else
    error(strcat('interface: ' interface ' not recognised!'))
end

