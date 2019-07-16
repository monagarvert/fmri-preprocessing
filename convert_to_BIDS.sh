## Convert imaging data into BIDS format
# (c) Mona Garvert
#
# June 2019 MPI CBS 

set -e 
# Variables to change for every data set. triplecheck to make sure these are correct!
subj=125 # edit
session=3 # edit
ecmdir=/scr/mrincoming/33956.5c_20190705_114330.SKYRA # edit
choiceNo=6 #edit
objScanNo=(7 10 11) # edit
# if session 2:
separateAnatScan=0  # edit 	1:true, 0:false
anatfile= #31331.0c/31331.0c_190228_104042_S3_MPRAGE_ADNI_WE_p2

#29121.94/29121.94_180926_113130_S12_t1_mprage_ADNI_32Ch # 32059.82/32059.82_180109_074024_S9_t1_MPRAGE_ADNI_32 #31208.b5_180216_090704_S43_t1_mprage_ADNI_32Ch_fc   # edit


####Defining pathways
niidir=/data/p_02071/choice-maps/my_dataset
#jo -p "Name"="Choice Maps experiment - Multiband Imaging Test-Retest Dataset" "BIDSVersion"="1.0.2" >> ${niidir}/dataset_description.json

####Anatomical Organization####
echo "Processing subject $subj"

###Change directory to subject folder
mkdir -p ${niidir}/sub-${subj}/ses-${session}/temp
cd ${niidir}/sub-${subj}/ses-${session}/temp

mkdir ${niidir}/sub-${subj}/ses-${session}/anat
mkdir ${niidir}/sub-${subj}/ses-${session}/func
mkdir ${niidir}/sub-${subj}/ses-${session}/beh
mkdir ${niidir}/sub-${subj}/ses-${session}/fmap


scp -r ${ecmdir}/param* ${niidir}/sub-${subj}/ses-${session}/temp

###Convert dcm to nii
#Only convert the Dicom folder anat
dcm2niix -o ${niidir}/sub-${subj}/ses-${session}/temp ${ecmdir}/DICOM



# Remove pilot scans
rm -f *Pilot*


## Fieldmap
for i in 1 2; do
	cp *gre_field_*e${i}.nii ../fmap/sub-${subj}_ses-${session}_magnitude${i}.nii
	cp *gre_field_*e${i}.json ../fmap/sub-${subj}_ses-${session}_magnitude${i}.json
done
cp *gre_field_*_ph.nii ../fmap/sub-${subj}_ses-${session}_phasediff.nii
cp *gre_field_*_ph.json ../fmap/sub-${subj}_ses-${session}_phasediff.json
sed -i '$s/}/,\n"EchoTime1": 0.00592}/' ../fmap/sub-${subj}_ses-${session}_phasediff.json
sed -i '$s/}/,\n"EchoTime2": 0.00838}/' ../fmap/sub-${subj}_ses-${session}_phasediff.json

## Add intended for field:
sed -i '$s@}@,\n"IntendedFor":["ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-01_bold.nii.gz",\n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-02_bold.nii.gz", \n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-03_bold.nii.gz"]}@' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_phasediff.json
sed -i -e "s/XXSUBJXX/${subj}/g" ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_phasediff.json
sed -i -e "s/XXSESSXX/${session}/g" ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_phasediff.json


# Multiple phase encoded directions
cp *norm*.nii ../fmap/sub-${subj}_ses-${session}_dir-norm_epi.nii
cp *norm*.json ../fmap/sub-${subj}_ses-${session}_dir-norm_epi.json
cp *invpol*.nii ../fmap/sub-${subj}_ses-${session}_dir-invpol_epi.nii
cp *invpol*.json ../fmap/sub-${subj}_ses-${session}_dir-invpol_epi.json


## Anatomical data
# Copy anatomy scans over if these are taken from a previous scanning session

if (( $session == 2 )); then
	if (( $separateAnatScan == 1 )) ; then
		echo Copying preexisting anatomical scan
		 
		mkdir anatomy
		cp /a/probands/bdb/$anatfile.* anatomy
    	tar -C anatomy -xvf anatomy/*tar*
		dcm2niix -o ${niidir}/sub-${subj}/ses-${session}/temp anatomy/*ADNI*
	fi

	#BIDS filename: sub-01_ses-1_T1w
	for entry in *ADNI*.nii
	do
    	cp "$entry" ../anat/sub-${subj}_ses-${session}_T1w.nii
		gzip ../anat/sub-${subj}_ses-${session}_T1w.nii
	done

	for entry in *ADNI*.json
	do
    	cp "$entry" ../anat/sub-${subj}_ses-${session}_T1w.json
	done
else
	cp ../../ses-2/anat/sub-${subj}_ses-2_T1w.nii.gz ../anat/sub-${subj}_ses-${session}_T1w.nii.gz
	cp ../../ses-2/anat/sub-${subj}_ses-2_T1w.json ../anat/sub-${subj}_ses-${session}_T1w.json
fi

## Functional data
#Create subject folder 
mkdir -p ${niidir}/sub-${subj}/ses-${session}/func

#Rename func files
#Break the func down into each task
#Example filename: 2475376_TfMRI_visualCheckerboard_645_CHECKERBOARD_645_RR
#BIDS filename: sub-2475376_ses-1_task-Checkerboard_acq-TR645_bold

for run in 1 2 3;
do
    echo Run $run Scan ${objScanNo[$run-1]} Copy data
    cp *bold*_$(printf "%d" $[${objScanNo[$run-1]}]).nii ${niidir}/sub-${subj}/ses-${session}/func/sub-${subj}_ses-${session}_task-object_run-0${run}_bold.nii
	#gzip ${niidir}/sub-${subj}/ses-${session}/func/sub-${subj}_ses-${session}_task-object_run-0${run}_bold.nii
	cp *bold*_$(printf "%d" $[${objScanNo[$run-1]}]).json ${niidir}/sub-${subj}/ses-${session}/func/sub-${subj}_ses-${session}_task-object_run-0${run}_bold.json
    sed -i '$s/}/,\n"TaskName":"object"}/' ${niidir}/sub-${subj}/ses-${session}/func/sub-${subj}_ses-${session}_task-object_run-0${run}_bold.json
done


if (( $session == 3 )); then
	echo Scan ${choiceNo} Copy data
	cp *bold*_$(printf "%d" $[${choiceNo}]).nii ${niidir}/sub-${subj}/ses-${session}/func/sub-${subj}_ses-${session}_task-choice_bold.nii
	gzip ${niidir}/sub-${subj}/ses-${session}/func/sub-${subj}_ses-${session}_task-choice_bold.nii
	cp *bold*_$(printf "%d" $[${choiceNo}]).json ${niidir}/sub-${subj}/ses-${session}/func/sub-${subj}_ses-${session}_task-choice_bold.json
	sed -i '$s/}/,\n"TaskName":"Choice task"}/' ${niidir}/sub-${subj}/ses-${session}/func/sub-${subj}_ses-${session}_task-choice_bold.json
fi

cd ${niidir}/sub-${subj}/ses-${session}/
rm -rf temp
gzip */*.nii

echo "${subj} ${session} complete!"
