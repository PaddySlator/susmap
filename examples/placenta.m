cluster=1;
if cluster
    DATADIR = '/cluster/project7/placenta-modelling-mri/network_meshes/NIFTI/';
    MAPDIR = '/cluster/project7/placenta-modelling-mri/mri-sims/';
else    
    DATADIR = '/Users/paddyslator/OneDrive - University College London/data/placenta-modelling-mri/network_meshes/NIFTI/';
    MAPDIR = '/Users/paddyslator/OneDrive - University College London/data/placenta-modelling-mri/network_meshes/output/maps/';
end

filepath = 'healthytree00001.nii.gz';
[~,strippedfilepath]=fileparts(filepath);
susmappath = strcat(MAPDIR,'susmap_',strippedfilepath);

interface='bloodtissue';
placentamap = mesh2fieldshift_FPM(strcat(DATADIR,filepath),interface);
placentamap = single(placentamap);
niftiwrite(placentamap,susmappath);

%%
%KCL echo times at 3T
TE = [13.81 70.40 127.00 183.60 240.2]*10^-3;

options.voxblur = [4 4 4];

[signalmap,~,~]= fieldshift2signal([susmappath '.nii'], TE, options);
signalmap = single(signalmap);
niftiwrite(signalmap,strcat(MAPDIR,'t2complexmap_', strippedfilepath));   
niftiwrite(abs(signalmap),strcat(MAPDIR,'t2map_', strippedfilepath));   



