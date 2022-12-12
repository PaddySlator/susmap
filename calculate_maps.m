function [susmap, signalmap] = calculate_maps(filepath, varargin)
%Calculate susceptibility and T2* maps from synthetic placental structures
%
%
%Inputs:
%       filepath: binary mask in nifti format or mesh in stl format
%       varargin:
%		1. cluster flag: 0 if running locally, 1 if running on cluster
%               2. MAPDIR. Specify a directory path to save the output maps to. If
%               not specified will save in the default cluster location
% 
%
%Paddy Slator p.slator@ucl.ac.uk
%


%DATADIR = '/cluster/project7/placenta-modelling-mri/network_meshes/NIFTI/';
if nargin == 1
    %default option is cluster
    cluster_flag=1;
elseif nargin == 2
    cluster_flag = varargin{1};
elseif nargin > 2
    MAPDIR = varargin{2};
end

%default save locations
if nargin <= 2
    if cluster_flag
        MAPDIR = '/cluster/project7/placenta-modelling-mri/mri-sims/';
    else
        MAPDIR = '/Users/paddyslator/OneDrive - University College London/data/placenta-modelling-mri/network_meshes/output/maps/';
    end
end

%add code to the path
if cluster_flag
    addpath(genpath('/cluster/project7/placenta-modelling-mri/code/MATLAB'))
else
    addpath(genpath('/Users/paddyslator/MATLAB/'))
end


%get the filename from the full path
[~,filename]=fileparts(filepath);
%path to save the susceptibility map
susmappath = strcat(MAPDIR,'/susmap_',filename);
%path to save the complex T2* map
t2complexpath = strcat(MAPDIR,'/t2complexmap_', filename);
%path to save the magnitude T2* map
t2path = strcat(MAPDIR,'/t2map_', filename);

%some fixed options
%TO DO - add to varargin
%interface - blood inside vessels and tissue outside
interface='bloodtissue';
%KCL echo times at 3T
TE = [13.81 70.40 127.00 183.60 240.2]*10^-3;
%blurring between susceptibility map and T2* map
options.voxblur = [4 4 4];

%calculate and save the susceptibility map
susmap = mesh2fieldshift_FPM(filepath,interface);
susmap = single(susmap);
niftiwrite(susmap,susmappath);

%calculate and save the T2* maps
[signalmap,~,~]= fieldshift2signal([susmappath '.nii'], TE, options);
signalmap = single(signalmap);
niftiwrite(signalmap, t2complexpath);
niftiwrite(abs(signalmap),t2path);


end
