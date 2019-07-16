#!/bin/bash

subj=125
session=3
physiofile=VAAT190705



niidir=/data/p_02071/choice-maps/my_dataset

mkdir ${niidir}/sub-${subj}/ses-${session}/physio
scp /scr/mrincoming/PHYSLOGDATA/CHOICE_MAPS/${physiofile}/* ${niidir}/sub-${subj}/ses-${session}/physio



# remove directory so it doesn't generate + directories

mkdir -p /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/

cp  /data/p_02071/choice-maps/scripts/preprocessing/extract_physio.m /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/extract_physio_sub_${subj}_ses_${session}.m

for run in {1..4}; 
	do

	dir=/data/p_02071/choice-maps/my_dataset/sub-${subj}/ses-${session}/func

	if [[ $session -eq 2 ]]; then

		echo $dir/sub-${subj}_ses-${session}_task-object_run-0${run}_bold.nii.gz 			
		nvols=`fslnvols $dir/sub-${subj}_ses-${session}_task-object_run-0${run}_bold.nii.gz`
		echo $nvols

	else
		if [[ $run -eq 1 ]]; then
			echo $dir/sub-${subj}_ses-${session}_task-choice_bold.nii.gz		
			nvols=`fslnvols $dir/sub-${subj}_ses-${session}_task-choice_bold.nii.gz`
		else
			echo $dir/sub-${subj}_ses-${session}_task-object_run-0$[${run}-1]_bold.nii.gz	
			nvols=`fslnvols $dir/sub-${subj}_ses-${session}_task-object_run-0$[${run}-1]_bold.nii.gz`
		fi
		echo $nvols
	fi
	
	sed -i -e "s/SUBJID/${subj}/g" /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/extract_physio_sub_${subj}_ses_${session}.m
	sed -i -e "s/NSESSION/${session}/g" /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/extract_physio_sub_${subj}_ses_${session}.m
	sed -i -e "s/NVOL${run}/${nvols}/g" /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/extract_physio_sub_${subj}_ses_${session}.m
done
chmod a+rwx /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/extract_physio_sub_${subj}_ses_${session}.m

