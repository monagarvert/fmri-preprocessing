% Generates events files for the task blocks
%
% (c) Mona Garvert MPI CBS June 2019

function generate_task_events(s)

savedir = '/data/g_gr_doeller-share/Experiments/Mona/ChoiceMaps/experiment/version_scan/datafiles/merged_data';

disp(s)
load([savedir,'/subj_',num2str(s),'/data_',num2str(s)]);

for session = 2:3
    d = data.mat{session}.data;
    
    for run = 1:3
%         startTime = d.scan{run}.RSA.taskStart - d.scanTech.dummy * 2;
        startTime = d.scan{run}.RSA.slice(2) ; % For some reason the very first trigger is recorded already when the script is starting! The second one corresponds to the actual start of the scan
        
        counter = 0;
        
        clear onset duration map trial_type response_time object object1 object2 choicetype cr stayswitch distance value counterfactual_value value_diff choicetype ...
            chosen_distance unchosen_distance chosen_value unchosen_value counterfactual_chosen_value counterfactual_unchosen_value button
        
        for trial = 1:length(d.scan{run}.RSA.stimOn)
            counter                     = counter +1;
            
            t(counter)                  = trial;
            
            onset(counter,1)            = d.scan{run}.RSA.stimOn(trial) - startTime;
            button(counter,1)           = nan;
            
            duration(counter,1)         = d.scan{run}.RSA.stimOff(trial) - d.scan{run}.RSA.stimOn(trial);
            map(counter,1)              = d.scan{run}.RSA.map(trial);
            object(counter,1)           = d.scan{run}.RSA.seq(trial);
            trial_type{counter,1}       = 'object_onset';
            response_time(counter,1)    = nan;
            choicetype{counter,1}       = 'n/a';            
          
            object1(counter,1)          = nan;
            object2(counter,1)          = nan;
            cr(counter,1)               = nan;
            if trial == 1
                stayswitch{counter,1}       = 'n/a';
                distance(counter,1)         = nan;
                value(counter,1)            = nan;
                counterfactual_value(counter,1) = nan;
                value_diff(counter,1)       = nan;
                
            elseif  map(counter,1) == map(counter-1,1) 
                stayswitch{counter,1}       = 'stay';
                distance(counter,1)         = d.settings.spatial_dist(d.scan{run}.RSA.seq(trial),d.scan{run}.RSA.seq(trial-1));
                value(counter,1)            = round(d.settings.value(d.scan{run}.RSA.map(trial),d.scan{run}.RSA.seq(trial)));
                counterfactual_value(counter,1) = round(d.settings.value(mod(d.scan{run}.RSA.map(trial),2)+1,d.scan{run}.RSA.seq(trial)));
                value_diff(counter,1)       = value(counter,1)-counterfactual_value(counter,1);
                
            else
                stayswitch{counter,1}       = 'switch';
                distance(counter,1)         = d.settings.spatial_dist(d.scan{run}.RSA.seq(trial),d.scan{run}.RSA.seq(trial-1));
                value(counter,1)            = round(d.settings.value(d.scan{run}.RSA.map(trial),d.scan{run}.RSA.seq(trial)));
                counterfactual_value(counter,1) = round(d.settings.value(mod(d.scan{run}.RSA.map(trial),2)+1,d.scan{run}.RSA.seq(trial)));
                value_diff(counter,1)       = value(counter,1)-counterfactual_value(counter,1);
            end
            
            
            chosen_distance(counter,1)      = nan;
            unchosen_distance(counter,1)    = nan;
            
            chosen_value(counter,1)         = nan;
            unchosen_value(counter,1)       = nan;
            
            counterfactual_chosen_value(counter,1)     = nan;
            counterfactual_unchosen_value(counter,1)   = nan;
            
            if d.scan{run}.RSA.objDiff.choicetrial(trial) == 1
                counter                 = counter +1;
                onset(counter,1)        = d.scan{run}.RSA.objDiff.stimOn(trial) - startTime;
                button(counter,1)       = d.scan{run}.RSA.objDiff.tKeyPress(trial) - startTime;
            
                duration(counter,1)     = d.scan{run}.RSA.objDiff.stimOff(trial) - d.scan{run}.RSA.objDiff.stimOn(trial);
                map(counter,1)          = d.scan{run}.RSA.map(trial);
                object(counter,1)       = d.scan{run}.RSA.seq(trial);
                trial_type{counter,1}   = 'choice';
                response_time(counter,1) = d.scan{run}.RSA.objDiff.RT(trial);
                object1(counter,1)      = d.scan{run}.RSA.objDiff.choiceOptions(trial,1);
                object2(counter,1)      = d.scan{run}.RSA.objDiff.choiceOptions(trial,2);
                
                cr(counter,1)           = d.scan{run}.RSA.objDiff.cr(trial);
                
                choicetype{counter,1}   = d.scan{run}.RSA.objDiff.whichchoice(trial);
                if strcmp(choicetype(counter,1),"")
                     choicetype{counter,1}       = 'n/a';
                end
                
                stayswitch{counter,1}       = 'n/a';
                distance(counter,1)         = nan;
                value(counter,1)            = nan;
                counterfactual_value(counter,1) = nan;
                value_diff(counter,1)       = nan;
                
                chosen_distance(counter,1)  = d.scan{run}.RSA.objDiff.spatialCh(trial);
                unchosen_distance(counter,1) = d.scan{run}.RSA.objDiff.spatialUnch(trial);
                
                chosen_value(counter,1)     = d.scan{run}.RSA.objDiff.distRelCh(trial);
                unchosen_value(counter,1)   = d.scan{run}.RSA.objDiff.distRelUnch(trial);                
                
                counterfactual_chosen_value(counter,1)     = d.scan{run}.RSA.objDiff.distIrrelCh(trial);
                counterfactual_unchosen_value(counter,1)   = d.scan{run}.RSA.objDiff.distIrrelUnch(trial);
            end
        end
        
        events = table(onset, duration, object, trial_type, map, stayswitch, distance, value, counterfactual_value, value_diff, ...
            choicetype, object1, object2, chosen_distance, unchosen_distance, chosen_value, unchosen_value, counterfactual_chosen_value, counterfactual_unchosen_value, button, response_time, cr);
        writetable(events,['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-object_run-0',num2str(run),'_events.txt'],'delimiter','\t')
        
        movefile(['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-object_run-0',num2str(run),'_events.txt'], ...
            ['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-object_run-0',num2str(run),'_events.tsv'])
    end
