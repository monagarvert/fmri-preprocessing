#!/bin/bash

cd /data/pt_02071/choice-maps/preprocessed_data/

FMRIPREP --version 1.4.0 fmriprep /data/p_02071/choice-maps/my_dataset/ /data/pt_02071/choice-maps/preprocessed_data/ participant --participant_label SUBJID --output-spaces T1w fsnative MNI152NLin6Asym fsaverage --no-freesurfer

# FMRIPREP --version 1.4.0 fmriprep /data/p_02071/choice-maps/my_dataset/ /data/pt_02071/choice-maps/preprocessed_data/ participant --participant_label SUBJID --output-spaces T1w fsnative MNI152NLin6Asym fsaverage --write-graph --stop-on-first-crash --notrack --verbose --resource-monitor

