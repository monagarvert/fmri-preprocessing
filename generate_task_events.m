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
        startTime = d.scan{run}.RSA.taskStart - d.scanTech.dummy * 2;
        
        counter = 0;
        
        clear onset duration map trial_type response_time object object1 object2 choicetype cr
        for trial = 1:length(d.scan{run}.RSA.stimOn)
            counter                     = counter +1;
            onset(counter,1)            = d.scan{run}.RSA.stimOn(trial) - startTime;
            duration(counter,1)         = d.scan{run}.RSA.stimOff(trial) - d.scan{run}.RSA.stimOn(trial);
            map(counter,1)              = d.scan{run}.RSA.map(trial);
            object(counter,1)           = d.scan{run}.RSA.seq(trial);
            trial_type{counter,1}       = 'object_onset';
            response_time(counter,1)    = nan;
            choicetype(counter,1)       = d.scan{run}.RSA.objDiff.whichchoice(trial);
            if strcmp(choicetype(counter,1),"")
                choicetype(counter,1)       = 'n/a';
            end
            
            object1(counter,1)          = nan;
            object2(counter,1)          = nan;
            cr(counter,1)               = nan;
            
            
            if d.scan{run}.RSA.objDiff.choicetrial(trial) == 1
                counter                 = counter +1;
                onset(counter,1)        = d.scan{run}.RSA.objDiff.stimOn(trial) - startTime;
                duration(counter,1)     = d.scan{run}.RSA.objDiff.stimOff(trial) - d.scan{run}.RSA.objDiff.stimOn(trial);
                map(counter,1)          = d.scan{run}.RSA.map(trial);
                object(counter,1)       = d.scan{run}.RSA.seq(trial);
                trial_type{counter,1}   = 'choice';
                response_time(counter,1) = d.scan{run}.RSA.objDiff.RT(trial);
                object1(counter,1)      = d.scan{run}.RSA.objDiff.choiceOptions(trial,1);
                object2(counter,1)      = d.scan{run}.RSA.objDiff.choiceOptions(trial,2);
                cr(counter,1)           = d.scan{run}.RSA.objDiff.cr(trial);
                
                choicetype(counter,1)   = d.scan{run}.RSA.objDiff.whichchoice(trial);
                if strcmp(choicetype(counter,1),"")
                     choicetype(counter,1)       = 'n/a';
                end
                
            end
        end
        
        events = table(onset,duration, map, object, object1, object2, trial_type, response_time, cr, choicetype);
        writetable(events,['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-object_run-0',num2str(run),'_events.txt'],'delimiter','\t')
        
        movefile(['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-object_run-0',num2str(run),'_events.txt'], ...
            ['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-object_run-0',num2str(run),'_events.tsv'])
    end
    
    
end

clear onset duration map trial_type response_time object object1 object2 choicetype cr object_left object_right
startTime = d.choice.taskStart - d.scanTech.dummy * 2;

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
    trial_type{counter,1}   = 'choice';
    
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
    trial_type{counter,1}   = 'feedback';
end

events = table(onset,duration, map, object_left, object_right, decision, chosen_object, unchosen_object, chosen_value, unchosen_value, response_time, trial_type);
writetable(events,['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-choice_events.txt'],'delimiter','\t')

% Change to appropriate file name
movefile(['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-choice_events.txt'],...
    ['/data/p_02071/choice-maps/my_dataset/sub-',num2str(s),'/ses-',num2str(session), '/func/sub-',num2str(s),'_ses-',num2str(session), '_task-choice_events.tsv'])


