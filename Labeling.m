function Labeling(action)

global handle Data String message


%% string instruction
String.Instruction_Initial='Initialization done...';




%% top figure position setting

Screen = get(0,'ScreenSize');
myScreen.width=Screen(3);
myScreen.height=Screen(4);
fig_width = 640;
fig_height=600;
xmargin=(myScreen.width-fig_width)/2;
ymargin=(myScreen.height-fig_height)/2;

% Initialize a GUI 
if nargin < 1
    action='start'
end

if strcmp(action,'start')

%% create top figure
close all
handle.fig_top=figure('position',[xmargin ymargin fig_width fig_height],...
                      'Name','Label Program',...
                      'NumberTitle','off');
                  
%% create uicontrol in top figure
%panel
handle.panel_frame=uipanel('Title','Video Frame',...
                            'Parent',handle.fig_top,...
                            'position',[0 0.51 1 0.49]);
handle.panel_control=uipanel('Title','Control',...
                                'Parent',handle.fig_top,...
                                'position',[0 0 1 0.49]);

%button
handle.button_start=uicontrol('style','pushbutton',...
                                'string','start',...
                                'position',[17 246 61 25],...
                                'callback','Labeling(''button_start'')');
                            
handle.button_reset_screen=uicontrol('style','pushbutton',...
                                    'string','reset scrn',...
                                    'position',[17 206 61 25],...
                                    'callback','Labeling(''button_reset_screen'')');
                            
handle.button_modified=uicontrol('style','pushbutton',...
                                'string','modified',...
                                'position',[17 166 61 25],...
                                'callback','Labeling(''button_modified'')');

% initial start
Data.segmentTypes=cell(1,14);
Data.segmentTypes(1,:)={'lank' 'lkne' 'lhip' 'rhip' 'rkne' 'rank' 'lwr' 'lelb' 'lsho' 'rsho' 'relb' 'rwr' 'hbot' 'htop'};
Data.ptsAll=[];
%Data.segmentTypes=['lank';'lkne','lhip','rhip','rkne','rank','lwr','lelb','lsho','rsho','relb','rwr','hbot','htop'];
Data.frame_cache.order=[];
Data.timer=0;
Data.grab_log_path='grab_log.mat';
Data.inputSource='MOMO.mp4';
Data.frame_cache.inputSource=Data.inputSource;
%% label information
handle.text_x=uicontrol('style','text',...
                        'string','x:',...
                        'position',[97 256 15 15]);
handle.text_y=uicontrol('style','text',...
                        'string','y:',...
                        'position',[97 226 15 15]);
handle.text_times=uicontrol('style','text',...
                        'string','times:',...
                        'position',[80 196 40 15]);
handle.text_xlabel=uicontrol('style','text',...
                        'horizontalalignment','left',...
                        'position',[120 256 65 15]);
handle.text_ylabel=uicontrol('style','text',...
                        'horizontalalignment','left',...
                        'position',[120 226 65 15]);
handle.text_timesnum=uicontrol('style','text',...
                        'horizontalalignment','left',...
                        'position',[120 196 65 15]);
%% keyin information
%text
handle.text_jumpto=uicontrol('style','text',...
                        'string','Jump to',...
                        'horizontalalignment','left',...
                        'position',[17 143 41 15]);
handle.text_filename=uicontrol('style','text',...
                        'string','Filename (.mat)',...
                        'horizontalalignment','left',...
                        'position',[17 102 85 15]);
handle.text_folder=uicontrol('style','text',...
                        'string','Folder (for labeled image)',...
                        'horizontalalignment','left',...
                        'position',[17 64 129 15]);
                    
%edit
handle.edit_jumpto=uicontrol('style','edit',...
                        'backgroundcolor',[1 1 1],...
                        'horizontalalignment','left',...
                        'position',[17 126 83 15]);
handle.edit_filename=uicontrol('style','edit',...
                        'backgroundcolor',[1 1 1],...
                        'horizontalalignment','left',...
                        'string','labels.mat',...
                        'position',[17 86 83 15]);
handle.edit_folder=uicontrol('style','edit',...
                        'backgroundcolor',[1 1 1],...
                        'horizontalalignment','left',...
                        'string','labeled_data',...
                        'position',[17 46 83 15]);

Data.edit_jumpto=get(handle.edit_jumpto,'string');
Data.edit_filename=get(handle.edit_filename,'string');
Data.edit_folder=get(handle.edit_folder,'string');

%button
handle.button_setjumpto=uicontrol('style','pushbutton',...
                        'string','set',...
                        'position',[107 125 30 30],...
                        'callback','Labeling(''setjumpto'')');
handle.button_setfilename=uicontrol('style','pushbutton',...
                        'string','set',...
                        'position',[107 85 30 30],...
                        'callback','Labeling(''setfilename'')');
handle.button_setfolder=uicontrol('style','pushbutton',...
                        'string','set',...
                        'position',[107 45 30 20],...
                        'callback','Labeling(''setfolder'')');





%% slider information     
Data.mov=VideoReader(Data.inputSource);

handle.slider=uicontrol('Style','slider',...
                        'position',[200 256 430 15],...
                        'value',1,...
                        'max',Data.mov.NumberOfFrames,...
                        'min',1,...
                        'sliderstep',[1 1]/(Data.mov.NumberOfFrames-1),...
                        'callback','Labeling(''slider'')');
Data.slider=get(handle.slider,'value');
handle.text_frame=uicontrol('style','text',...
                            'string','frame:',...
                            'position',[80 166 40 15]);
handle.text_framenumber=uicontrol('style','text',...
                                'horizontalalignment','left',...
                                'string',Data.slider,...
                                'position',[120 166 65 15]);
