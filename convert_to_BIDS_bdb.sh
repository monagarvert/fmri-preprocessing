
set -e 
# Variables to change for every data set. triplecheck to make sure these are correct!
subj=103 # edit
session=3 # edit
ecmdir=/a/probands/bdb/32059.82/32059.82_190509_095159 # edit
choiceNo=5 #edit
objScanNo=(5 6 9) # edit

####Defining pathways
niidir=/data/p_02071/choice-maps/my_dataset

mkdir ${niidir}/sub-${subj}/ses-${session}/temp

cd ${niidir}/sub-${subj}/ses-${session}/temp

for s in {1..20};
do
	echo S${s}
	 
	mkdir S${s}
	cp ${ecmdir}*S${s}*.tar.gz S${s}
	tar -C S${s} -xvf S${s}/*tar*
	dcm2niix -o ${niidir}/sub-${subj}/ses-${session}/temp S${s}/*tar*
done