end

clear onset duration map stayswitch distance trial_type response_time object object1 object2 choicetype cr object_left object_right button warning_onset
startTime = d.choice.taskStart - d.scanTech.dummy * 2;

warning_onset = nan(2*length(d.choice.stimOn),1);
counter = 0;
for trial = 1:length(d.choice.stimOn)
    counter = counter + 1;
    onset(counter,1)               = d.choice.stimOn(trial)' - startTime;
    duration(counter,1)            = d.choice.decisionTime(trial)' - d.choice.stimOn(trial)';
    map(counter,1)                 = d.choice.map(trial)';
    object_left(counter,1)         = d.choice.options(1,trial);
    object_right(counter,1)        = d.choice.options(2,trial) ;
    decision(counter,1)            = d.choice.decision(trial)';
    chosen_object(counter,1)       = d.choice.chosen_object(trial);
    unchosen_object(counter,1)     = d.choice.unchosen_object(trial);
    chosen_value(counter,1)        = d.choice.chosen_value(trial)';
    unchosen_value(counter,1)      = d.choice.unchosen_value(trial)';
    response_time(counter,1)       = d.choice.RT(trial)';
    trial_type{counter,1}          = 'choice';    
    
    distance(counter,1)             = nan;
    button(counter,1)               = d.choice.decisionTime(trial)'- startTime;
    if trial > 1 && mod(trial,10) == 1
        warning_onset(counter,1)        = d.choice.stimOn(trial)-startTime-2.5;
    end
        
    counter = counter + 1;
    onset(counter,1)               = d.choice.feedbackOn(trial)' - startTime;
    duration(counter,1)            = d.choice.feedbackOff(trial)' - d.choice.feedbackOn(trial)';
    map(counter,1)                 = d.choice.map(trial)';
    object_left(counter,1)         = d.choice.options(1,trial);
    object_right(counter,1)        = d.choice.options(2,trial) ;
    decision(counter,1)            = d.choice.decision(trial)';
    chosen_object(counter,1)       = d.choice.chosen_object(trial);
    unchosen_object(counter,1)     = d.choice.unchosen_object(trial);
    chosen_value(counter,1)        = d.choice.chosen_value(trial)';
    unchosen_value(counter,1)      = d.choice.unchosen_value(trial)';
    response_time(counter,1)       = d.choice.RT(trial)';
    trial_type{counter,1}          = 'feedback';
    button(counter,1)               = d.choice.decisionTime(trial)' - startTime;
    if trial > 1 && mod(trial,10) == 1
        warning_onset(counter,1)        = d.choice.stimOn(trial)-startTime-2.5;
    end
end
events = table(onset,duration, map, object_left, object_right, decision, chosen_object, unchosen_object, chosen_value, unchosen_value, response_time, trial_type, button, warning_onset);
writetable(events,['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-choice_events.txt'],'delimiter','\t')

% Change to appropriate file name
movefile(['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-choice_events.txt'],...
    ['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-choice_events.tsv'])