%% panel frame
Data.frame=read(Data.mov,Data.slider);
handle.axes1=axes('Parent',handle.panel_frame,...
                    'position',[0 0 1 1]);
axes(handle.axes1);
imshow(Data.frame);
%% instruction 
handle.text_instrctitle=uicontrol('style','text',...
                                    'position',[200 230 430 15],...
                                    'string','instruction:',...
                                    'horizontalalignment','left');
handle.text_instruction=uicontrol('style','text',...
                                    'position',[200 26 430 200],...
                                    'string',String.Instruction_Initial,...
                                    'horizontalalignment','left');
%% button_start callback
elseif strcmp(action,'button_start')                                                %% unfinished:limited range of getting point, check if label.mat exists
    set(handle.text_instruction,'string','start labeling');
    %if (exist(Data.grab_log_path)==2)||(exist(Data.edit_filename)==2)
    %    message.questdlg_overlay=questdlg(['We found the input files exist, do you want to overlay all files?','We will delete all files and create new files.']);
    % 
    %else isempty(dir('*.mat'))==0
    %    message.questdlg_empty=questdlg(['We found the folder is not empty, do you want to overlay all files?','We will delete all files and create new files.']);
    %end
    
    %record the order of the frame you label
    if isempty(dir(Data.edit_folder))
        mkdir(Data.edit_folder);
    end
    
    if exist([Data.edit_folder,'\', Data.grab_log_path])==0                 %if file not exist, create new one
        Data.frame_cache.order=[];
        grab_log.inputSource=Data.frame_cache.inputSource;
        grab_log.grab_order=Data.frame_cache.order;
        save([Data.edit_folder,'\', Data.grab_log_path],'grab_log');
        Data.timer=0;
    else 
        load([Data.edit_folder,'\', Data.grab_log_path],'grab_log');
        Data.timer=size(grab_log.grab_order,2);
        clear grab_log;
    end
    
    Data.timer=Data.timer+1;
    Data.frame_cache.order(Data.timer)=Data.slider;
    load([Data.edit_folder,'\', Data.grab_log_path],'grab_log');
    grab_log.grab_order(Data.timer)=Data.frame_cache.order(Data.timer);
    save([Data.edit_folder,'\', Data.grab_log_path],'grab_log');

    imwrite(Data.frame,[Data.edit_folder,'\', sprintf('im%.4d.jpg',Data.timer)]);
    
    %grab joint and save
    
    if exist([Data.edit_folder,'\',Data.edit_filename])==0                 %if file not exist, create new one
        Data.ptsAll=[];
        labels.ptsAll=Data.ptsAll;
        labels.segmentTypes=Data.segmentTypes;
        save([Data.edit_folder,'\',Data.edit_filename],'labels');
    end
    
    for i=1:14
        [Data.xlabel_temp,Data.ylabel_temp]=ginput(1);
        set(handle.text_xlabel,'string',Data.xlabel_temp);
        set(handle.text_ylabel,'string',Data.ylabel_temp);
        set(handle.text_timesnum,'string',i);
        Data.ptsAll(i,:,Data.timer)=[Data.xlabel_temp,Data.ylabel_temp];
    end
    set(handle.text_instruction,'string','14 joints have been labeled and saved in labels.mat, you can find the frames you label in the file you just create');
    
    load([Data.edit_folder,'\',Data.edit_filename],'labels');
    labels.ptsAll=Data.ptsAll;
    save([Data.edit_folder,'\',Data.edit_filename],'labels');
    
%% button_reset_screen callback
elseif strcmp(action,'button_reset_screen')
    set(handle.fig_top,'position',[xmargin ymargin fig_width fig_height])
    
%% button_modified callback
elseif strcmp(action,'button_modified')
    
    
%% slider callback
elseif strcmp(action,'slider')
    Data.slider=get(handle.slider,'value');
    
    % let slider be integer
    if rem(Data.slider,1)~=0
        Data.slider=round(Data.slider);
        set(handle.slider,'Value',Data.slider);
    end
    
    set(handle.text_framenumber,'string',Data.slider);              %show frame number
    %update frame image
    Data.frame=read(Data.mov,Data.slider);
    axes(handle.axes1);
    imshow(Data.frame);
    set(handle.text_instruction,'string','load done');

%% button_setjumpto callback
elseif strcmp(action,'setjumpto')
    
    Data.edit_jumpto=get(handle.edit_jumpto,'string');
    if isempty(Data.edit_jumpto)==0
        Data.jumptonum=str2num(Data.edit_jumpto);
        if isempty(Data.jumptonum)==0
            if rem(Data.jumptonum,1)~=0
                message.Info=msgbox('Because of the limit of the size of frames, we will round off the input number','Information');
                uiwait(message.Info);
                Data.temp=round(Data.jumptonum);
                set(handle.edit_jumpto,'string',Data.temp);
            end

            set(handle.text_instruction,'string','set done');
            set(handle.slider,'Value',str2num(Data.edit_jumpto));
            movietest('slider');
        else 
            message.error_jumpto.notnum=errordlg('Error: Input must be numeric','Input Error');
        end
    else
        message.error_jumpto.empty=errordlg('Error: Please enter the number of frames you want to jump to ','Input Error');
    end

%% button_setfilename callback
elseif strcmp(action,'setfilename')
    Data.edit_filename=get(handle.edit_filename,'string');
    
%% button_setfolder callback
elseif strcmp(action,'setfolder')
    Data.edit_folder=get(handle.edit_folder,'string');
    if isempty(dir(Data.edit_folder))
        mkdir(Data.edit_folder);
    end
    
    if exist([Data.edit_folder,'\', Data.grab_log_path])==0
        Data.timer=0;
    end
        
end
