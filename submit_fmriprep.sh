
#!/bin/bash
#
# Copyright (c) Mona Garvert 2019, MPI CBS


for subj in {145..152};
do
   	 	echo Subject $subj
		
		# remove existing directories so it doesn't generate + directories
		rm -rf /data/pt_02071/choice-maps/preprocessed_data/work/fmriprep_wf/single_subject_${subj}_wf 
		rm -rf /data/pt_02071/choice-maps/preprocessed_data/work/reportlets/fmriprep/sub-${subj} 
		rm -rf /data/pt_02071/choice-maps/preprocessed_data/freesurfer/sub-${subj}
		rm -rf /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}
		rm -rf /data/pt_02071/choice-maps/preprocessed_data/fmriprep/sub-${subj}
		rm -rf /data/pt_02071/choice-maps/preprocessed_data/fmriprep/sub-${subj}.html


		mkdir -p /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/output
		mkdir -p /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts		
		
		cat /data/p_02071/choice-maps/scripts/preprocessing/run_fmriprep.sh | sed "s/SUBJID/${subj}/g" > /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-fmriprep_sub-${subj}.sh
		cat /data/p_02071/choice-maps/scripts/preprocessing/run-preprocessing | sed "s/SUBJID/${subj}/g" > /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-preprocessing_sub-${subj}
		
		chmod a+rwx /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-fmriprep_sub-${subj}.sh
		chmod a+rwx /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-preprocessing_sub-${subj}
		
		cd /data/pt_02071/choice-maps/preprocessed_data/
		condor_submit /data/pt_02071/choice-maps/preprocessed_data/sub-${subj}/scripts/run-preprocessing_sub-${subj}
done


