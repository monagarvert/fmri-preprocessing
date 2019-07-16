
#!/bin/bash
#
# Copyright (c) Mona Garvert 2019, MPI CBS


for subj in {105..104} 
do
   	 	echo Subject $subj
		
		# remove directory so it doesn't generate + directories

		mkdir -p /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/output
		mkdir -p /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts		
		
		cat /data/p_02071/choice-maps/scripts/preprocessing/run_fmriprep.sh | sed "s/SUBJID/${subj}/g" > /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-fmriprep_sub-${subj}.sh
		cat /data/p_02071/choice-maps/scripts/preprocessing/run-preprocessing | sed "s/SUBJID/${subj}/g" > /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-preprocessing_sub-${subj}
		
		chmod a+rwx /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-fmriprep_sub-${subj}.sh
		chmod a+rwx /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-preprocessing_sub-${subj}
		
		cd /data/pt_02071/choice-maps/preprocessed_data/
		condor_submit /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-preprocessing_sub-${subj}
done


