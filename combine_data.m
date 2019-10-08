% combine data
clear all
subj = 152;

pc = 'linux';
if strcmp(pc,'dell')
    addpath (genpath('C:/Users/mgarvert/ownCloudCBS/matlab_scripts/jsonlab-1.5'))
    datadir = 'C:/Users/mgarvert/ownCloudCBS/Projects/ChoiceMaps/experiment/version_scan/datafiles/';
    savedir = 'C:/Users/mgarvert/ownCloudCBS/Projects/ChoiceMaps/experiment/version_scan/datafiles/merged_data';
else
    addpath (genpath('/data/p_02071/choice-maps/scripts/matlab_scripts/jsonlab-1.5'))
    datadir = '/data/g_gr_doeller-share/Experiments/Mona/ChoiceMaps/experiment/version_scan/datafiles/';
    savedir = '/data/g_gr_doeller-share/Experiments/Mona/ChoiceMaps/experiment/version_scan/datafiles/merged_data';
end

initials = {'tl','hw','jk','lp','km','sr','jh', 'tb', 'pq','mb','mh','lm','jp','nt','to','lu','ag','pk','ls','bs','cd','ao','lz','ei','av','cs','pm',...
    'cz','pa','ms','ss','cf','pj','jl','aa','am','cs','nb','rh','fa','jz','fk','ah','jm','ks','cn','lt','aw','dh', 'ss', 'ps', 'ab'};

