#!/bin/zsh

#  calculate_maps.sh
#  
#  Calculate susceptibility and T2* maps for given binary mask or mesh 
#
#  Created by Paddy Slator on 08/12/2022.
# 


# To run locally: calculate_maps.sh filepath 0
# To run on cluster: qsub calculate_maps.sh filepath 1
#$ -S /bin/bash
#$ -l h_vmem=16G
#$ -l tmem=16G
#$ -l h_rt=2:05:00
#$ -cwd
#$ -j y	
#$ -N calculatemaps
#$ -e errorfile
#$ -pe smp 1

calculate_maps.sh(){	
    #make sure some important locations are on the matlab path
	paths='~/cluster/project7/placenta-modelling-mri/code'	
	export MATLABPATH=$paths
	
	date
	hostname
    
	#check if there is a log_files directory, if not create it
	if [[ ! -d "log_files" ]]
	then
   		mkdir log_files	
	fi

    #get the filepath
    filepath=$1
	#make sure it's a string
	filepath="'$filepath'"
	
    echo $filepath

	#get the cluster flag
	cluster_flag=$2

	echo $cluster_flag

	if [ $cluster_flag -eq 0 ]
	then
    	/Applications/MATLAB_R2022a.app/bin/matlab -singleCompThread -nodisplay -nodesktop -batch "disp('hi');calculate_maps($filepath,$cluster_flag);exit" > log_files/calculate_maps-$(date "+%F-%T").log	
	else	
		/share/apps/matlabR2018b/bin/matlab -singleCompThread -nodisplay -nodesktop -batch "disp('hi');calculate_maps($filepath,$cluster_flag);exit" > log_files/calculate_maps-$(date "+%F-%T").log
	fi
	

}

calculate_maps.sh $*






