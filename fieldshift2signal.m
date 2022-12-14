function [signalmap,signalall,phaseshift] = fieldshift2signal(susmapinput, TE, options)

%options.voxelblur is the number of voxels to blur over
%e.g. if susmap voxel size is 0.5 mm^3 and options.voxelblur is [4 4 4]
%then output T2* map voxel sizes will be 2 mm^3


%check if the input is a nifti (binary mask)
if endsWith(susmapinput,'.nii.gz') || endsWith(susmapinput,'.nii')
    inputtype = 'nii';
elseif ~isstring(susmapinput) %just assume it's an array
    inputtype = 'array';
else
    error('Incorrect input type! Input should be array, .nii, or .nii.gz')
end

%load and preprocess the input filename
if strcmp(inputtype,'nii')
    %load the field shift map mask and metadata
    susmapinfo = niftiinfo(susmapinput);
    susmap = niftiread(susmapinput);
    disp(['loaded the susceptibility map from nifti file: ' susmapinput]) 
end

GAMMA = 267.5e06;

%GAMMA = 267.5;

%get the size of the field shift map
nvoxx = size(susmap,1);
nvoxy = size(susmap,2);
nvoxz = size(susmap,3);
%number of echo times
nTE = length(TE);
voxblur = options.voxblur;

%preallocate arrays
phaseshift = zeros(nvoxx, nvoxy, nvoxz, nTE);
signalall = zeros(nvoxx, nvoxy, nvoxz, nTE);

for t=1:nTE
    %calculate the phase shift
    phaseshift(:,:,:,t) = GAMMA * susmap * TE(t);
    %calculate the signal over all voxels in the field shift map
    signalall(:,:,:,t) = exp(1i * phaseshift(:,:,:,t));
end

%options.voxblur = 
%unpack options
%if no voxel blur specified - return the average over the whole susmap
if ~isfield(options,'voxblur')
    %average the signal in the imaging voxels
    signalmap = squeeze(sum(signalall,[1 2 3]));    
else
    voxblur = options.voxblur;
    %blur the signal map for each TE 
    signalmap = zeros(ceil(nvoxx./voxblur(1)),ceil(nvoxy/voxblur(2)),ceil(nvoxz/voxblur(3)), nTE);
    
    for i=1:nTE
        signalmap(:,:,:,i) = imresize3(signalall(:,:,:,i),[ceil(nvoxx./voxblur(1)) ceil(nvoxy/voxblur(2)) ceil(nvoxz/voxblur(3))]);
    end

%     %initialise the signal map FOR NOW, JUST ROUND DOWN IF NVOX DOESN'T DIVIDE VOXBLUR  
%     signalmap = zeros(floor(nvoxx/voxblur(1)),floor(nvoxy/voxblur(2)),floor(nvoxz/voxblur(3)),nTE);
%     %loop over voxels in the signal map
%     for x=1:floor(nvoxx/voxblur(1))
%         for y=1:floor(nvoxy/voxblur(2))
%             for z=floor(nvoxz/voxblur(3))
%                 %get the subarray indicies
%                 xi = (1 + voxblur(1)*(x-1)):(voxblur(1)*x);
%                 yi = (1 + voxblur(2)*(y-1)):(voxblur(2)*y);
%                 zi = (1 + voxblur(3)*(z-1)):(voxblur(3)*z);            
%                 %get the subarray of the signal map
%                 subsusmap = signalall(xi,yi,zi,:);
%                 %mean of this subarray
%                 signalmap(x,y,z,:) = squeeze(mean(subsusmap,[1 2 3]));
%             end
%         end
%     end
end
       
% if options.saveon %save the output as nifti
% 
% end





end