prepost = {'pre','post'};
switch subj
    case 101
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_',num2str(2),'/data_',num2str(subj),'_',num2str(2),'_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_',num2str(3),'/data_',num2str(subj),'_',num2str(3),'_',initials{subj-100},'_sess1.mat']);
        
        d = load([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_',initials{subj-100},'.mat']);
        data.mat{3}.data.scan{2} = d.data.scan{2};
        data.mat{3}.data.scan{3} = d.data.scan{3};
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        
    case 103
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_sess1.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
        
    case 109
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
        
    case 113
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz12 = loadjson([datadir,'Subj_113/session_1/data_113_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        data.viz.session_1 = viz12.session_1;
        
        viz11 = loadjson([datadir,'Subj_113/session_1/data_113_1_pre_',initials{subj-100},'_viz.txt']);
        data.viz.session_1.pre.freeExplore.run_1 = viz11.session_1.pre.freeExplore.run_1;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
       
    case 116
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_sess1.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena;
      
     case 123
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz12 = loadjson([datadir,'Subj_123/session_1/data_123_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        data.viz.session_1 = viz12.session_1;
        
        viz11 = loadjson([datadir,'Subj_123/session_1/data_123_1_pre_',initials{subj-100},'_viz.txt']);
        data.viz.session_1.pre.freeExplore.run_1 = viz11.session_1.pre.freeExplore.run_1;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
      
        
    case 125
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz14 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess4_viz.txt']);
        data.viz.session_1 = viz14.session_1;
        data.viz.session_1.pre.positionObject.run_5 = viz14.session_1.pre.positionObject.run_2;
        data.viz.session_1.pre.positionObject.run_6 = viz14.session_1.pre.positionObject.run_3;
        data.viz.session_1.pre.positionObject.run_7 = viz14.session_1.pre.positionObject.run_4;
        data.viz.session_1.pre.positionObject.run_8 = viz14.session_1.pre.positionObject.run_5;
        data.viz.session_1.pre.freeExplore.run_6 = viz14.session_1.pre.freeExplore.run_2;
        data.viz.session_1.pre.freeExplore.run_7 = viz14.session_1.pre.freeExplore.run_3;
        data.viz.session_1.pre.freeExplore.run_8 = viz14.session_1.pre.freeExplore.run_4;
        data.viz.session_1.pre.freeExplore.run_9 = viz14.session_1.pre.freeExplore.run_5;
        
        viz13 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess3_viz.txt']);
        data.viz.session_1.pre.positionObject.run_3 = viz13.session_1.pre.positionObject.run_2;
        data.viz.session_1.pre.positionObject.run_4 = viz13.session_1.pre.positionObject.run_3;
        data.viz.session_1.pre.freeExplore.run_4 = viz13.session_1.pre.freeExplore.run_2;
        data.viz.session_1.pre.freeExplore.run_5 = viz13.session_1.pre.freeExplore.run_3;
        
        viz12 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        data.viz.session_1.pre.positionObject.run_1 = viz12.session_1.pre.positionObject.run_1;
        data.viz.session_1.pre.positionObject.run_2 = viz12.session_1.pre.positionObject.run_2;
        data.viz.session_1.pre.freeExplore.run_2 = viz12.session_1.pre.freeExplore.run_1;
        data.viz.session_1.pre.freeExplore.run_3 = viz12.session_1.pre.freeExplore.run_2;
        
        viz11 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',init_sess2_vizials{subj-100},'_viz.txt']);
        data.viz.session_1.pre.freeExplore.run_1 = viz11.session_1.pre.freeExplore.run_1;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
    
    case 132
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz12 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        data.viz.session_1 = viz12.session_1;
        
        viz11 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_viz.txt']);
        data.viz.session_1.pre.freeExplore.run_1 = viz11.session_1.pre.freeExplore.run_1;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
    
    case 133
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz12 = loadjson([datadir,'Subj_133/session_1/data_133_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        data.viz.session_1 = viz12.session_1;
        
        viz11 = loadjson([datadir,'Subj_133/session_1/data_133_1_pre_',initials{subj-100},'_viz.txt']);
        data.viz.session_1.pre.freeExplore.run_1 = viz11.session_1.pre.freeExplore.run_1;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
       
    case 134
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'_sess1.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena;
        
    case 136
        session = 2;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz12 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        data.viz.session_1 = viz12.session_1;
        
        viz11 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_viz.txt']);
        data.viz.session_1.pre.freeExplore.run_1 = viz11.session_1.pre.freeExplore.run_1;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        
    case 137
        session = 2;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);      
    
    
    case 138
        session = 2;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz12 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        data.viz.session_1 = viz12.session_1;
        data.viz.session_1.pre.positionObject.run_4 = viz12.session_1.pre.positionObject.run_3;
        data.viz.session_1.pre.positionObject.run_5 = viz12.session_1.pre.positionObject.run_4;
        data.viz.session_1.pre.positionObject.run_6 = viz12.session_1.pre.positionObject.run_5;
        data.viz.session_1.pre.freeExplore.run_4 = viz12.session_1.pre.freeExplore.run_3;
        data.viz.session_1.pre.freeExplore.run_5 = viz12.session_1.pre.freeExplore.run_4;
        data.viz.session_1.pre.freeExplore.run_6 = viz12.session_1.pre.freeExplore.run_5;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
           
    case 140
        session = 2;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz11 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_viz.txt']);
        
        viz13 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess3_viz.txt']);
        data.viz.session_1 = viz13.session_1;
        data.viz.session_1.pre.freeExplore.run_1 = viz11.session_1.pre.freeExplore.run_1;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
        
    case 143
        disp('ACCIDENTALLY DELETED THIS BIT OF THE CODE. REDO IF YOU WANT TO RERUN 143');
        
    case 151
        session = 2;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz11 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_viz.txt']);
        viz12 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        viz13 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess3_viz.txt']);
        
        data.viz.session_1 = viz11.session_1;
        
        data.viz.session_1.pre.positionObject.run_2 = viz12.session_1.pre.positionObject.run_8;
        data.viz.session_1.pre.positionObject.run_3 = viz12.session_1.pre.positionObject.run_9;        
        data.viz.session_1.pre.freeExplore.run_2 = viz12.session_1.pre.freeExplore.run_8;
        data.viz.session_1.pre.freeExplore.run_3 = viz12.session_1.pre.freeExplore.run_9;
        
        data.viz.session_1.pre.positionObject.run_4 = viz13.session_1.pre.positionObject.run_8;
        data.viz.session_1.pre.positionObject.run_5 = viz13.session_1.pre.positionObject.run_9;        
        data.viz.session_1.pre.positionObject.run_6 = viz13.session_1.pre.positionObject.run_10;
        data.viz.session_1.pre.freeExplore.run_4 = viz13.session_1.pre.freeExplore.run_8;        
        data.viz.session_1.pre.freeExplore.run_5 = viz13.session_1.pre.freeExplore.run_9;
        data.viz.session_1.pre.freeExplore.run_6 = viz13.session_1.pre.freeExplore.run_10;
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
    
    case 152
        session = 2;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        viz11 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_viz.txt']);
        
        viz12 = loadjson([datadir,'Subj_',num2str(subj),'/session_1/data_',num2str(subj),'_1_pre_',initials{subj-100},'_sess2_viz.txt']);
        data.viz.session_1 = viz11.session_1;
        data.viz.session_1.pre.positionObject.run_4 = viz12.session_1.pre.positionObject.run_3;
        data.viz.session_1.pre.positionObject.run_5 = viz12.session_1.pre.positionObject.run_4;
        data.viz.session_1.pre.positionObject.run_6 = viz12.session_1.pre.positionObject.run_5;
        data.viz.session_1.pre.freeExplore.run_4 = viz12.session_1.pre.freeExplore.run_3;
        data.viz.session_1.pre.freeExplore.run_5 = viz12.session_1.pre.freeExplore.run_4;
        data.viz.session_1.pre.freeExplore.run_6 = viz12.session_1.pre.freeExplore.run_5;
        
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
      
        
    otherwise
        session = 3;
        try
            data.viz = loadjson([datadir,'Subj_',num2str(subj),'/session_',num2str(session),'/data_',num2str(subj),'_',num2str(session),'_post_',initials{subj-100},'_viz.txt']);
        catch
        end
        
        data.mat{2} = load([datadir,'Subj_',num2str(subj),'/session_2/data_',num2str(subj),'_2_',initials{subj-100},'.mat']);
        data.mat{3} = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'.mat']);
        
        post = load([datadir,'Subj_',num2str(subj),'/session_3/data_',num2str(subj),'_3_',initials{subj-100},'_postscan.mat']);
        
        data.likert             = post.data.likert;
        data.value_rating       = post.data.value_rating;
        data.arena_similarity   = post.data.arena_similarity;
        data.arena_space        = post.data.arena_space;
      
        zzz
end

mkdir([savedir,'/subj_',num2str(subj)])
save([savedir,'/subj_',num2str(subj),'/data_',num2str(subj)],'data')

% Generate table with task-relevant data
try
    generate_task_events(subj);
catch
end


for s = 101:subj
    disp(s)
    load([savedir,'/subj_',num2str(s),'/data_',num2str(s)]);
    participant_id{s-100,1} = ['sub-',num2str(s)];
    age(s-100,1) = data.viz.age;
    sex{s-100,1} = upper(data.viz.gender);
end

participants = table(participant_id,age,sex);
writetable(participants,'/data/p_02071/choice-maps/my_dataset/participants.txt', 'delimiter','\t')
movefile ('/data/p_02071/choice-maps/my_dataset/participants.txt','/data/p_02071/choice-maps/my_dataset/participants.tsv');


cd([datadir,'Subj_',num2str(subj)])

% Analyse physiological data. IMPORTANT: Will only work after
% convert_to_BIDS.sh has been completed for this subject!
addpath(genpath('/data/p_02071/choice-maps/scripts/tapas'))
cd (['/data/pt_02071/choice-maps/preprocessed_data/sub-',num2str(subj),'/scripts']);

for session = 2:3
    run(['extract_physio_sub_',num2str(subj),'_ses_',num2str(session),'.m'])
end

close all


