DATADIR  = '/Users/paddyslator/OneDrive - University College London/data/cmic-hacks-ucl/lungCT/LIDC-IDRI_ISBI2020/airway/';

MAPDIR = '/Users/paddyslator/OneDrive - University College London/data/cmic-hacks-ucl/susmaps/';

filepaths = dir(strcat(DATADIR, 'LIDC-IDRI*'));

%strength of the main magnetic field
%options.B0 = 3;

interface='airtissue';
for i=1:length(filepaths) 
    lungmap = mesh2fieldshift_FPM(strcat(DATADIR,filepaths(i).name),interface);
    lungmap = single(lungmap);
    niftiwrite(lungmap,strcat(MAPDIR,'susmap',remove_ext_from_nifti(filepaths(i).name)));
end
     
%% 
% TE = [0.01 0.03 0.05 0.07 0.09 0.12 0.2 0.3 0.4 0.5 0.7];
TE = [0.01 0.03 0.05 0.07 0.09 0.12];
% [signal,signalall,phaseshift]= fieldshift2signal(lungmap, TE);

susmappaths = dir(strcat(MAPDIR, 'susmapLIDC-IDRI*'));

options.voxblur = [4 4 4];
for i=4:length(filepaths) 
    [signalmap,~,~]= fieldshift2signal(strcat(MAPDIR, susmappaths(i).name), TE, options);
    signalmap = single(signalmap);
    niftiwrite(signalmap,strcat(MAPDIR,'t2complexmap',remove_ext_from_nifti(susmappaths(i).name)));   
    niftiwrite(abs(signalmap),strcat(MAPDIR,'t2map',remove_ext_from_nifti(susmappaths(i).name)));   
    disp(['done ' num2str(i) ': ' susmappaths(i).name])
end




%%
figure;hold on;
for i=1:size(lungmap,1)
imagesc(squeeze(lungmap(i,:,:)))
pause(0.02)
end


%load the nifti info for saving as nifti
%niftiheader = niftiinfo(strcat(DATADIR,filepaths(i).name));
%update the volume size
%niftiheader.ImageSize = size(lungmap);
%niftiheader.raw.dim(2:4) = size(lungmap);
%save as nifti
%niftiwrite(lungmap,strcat(MAPDIR,'susmap',filepaths(i).name),niftiheader);


% ...for i=1:length(filepaths)       
% ...    mesh2fieldshift_FPM(strcat(DATADIR,filepaths.name), options);
% ...end