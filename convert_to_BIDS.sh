## Convert imaging data into BIDS format
# (c) Mona Garvert
#
# June 2019 MPI CBS 

set -e 
# Variables to change for every data set. triplecheck to make sure these are correct!
subj=151 # edit
session=3 # edit
ecmdir= #/scr/mrincoming/19925.e6_20190919_115408.SKYRA #edit
choiceNo=8 #edit
objScanNo=(9 12 13) # edit

# if session 2:
separateAnatScan= # true / empty
anatfile= #19925.e6/19925.e6_190324_100453_S11_t1_mprage_ADNI_32Ch #33505.29/33505.29_190906_111346_S11_t1_MPRAGE_ADNI_32 #34442.2a/34442.2a_190909_161227_S25_MPRAGE_ADNI_WE_p2 #32616.6b/32616.6b_180427_081144_S22_t1_MPRAGE_ADNI_32 #30772.47/30772.47_170322_154608_S3_MPRAGE_ADNI_32Ch_fc #34195.bb/34195.bb_190816_093641_S4_t1_mprage_ADNI_32Ch

# If multiple fieldmaps were acquired because the scan was interrupted this needs to be filled in and multipleFieldmaps needs to be set to true. If not, leave multipleFieldmaps EMPTY (not false. Also adapt the "intended for" field below if multiple fieldmaps were acquired!)
multipleFieldmaps=
fieldmapIDs= #(10 11)
normInv= #(3 6)


####Defining pathways
niidir=/data/p_02071/choice-maps/my_dataset
#jo -p "Name"="Choice Maps experiment - Multiband Imaging Test-Retest Dataset" "BIDSVersion"="1.0.2" >> ${niidir}/dataset_description.json

####Anatomical Organization####
echo "Processing subject $subj session $session"

###Change directory to subject folder
mkdir -p ${niidir}/sub-${subj}/ses-${session}/temp
cd ${niidir}/sub-${subj}/ses-${session}/temp

#mkdir ${niidir}/sub-${subj}/ses-${session}/anat
#mkdir ${niidir}/sub-${subj}/ses-${session}/func
#mkdir ${niidir}/sub-${subj}/ses-${session}/beh
#mkdir ${niidir}/sub-${subj}/ses-${session}/fmap


scp -r ${ecmdir}/param* ${niidir}/sub-${subj}/ses-${session}/temp

###Convert dcm to nii
dcm2niix -o ${niidir}/sub-${subj}/ses-${session}/temp ${ecmdir}/DICOM



# Remove pilot scans
rm -f *Pilot*

echo $multipleFieldmaps
if [[ -n $multipleFieldmaps ]];  
then 
	for fmap in 1 2; # Two fieldmaps acquired	
	do 
		
		for i in {1..2}; 	# Two magnitude images
		do
			cp *gre_field_*_$(printf "%d" $[${fieldmapIDs[$fmap-1]}])_e${i}.nii ../fmap/sub-${subj}_ses-${session}_run-${fmap}_magnitude${i}.nii
			cp *gre_field_*_$(printf "%d" $[${fieldmapIDs[$fmap-1]}])_e${i}.json ../fmap/sub-${subj}_ses-${session}_run-${fmap}_magnitude${i}.json
		done
		
		cp *gre_field_*_$(printf "%d" $[$(( ${fieldmapIDs[$fmap-1]} + 1 ))])_ph.nii ../fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.nii
		cp *gre_field_*_$(printf "%d" $[$(( ${fieldmapIDs[$fmap-1]} + 1 ))])_ph.json ../fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
		sed -i '$s/}/,\n"EchoTime1": 0.00592}/' ../fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
		sed -i '$s/}/,\n"EchoTime2": 0.00838}/' ../fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
		
		# Multiple phase encoded directions
		cp *norm*_$(printf "%d" $[${normInv[$fmap-1]}]).nii ../fmap/sub-${subj}_ses-${session}_run-${fmap}_dir-norm_epi.nii
		cp *norm*_$(printf "%d" $[${normInv[$fmap-1]}]).json ../fmap/sub-${subj}_ses-${session}_run-${run}_dir-norm_epi.json
		cp *invpol*_$(printf "%d" $[$(( ${normInv[$fmap-1]} + 1 ))]).nii ../fmap/sub-${subj}_ses-${session}_run-${fmap}_dir-invpol_epi.nii
		cp *invpol*_$(printf "%d" $[$(( ${normInv[$fmap-1]} + 1 ))]).json ../fmap/sub-${subj}_ses-${session}_run-${fmap}_dir-invpol_epi.json
		
	done
	
	######  THE BIT BELOW HAS TO BE UPDATED APPROPRIATELY! THE WAY IT'S CODED NOW FIELDMAP 1 IS USED FOR BLOCKS 1 AND 2, FIELDMAP 2 IS USED FOR BLOCK 3.
	
	fmap=1
	
	## Add intended for field:
	sed -i '$s@}@,\n"IntendedFor":["ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-choice_bold.nii.gz",\n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-01_bold.nii.gz"]}@' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	# sed -i '$s@}@,\n"IntendedFor":["ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-01_bold.nii.gz",\n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-02_bold.nii.gz"]}@' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	sed -i -e "s/XXSUBJXX/${subj}/g" ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	sed -i -e "s/XXSESSXX/${session}/g" ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	sed -i '$s/}/,\n"EchoTime1": 0.00592}/' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	sed -i '$s/}/,\n"EchoTime2": 0.00838}/' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	
	fmap=2
	## Add intended for field:
	sed -i '$s@}@,\n"IntendedFor":["ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-02_bold.nii.gz",\n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-03_bold.nii.gz"]}@' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	# sed -i '$s@}@,\n"IntendedFor":["ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-03_bold.nii.gz""]}@' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	sed -i -e "s/XXSUBJXX/${subj}/g" ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	sed -i -e "s/XXSESSXX/${session}/g" ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	sed -i '$s/}/,\n"EchoTime1": 0.00592}/' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	sed -i '$s/}/,\n"EchoTime2": 0.00838}/' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_run-${fmap}_phasediff.json
	
