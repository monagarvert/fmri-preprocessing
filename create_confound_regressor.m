% Creates matrix with user-specified confound regressors that can be used
% in 1st level analyses
%
% (c) Mona Garvert 2019
% MPI CBS
clear all
prefix = ['/Volumes/storageunified/'];

for subj = 104
    
     c = {...
        'trans_x',...
        'trans_y',...
        'trans_z',...
        'rot_x',...
        'rot_y',...
        'rot_z'};
        
    disp(subj)
    for session = 2:3
        disp(session)
        
        for run = 1:3
            physio = dlmread([prefix,'p_02071/choice-maps/my_dataset/sub-',num2str(subj),'/ses-',num2str(session),...
                '/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(run),'_physio.txt']);
            
            rp = [];
            confounds =  tdfread([prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-',num2str(subj),'/ses-',num2str(session),...
                '/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(run),'_desc-confounds_regressors.tsv']);
            
            for i = 1:length(c)
                rp = [rp eval(['confounds.',c{i}])];
            end
            rp = [rp physio];
            dlmwrite([prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-',num2str(subj),'/ses-',num2str(session),'/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(run),'_rp_physio.txt'],rp,'delimiter','\t','precision',3);
        end
    end
    
    physio = dlmread([prefix,'pt_02071/choice-maps/my_dataset/sub-',num2str(subj),'/ses-',num2str(session),...
        '/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-choice_physio.txt']);
    
    rp = [];
    confounds =  tdfread([prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-',num2str(subj),'/ses-',num2str(session),...
        '/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-choice_desc-confounds_regressors.tsv']);
    
    for i = 1:length(c)
        rp = [rp eval(['confounds.',c{i}])];
    end
    rp = [rp physio];
    dlmwrite([prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-',num2str(subj),'/ses-',num2str(session),'/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-choice_rp_physio.txt'],rp,'delimiter','\t','precision',3);
    

    
    % Extract data
    disp('%%%%%% unzipping nifti files %%%%%%%%')
    datadir        	= [prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-'];
    for session = 2:3
        for run = 1:3
            epi = [datadir,num2str(subj),'/ses-',num2str(session),'/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(run),'_space-MNI152NLin6Asym_desc-preproc_bold'];
            if ~exist([epi,'.nii'],'file'), gunzip ([epi,'.nii.gz']), end
        end
        
        % Brain mask
        if ~exist([datadir,num2str(subj),'/ses-',num2str(session),'/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-01_space-MNI152NLin6Asym_desc-brain_mask.nii'],'file')
            gunzip([datadir,num2str(subj),'/ses-',num2str(session),'/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-01_space-MNI152NLin6Asym_desc-brain_mask.nii.gz']);
        end
    end
    
   
    % Brain mask
    if ~exist([datadir,num2str(subj),'/anat/sub-',num2str(subj),'_space-MNI152NLin6Asym_desc-brain_mask.nii'],'file'), gunzip ([datadir,num2str(subj),'/anat/sub-',num2str(subj),'_space-MNI152NLin6Asym_desc-brain_mask.nii.gz']), end
    
    
    
    c = {...
        'trans_x',...
        'trans_y',...
        'trans_z',...
        'rot_x',...
        'rot_y',...
        'rot_z',...
        'a_comp_cor_00',...
        'a_comp_cor_01',...
        'a_comp_cor_02',...
        'a_comp_cor_03',...
        'a_comp_cor_04',...
        'a_comp_cor_05',...
        'cosine00',...
        'cosine01',...
        'cosine02',...
        'cosine03',...
        };
    
    
    for session = 2:3
        for run = 1:3
            rp = [];
            confounds =  tdfread([prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-',num2str(subj),'/ses-',num2str(session),...
                '/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(run),'_desc-confounds_regressors.tsv']);
            
            for i = 2:length(confounds.framewise_displacement)
                rp(i,1) = str2num(confounds.framewise_displacement(i,:));
            end
            rp(1,1) = nanmean(rp(2:end,1));
            for i = 1:length(c)
                rp = [rp eval(['confounds.',c{i}])];
            end
            
            dlmwrite([prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-',num2str(subj),'/ses-',num2str(session),'/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(run),'_rp.txt'],rp,'delimiter','\t','precision',3);
            
        end
    end
    
     % Choice task
    epi = [datadir,num2str(subj),'/ses-3/func/sub-',num2str(subj),'_ses-3_task-choice_space-MNI152NLin6Asym_desc-preproc_bold'];
    if ~exist([epi,'.nii'],'file'), gunzip ([epi,'.nii.gz']), end
    
    
    rp = [];
    confounds =  tdfread([prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-',num2str(subj),'/ses-',num2str(session),...
        '/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-choice_desc-confounds_regressors.tsv']);
    
    for i = 2:length(confounds.framewise_displacement)
        rp(i,1) = str2num(confounds.framewise_displacement(i,:));
    end
    rp(1,1) = nanmean(rp(2:end,1));
    for i = 1:length(c)
        rp = [rp eval(['confounds.',c{i}])];
    end
    
    dlmwrite([prefix,'pt_02071/choice-maps/preprocessed_data/fmriprep/sub-',num2str(subj),'/ses-',num2str(session),'/func/sub-',num2str(subj),'_ses-',num2str(session),'_task-choice_rp.txt'],rp,'delimiter','\t','precision',3);
    
    
end