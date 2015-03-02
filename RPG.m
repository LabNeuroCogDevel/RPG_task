% Role Playing Game (e.g. Pokemon) Task
%
% copied from MMY4 nBMSI.m
%
% USAGE:
%   RPG subj
% EXAMPLE:
%   RPG 12345 
%
%
% output is saved in behave/subj_block_time.mat and behave/csv/subj_block_time
function RPG(subj,varargin)
 % block type should be a number
 
 [savename,dstr] = formatSaveName(subj,blocktype);
 diary([savename '_log.txt']);
 s = getSettings('init',varargin{:});
 
 %try
    w=setupScreen(s.screen.bg, s.screen.res);

    instructions(w);


    % we start when the scanner sends the go ahead
    starttime = getReady(w,s.host.type);

    res=cell(1,length(e));
    for ei=1:length(e)

      trl    = e(ei).trl;
      ename  = e(ei).name;
      onset  = e(ei).onset + starttime;
      efunc  = e(ei).func;
      params = e(ei).params;

      fprintf('%d %s %s @ %.3f for %.2f\n',trl, e(ei).tt, ename,e(ei).onset, e(ei).duration);
      res{ei}= efunc(w,onset,params{:});
      % include other useful info
      res{ei}.trl=trl;
      res{ei}.tt=e(ei).tt;
      res{ei}.name=ename;
      res{ei}.idealonset=onset;
      save([savename '.mat'],'res','subj','blocktype', 'e', 'emat', 'savename','dstr','s');

    end
    

    
    % draw final fixation for s.endITI seconds
    % then say good job
    lastonset = event_Fix(w,GetSecs(), s.colors.iticross);
    lastonset = lastonset.onset;
    endtime=lastonset+s.time.ITI.end;

    save([savename '.mat'],'res','subj','blocktype', 'e', 'emat', 'savename','dstr','s', 'endtime','lastonset');

    fprintf('xx END ITI @ %0.3f for %0.2f\n',lastonset-starttime, s.time.ITI.end);
    fprintf('xx GOOD JOB @ %0.3f\n',endtime-starttime);
    goodJob(w,endtime);

    % save output to csv file
    beh=behave([savename '.mat'],[savename '.csv']);

    behaveStats(beh);

    % shut it all down
    closedown();

 %catch
 %  closedown()
 %end


end