else

	## Fieldmap
	i=1
	cp *gre_field_*e${i}.nii ../fmap/sub-${subj}_ses-${session}_magnitude${i}.nii
	cp *gre_field_*e${i}.json ../fmap/sub-${subj}_ses-${session}_magnitude${i}.json
	
	i=2
	cp *gre_field_*e${i}.nii ../fmap/sub-${subj}_ses-${session}_magnitude${i}.nii
	cp *gre_field_*e${i}.json ../fmap/sub-${subj}_ses-${session}_magnitude${i}.json
	
	cp *gre_field_*_ph.nii ../fmap/sub-${subj}_ses-${session}_phasediff.nii
	cp *gre_field_*_ph.json ../fmap/sub-${subj}_ses-${session}_phasediff.json
	sed -i '$s/}/,\n"EchoTime1": 0.00592}/' ../fmap/sub-${subj}_ses-${session}_phasediff.json
	sed -i '$s/}/,\n"EchoTime2": 0.00838}/' ../fmap/sub-${subj}_ses-${session}_phasediff.json

	## Add intended for field:
	if (( $session == 3 )); then
		sed -i '$s@}@,\n"IntendedFor":["ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-01_bold.nii.gz",\n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-02_bold.nii.gz", \n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-03_bold.nii.gz"]}@' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_phasediff.json
	else
		sed -i '$s@}@,\n"IntendedFor":["ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-choice_bold.nii.gz",\n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-01_bold.nii.gz",\n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-02_bold.nii.gz", \n"ses-XXSESSXX/func/sub-XXSUBJXX_ses-XXSESSXX_task-object_run-03_bold.nii.gz"]}@' ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_phasediff.json
	fi
	sed -i -e "s/XXSUBJXX/${subj}/g" ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_phasediff.json
	sed -i -e "s/XXSESSXX/${session}/g" ${niidir}/sub-${subj}/ses-${session}/fmap/sub-${subj}_ses-${session}_phasediff.json

	# Multiple phase encoded directions
	cp *norm*.nii ../fmap/sub-${subj}_ses-${session}_dir-norm_epi.nii
	cp *norm*.json ../fmap/sub-${subj}_ses-${session}_dir-norm_epi.json
	cp *invpol*.nii ../fmap/sub-${subj}_ses-${session}_dir-invpol_epi.nii
	cp *invpol*.json ../fmap/sub-${subj}_ses-${session}_dir-invpol_epi.json

fi

## Anatomical data
# Copy anatomy scans over if these are taken from a previous scanning session

if (( $session == 2 )); then
	if [[ -n $separateAnatScan ]] ; then
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
	
fi

## Functional data
#Create subject folder 
mkdir -p ${niidir}/sub-${subj}/ses-${session}/func

#Rename func files
#Break the func down into each task

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
