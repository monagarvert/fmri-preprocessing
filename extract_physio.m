%% Example script using PhysIO with Matlab only (no SPM needed)
%  For documentation of the parameters, see also tapas_physio_new (e.g., via edit tapas_physio_new)

subj    = SUBJID;
session = NSESSION;
nvols   = [NVOL1 NVOL2 NVOL3 NVOL4];

datadir = ['/data/p_02071/choice-maps/my_dataset/sub-',num2str(subj),'/ses-',num2str(session),'/physio/'];

r_info = dir (['/data/p_02071/choice-maps/my_dataset/sub-',num2str(subj),'/ses-',num2str(session),'/physio/*Info.log']);
r_puls = dir (['/data/p_02071/choice-maps/my_dataset/sub-',num2str(subj),'/ses-',num2str(session),'/physio/*PULS.log']);
r_resp = dir (['/data/p_02071/choice-maps/my_dataset/sub-',num2str(subj),'/ses-',num2str(session),'/physio/*RESP.log']);

%% Create default parameter structure with all fields
physio = tapas_physio_new();

nruns = 3;
if session == 3
    nruns = 4;
end

for bl = 1:nruns
    try 
        physio.save_dir = {['/data/p_02071/choice-maps/my_dataset/sub-',num2str(subj),'/ses-',num2str(session),'/func']};
        physio.log_files.vendor = 'Siemens_Tics';
        physio.log_files.cardiac = {fullfile(datadir,r_puls(bl).name)};
        physio.log_files.respiration = {fullfile(datadir,r_resp(bl).name)};
        physio.log_files.scan_timing = {fullfile(datadir,r_info(bl).name)};
        physio.log_files.relative_start_acquisition = 0;
        physio.log_files.align_scan = 'last';
        physio.scan_timing.sqpar.Nslices = 60;
        physio.scan_timing.sqpar.TR = 2;
        physio.scan_timing.sqpar.Ndummies = 0;
        physio.scan_timing.sqpar.Nscans = nvols(bl);
        physio.scan_timing.sqpar.onset_slice = 30;
        physio.scan_timing.sync.method = 'scan_timing_log';
        physio.preproc.cardiac.modality = 'PPU';
        physio.preproc.cardiac.initial_cpulse_select.method = 'auto_matched';
        physio.preproc.cardiac.initial_cpulse_select.file = 'initial_cpulse_kRpeakfile.mat';
        physio.preproc.cardiac.initial_cpulse_select.min = 0.4;
        physio.preproc.cardiac.posthoc_cpulse_select.method = 'off';
        physio.preproc.cardiac.posthoc_cpulse_select.percentile = 80;
        physio.preproc.cardiac.posthoc_cpulse_select.upper_thresh = 60;
        physio.preproc.cardiac.posthoc_cpulse_select.lower_thresh = 60;
        physio.model.orthogonalise = 'none';
        physio.model.censor_unreliable_recording_intervals = false;
        if session == 2
            physio.model.output_multiple_regressors = ['sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(bl),'_physio.txt'];
            physio.model.output_physio = ['sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(bl),'_physio.mat'];
        else
            if bl == 1
                physio.model.output_multiple_regressors = ['sub-',num2str(subj),'_ses-',num2str(session),'_task-choice_physio.txt'];
                physio.model.output_physio = ['sub-',num2str(subj),'_ses-',num2str(session),'_task-choice_physio.mat'];
            else
                physio.model.output_multiple_regressors = ['sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(bl-1),'_physio.txt'];
                physio.model.output_physio = ['sub-',num2str(subj),'_ses-',num2str(session),'_task-object_run-0',num2str(bl-1),'_physio.mat'];
            end
        end
        endphysio.model.retroicor.include = true;
        physio.model.retroicor.order.c = 3;
        physio.model.retroicor.order.r = 4;
        physio.model.retroicor.order.cr = 1;
        physio.model.rvt.include = false;
        physio.model.rvt.delays = 0;
        physio.model.hrv.include = false;
        physio.model.hrv.delays = 0;
        physio.model.noise_rois.include = false;
        physio.model.noise_rois.thresholds = 0.9;
        physio.model.noise_rois.n_voxel_crop = 0;
        physio.model.noise_rois.n_components = 1;
        physio.model.noise_rois.force_coregister = 1;
        physio.model.movement.include = false;
        physio.model.movement.order = 6;
        physio.model.movement.censoring_threshold = 0.5;
        physio.model.movement.censoring_method = 'FD';
        physio.model.other.include = false;
        physio.verbose.level = 2;
        physio.verbose.process_log = cell(0, 1);
        physio.verbose.fig_handles = zeros(0, 1);
        physio.verbose.use_tabs = false;
        physio.ons_secs.c_scaling = 1;
        physio.ons_secs.r_scaling = 1;

        %% Run physiological recording preprocessing and noise modeling
        physio = tapas_physio_main_create_regressors(physio);
    catch
        disp(['Physio run ',num2str(bl), ' did not finish']);
    end
end