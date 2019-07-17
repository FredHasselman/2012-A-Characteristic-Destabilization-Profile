%% This MATLAB script performs analyses and creates figures reported in:
%
%   Lichtwarck-Aschoff, A., Hasselman, F., Cox, R., Pepler, D., & Granic, I. (2012).
%     A Characteristic Destabilization Profile in Parent-Child Interactions Associated with Treatment Efficacy for Aggressive Children.
%     Nonlinear Dynamics Psychology and Life Sciences, 16(3), 353-379.
%
% - Use MATLAB cell code execution to repeat and inspect analysis steps
% - Below the files / scripts / software that is necessary to run this script in MATLAB are listed
%
%---------------------------------------
%   RAW DATA FILE:
%
%   TS_5s.txt
%
%---------------------------------------
%   MATLAB CODE BY AUTHORS
%
%   EntropyPeak_NDPLS.m                  - This file
%   catrqa.m                             - Performs categorical rqa on an ; rp matrix; depends on Marwan's Toolbox tt.m, dl.m
%   writeS2T.m                           - Write a structure to a tab-delimited file
%   writeM2T.m                           - Write a matrix to a tab-delimited file
%   grab.m                               - Grab the current figure to EPS file
%
%---------------------------------------
%   MATLAB CODE BY OTHERS
%
%   dl.m                                 - NOT INCLUDED IN THE ARCHIVE Download and install Marwan's toolbox: http://www.agnld.uni-potsdam.de/~marwan/toolbox/
%   tt.m                                 - NOT INCLUDED IN THE ARCHIVE Download and install Marwan's toolbox: http://www.agnld.uni-potsdam.de/~marwan/toolbox/
%   keep.m                               - Reverse of clear; Minor adjustment to scripts by Martin Barugel and Xiaoning Yang
%
%---------------------------------------
%   MPLUS DEMO (TESTED FOR MAC OSX)
%
%   mpdemo                               - NOT INCLUDED IN THE ARCHIVE Download and install from the Mplus site: http://www.statmodel.com/demo.shtml
%   Mplus_CRQA_ENT.inp                   - Mplus input file
%
%---------------------------------------
%
%
% Compiled and programmed by Fred Hasselman (me@fredhasselman.com) - December 2011



%% PATH to files and explanation of RAW DATA FILE

%-----------------------------------------------------------------------------------------
%  1. Insert on the dots '...' the path on your machine to where you unzipped the archive
%-----------------------------------------------------------------------------------------
cd('/...');

%---------------------------------------
%  2. Load data into a MATLAB matrix TS
%---------------------------------------
TS = load('TS_5s.txt');

% The file contains 4 columns:
% 1 - DYADNUMBER
% 2 - SESSION
% 3 - CHILD  BEHAVIOUR
% 4 - PARENT BEHAVIOUR
%
% The behaviour observation columns 3 and 4 can contain the following values
% 0 - contempt
% 1 - anger
% 2 - whine
% 3 - sad
% 4 - fear
% 5 - neutral
% 6 - interest
% 7 - humor/joy
% 8 - affection
% NaN - not a number, missing value

%% CATEGORICAL DYAD-RQA
%  1. Create an auto-recurrence matrix based on customly defined combinations of parent and child behaviour categories
%  2. Quantify the recurrence plot
%  3. Save the results for further analysis


% Loop through the dyads, but skip dyad 1108 -> this dyad has too many missing values
dyadnum = unique(TS(:,1));
dyadnum(dyadnum==1108) = [];

for dyad = 1:length(dyadnum)
 
 start = find(TS(:,1)==dyadnum(dyad),1,'first');
 ends  = find(TS(:,1)==dyadnum(dyad),1,'last');
 
 % Loop through the sessions for this dyad
 sessions = unique(TS(start:ends,2));
 for session = 1:length(sessions)
  
  % Get the data for the current session
  flag = 0;
  for r = start:ends
   if TS(r,2) == sessions(session)
    if flag == 0
     s = r;
     e = r+71; % The session time series are truncated to 72 datapoints
     flag = 1;
    end
   end
  end
  
  k = TS(s:e,3); % Child
  m = TS(s:e,4); % Parent
  
  %---------------------------------------
  % 1. Create the dyadic recurrence matrix
  %---------------------------------------
  
  dyadTS=zeros(numel(k),1);
  rp=zeros(numel(k),numel(m));
  
  % Create the dyadic time series
  for i=1:numel(k)
   
   % mutual hostility
   if k(i) == 0 && m(i) == 0 ; dyadTS(i) = 1; end
   if k(i) == 1 && m(i) == 0 ; dyadTS(i) = 1; end
   if k(i) == 2 && m(i) == 0 ; dyadTS(i) = 1; end
   if k(i) == 0 && m(i) == 1 ; dyadTS(i) = 1; end
   if k(i) == 1 && m(i) == 1 ; dyadTS(i) = 1; end
   if k(i) == 2 && m(i) == 1 ; dyadTS(i) = 1; end
   if k(i) == 0 && m(i) == 2 ; dyadTS(i) = 1; end
   if k(i) == 1 && m(i) == 2 ; dyadTS(i) = 1; end
   if k(i) == 2 && m(i) == 2 ; dyadTS(i) = 1; end
   
   % mother attack
   if k(i) == 3 && m(i) == 0 ; dyadTS(i) = 2; end
   if k(i) == 4 && m(i) == 0 ; dyadTS(i) = 2; end
   if k(i) == 5 && m(i) == 0 ; dyadTS(i) = 2; end
   if k(i) == 6 && m(i) == 0 ; dyadTS(i) = 2; end
   if k(i) == 7 && m(i) == 0 ; dyadTS(i) = 2; end
   if k(i) == 8 && m(i) == 0 ; dyadTS(i) = 2; end
   if k(i) == 3 && m(i) == 1 ; dyadTS(i) = 2; end
   if k(i) == 4 && m(i) == 1 ; dyadTS(i) = 2; end
   if k(i) == 5 && m(i) == 1 ; dyadTS(i) = 2; end
   if k(i) == 6 && m(i) == 1 ; dyadTS(i) = 2; end
   if k(i) == 7 && m(i) == 1 ; dyadTS(i) = 2; end
   if k(i) == 8 && m(i) == 1 ; dyadTS(i) = 2; end
   
   % permissive
   if k(i) == 0 && m(i) == 6 ; dyadTS(i) = 3; end
   if k(i) == 1 && m(i) == 6 ; dyadTS(i) = 3; end
   if k(i) == 2 && m(i) == 6 ; dyadTS(i) = 3; end
   if k(i) == 0 && m(i) == 7 ; dyadTS(i) = 3; end
   if k(i) == 1 && m(i) == 7 ; dyadTS(i) = 3; end
   if k(i) == 2 && m(i) == 7 ; dyadTS(i) = 3; end
   if k(i) == 0 && m(i) == 8 ; dyadTS(i) = 3; end
   if k(i) == 1 && m(i) == 8 ; dyadTS(i) = 3; end
   if k(i) == 2 && m(i) == 8 ; dyadTS(i) = 3; end
   
   % mutual neutral
   if k(i) == 5 && m(i) == 5 ; dyadTS(i) = 5; end
   
   % mutual positivity
   if k(i) == 6 && m(i) == 5 ; dyadTS(i) = 4; end
   if k(i) == 7 && m(i) == 5 ; dyadTS(i) = 4; end
   if k(i) == 8 && m(i) == 5 ; dyadTS(i) = 4; end
   if k(i) == 5 && m(i) == 6 ; dyadTS(i) = 4; end
   if k(i) == 6 && m(i) == 6 ; dyadTS(i) = 4; end
   if k(i) == 7 && m(i) == 6 ; dyadTS(i) = 4; end
   if k(i) == 8 && m(i) == 6 ; dyadTS(i) = 4; end
   if k(i) == 5 && m(i) == 7 ; dyadTS(i) = 4; end
   if k(i) == 6 && m(i) == 7 ; dyadTS(i) = 4; end
   if k(i) == 7 && m(i) == 7 ; dyadTS(i) = 4; end
   if k(i) == 8 && m(i) == 7 ; dyadTS(i) = 4; end
   if k(i) == 5 && m(i) == 8 ; dyadTS(i) = 4; end
   if k(i) == 6 && m(i) == 8 ; dyadTS(i) = 4; end
   if k(i) == 7 && m(i) == 8 ; dyadTS(i) = 4; end
   if k(i) == 8 && m(i) == 8 ; dyadTS(i) = 4; end
   
   % note that other = 0
   
  end
  
  
  for i=1:numel(dyadTS)
   for j=1:numel(dyadTS)
    if dyadTS(i)==dyadTS(j)
     rp(i,j)=dyadTS(i);
    end
   end
  end
  
  % Store multinomial ; rp matrix for later use
  RP(dyad,session).rp = double(rp);
  
  %-------------------------------------------------
  % 2. Call catrqa.m to quantify the current matrix
  %-------------------------------------------------
  
  % The catrqa script will automatically the ; rp to 0's and 1's.
  % Conversions are logged in boolean flags in the output
  % See catrqa.m for details
  Out(dyad,session)  = catrqa(rp);
  
  keep dyad dyadnum TS Out RP start ends session sessions
  
 end % for sessions...
 
 keep dyad dyadnum TS Out RP
 
end % for dyad ...

keep TS Out RP

%------------------
% 3. Save the data
%------------------

% Structure Out to a tab-delimited file
writeS2T(Out,'CRQA_dyadstates.dat');

% Save workspace as a Matlab file
save('CRQA_dyadstates.mat');

%% LCGA on CRQA measures (ENTROPY)
% 1. Write Output to a file readable by Mplus
% 2. Run the file in Mplus demo version (http://www.statmodel.com/demo.shtml) from the terminal (Mac OSX)

% If necessary uncomment the next line to load the data generated in the previous cell
% cd('/...')
load('CRQA_dyadstates.mat');


%---------------------
% 1. Write Mplus file
%---------------------

% Generate a header for the datafile
header = [{'dyad' 'dyadnum' 'session' 'sesnum'} fieldnames(Out)'];
prefix = 'CRQA_';

% Loop through the dyads, but skip dyad 1108 -> this dyad has too many missing values
dyadnum = unique(TS(:,1));
dyadnum(dyadnum==1108) = [];

% Generate a matrix of ENTROPY measures for each dyad and session
for dyad = 1:length(dyadnum)
 OutMplus(dyad,:)=[dyad Out(dyad,1).ENT_dl Out(dyad,2).ENT_dl Out(dyad,3).ENT_dl Out(dyad,4).ENT_dl Out(dyad,5).ENT_dl Out(dyad,6).ENT_dl];
end

% Write a comma seperated file that Mplus will understand
dlmwrite([prefix,header{11},'_Mplus','.dat'],OutMplus, 'newline', 'unix');

%--------------------------------------------
% 2. Run Mplus via terminal command (Mac OSX)
%--------------------------------------------

! /Applications/MplusDemo/mpdemo Mplus_CRQA_ENT.inp

% The results will be stored in a file named ENT_2cl.txt -> See the Mplus input file (Mplus_CRQA_ENT.inp) for details

keep TS Out RP

%% FIGURE 2 and CROSSTABULATION
% 1. Load LCGA results from Mplus output
% 2. Figure 2
% 3. Crosstabulate IMP with LCGA


%-------------------------------------------
% 1. Load the file that is created by Mplus
%-------------------------------------------
cd('/...')
filename='ENT_2cl.txt';
CAT=load(filename);

%Get indices of categories
%Find the column in CAT which has only 1 and 2 (13 or 14)
one=find(CAT(:,13)==1);
two=find(CAT(:,13)==2);
tot=CAT(:,13);

%-------------
% 2. Figure 2
%-------------

% This maximizes the figure window (better for grabbing to a file)
fig=gcf;
units=get(fig,'units');
set(fig,'units','normalized','outerposition',[0 0 1 1]);
set(fig,'units',units);


% Get a confidence bound for the means
ci = bootci(15000,@mean,CAT(one,1:6));
h1=errorbar([1:6]-.1,mean(CAT(one,1:6)),[mean(CAT(one,1:6))-ci(1,1:6)],...
 [mean(CAT(one,1:6))-ci(2,1:6)],'ok-','MarkerFaceColor',[.7 .7 .7]);
hold on;
ci = bootci(15000,@mean,CAT(two,1:6));
h2=errorbar([1:6]+.1,mean(CAT(two,1:6)),[mean(CAT(two,1:6))-ci(1,1:6)],...
 [mean(CAT(two,1:6))-ci(2,1:6)],'sk--','MarkerFaceColor',[.7 .7 .7]);
xlim([0.5 6.5]); ylim([1.5 4.5]);

ax0=gca;
set(ax0,'FontSize',14);

ylabel('Entropy of the length of diagonal line structures in the rp (CI_{.95})')
xlabel('Session')
title('Results of latent growth curve cluster analysis')
hold on;
%plot([1.5 1.5],[0 20],'-','Color',[.7 .7 .7]);

% Is the peak in group 1 or 2?
oneG = max(diff(mean(CAT(one,1:6))));
twoG = max(diff(mean(CAT(two,1:6))));

% Change to peak = 1; no peak = 0
if oneG > twoG
 legend([h1,h2],'LCGA: Peak in Entropy', 'LCGA: No peak in Entropy');
 tot(one)=1; tot(two)=0;
end;
if oneG < twoG
 legend([h1,h2],'LCGA: No peak in Entropy', 'LCGA: Peak in Entropy');
 tot(one)=0; tot(two)=1;
end;

%-----------------------------------------------------
% 3. CROSSTABULATE IMPROVERS with LATENT ENTROPY CLASS
%-----------------------------------------------------

% Improvers (=1) based on CAFAS score
imp=[0; 1; 0; 1; 0; 1; 0; 0; 1; 1; 1; 0; 0; 1; 1; 1; 0; 0; 0; 0; 1; 0; 0; 0; 1; 0; 0; 0; 0; 1; 0; 1; 1; 1; 0; 0; 0; 1; 0; 1; 1; 1];

ind=1:length(imp);
imp=imp(ind~=27); % dyad 27 / dyadnum=1108

[table,chi2,p,labels] = crosstab(imp,tot);

% Uncomment to plot the table in the figure
text(3,2,num2str(table));
text(3,1.8,['\chi^2 = ',num2str(chi2,'%2.2f'),',  p < ',num2str(p,'%2.2f')]);

% Grab the figure to EPS
grab('Figure2',0);


% Original dyadnumbers by Improve
%
% Dyad  Improver
% 202 0
% 203 1
% 204 0
% 205 1
% 602 0
% 604 1
% 605 0
% 606 0
% 710 1
% 712 1
% 713 1
% 714 0
% 901 0
% 903 1
% 904 1
% 905 1
% 908 0
% 909 0
% 910 0
% 912 0
% 1001 1
% 1003 0
% 1101 0
% 1102 0
% 1103 1
% 1107 0
% 1108 0 %removed
% 1109 0
% 1110 0
% 1201 1
% 1203 0
% 1302 1
% 1303 1
% 1304 1
% 1305 0
% 1308 0
% 1309 0
% 1310 1
% 1401 0
% 1403 1
% 1405 1
% 1409 1

%% KOLMOGOROV-SMIRNOV and FIGURE 3
% 1. Create summaries for analysis and plotting (the code uses unnessecary steps included demonstration pu; rposes)
% 2. Analyse K-S for two samples
% 3. Figure 3

% If necessary uncomment the next lines to load the data generated in the previous cells
%cd('/...');
CAT=load('ENT_2cl.txt');
load('CRQA_dyadstates.mat');

imp=[0; 1; 0; 1; 0; 1; 0; 0; 1; 1; 1; 0; 0; 1; 1; 1; 0; 0; 0; 0; 1; 0; 0; 0; 1; 0; 0; 0; 0; 1; 0; 1; 1; 1; 0; 0; 0; 1; 0; 1; 1; 1];
ind=1:length(imp);
imp=imp(ind~=27); %exclude dyad 27

%Get indices of categories
one=find(CAT(:,14)==1);
two=find(CAT(:,14)==2);
tot=CAT(:,14);

% Is the peak in group 1 or 2?
oneG = max(diff(mean(CAT(one,1:6))));
twoG = max(diff(mean(CAT(two,1:6))));

% Change to peak = 1; no peak = 0
if oneG > twoG
 tot(one)=1; tot(two)=0;
end;
if oneG < twoG
 tot(one)=0; tot(two)=1;
end;


%---------------------------------------------
% 1. Summarize measures based on LCGA and IMP
%---------------------------------------------

% Get recurrences for each category
cnt=0;
dy=0;
for i=1:41
 dy=dy+1;
 for j=1:6
  cnt=cnt+1;
  frqs(cnt,:)=flipud(diag(RP(i,j).rp'));
  tab = tabulate(frqs(cnt,:));
  dyad(dy).peak = tot(dy);
  dyad(dy).imp = imp(i);
  for k=1:6
   ct=tab(tab(:,1)==k-1,2);
   if isempty(ct)
    ct=0;
   end
   dyad(dy).cat(k,j) = ct;
   clear ct
  end
  clear tab
 end
end

% Create a lot of matrices... some redundancy here, but allows for easy inspection of the data

cntpk=0;
cntnpk=0;
cntimp=0;
cntnimp=0;

for i=1:length(dyad)
 if dyad(i).peak==1
  cntpk=cntpk+1;
  catsPK1(cntpk,1:8) = [1 i dyad(i).cat(1,:)];
  catsPK2(cntpk,1:8) = [1 i dyad(i).cat(2,:)];
  catsPK3(cntpk,1:8) = [1 i dyad(i).cat(3,:)];
  catsPK4(cntpk,1:8) = [1 i dyad(i).cat(4,:)];
  catsPK5(cntpk,1:8) = [1 i dyad(i).cat(5,:)];
  catsPK6(cntpk,1:8) = [1 i dyad(i).cat(6,:)];
  catsPKENT(cntpk,1:8) = [1 i CAT(i,1:6)];
  
 else
  cntnpk=cntnpk+1;
  catsnPK1(cntnpk,1:8) = [0 i dyad(i).cat(1,:)];
  catsnPK2(cntnpk,1:8) = [0 i dyad(i).cat(2,:)];
  catsnPK3(cntnpk,1:8) = [0 i dyad(i).cat(3,:)];
  catsnPK4(cntnpk,1:8) = [0 i dyad(i).cat(4,:)];
  catsnPK5(cntnpk,1:8) = [0 i dyad(i).cat(5,:)];
  catsnPK6(cntnpk,1:8) = [0 i dyad(i).cat(6,:)];
  catsnPKENT(cntnpk,1:8) = [0 i CAT(i,1:6)];
 end
 if dyad(i).imp==1
  cntimp=cntimp+1;
  catsIMP1(cntimp,1:8) = [1 i dyad(i).cat(1,:)];
  catsIMP2(cntimp,1:8) = [1 i dyad(i).cat(2,:)];
  catsIMP3(cntimp,1:8) = [1 i dyad(i).cat(3,:)];
  catsIMP4(cntimp,1:8) = [1 i dyad(i).cat(4,:)];
  catsIMP5(cntimp,1:8) = [1 i dyad(i).cat(5,:)];
  catsIMP6(cntimp,1:8) = [1 i dyad(i).cat(6,:)];
  catsIMPENT(cntimp,1:8) = [1 i CAT(i,1:6)];
 else
  cntnimp=cntnimp+1;
  catsnIMP1(cntnimp,1:8) = [0 i dyad(i).cat(1,:)];
  catsnIMP2(cntnimp,1:8) = [0 i dyad(i).cat(2,:)];
  catsnIMP3(cntnimp,1:8) = [0 i dyad(i).cat(3,:)];
  catsnIMP4(cntnimp,1:8) = [0 i dyad(i).cat(4,:)];
  catsnIMP5(cntnimp,1:8) = [0 i dyad(i).cat(5,:)];
  catsnIMP6(cntnimp,1:8) = [0 i dyad(i).cat(6,:)];
  catsnIMPENT(cntnimp,1:8) = [0 i CAT(i,1:6)];
 end
end

CAT1 = [catsPK1; catsnPK1];
CAT2 = [catsPK2; catsnPK2];
CAT3 = [catsPK3; catsnPK3];
CAT4 = [catsPK4; catsnPK4];
CAT5 = [catsPK5; catsnPK5];
CAT6 = [catsPK6; catsnPK6];
CATE = [catsPKENT; catsnPKENT];

% Uncomment the below to write the data to a tabdelimited file
% header = {'PEAK','Dyadnr','session1','session2','session3','session4','session5','session6'};
% writeM2T(CAT1,'CAT1.dat',header,'%.0f');
% writeM2T(CAT2,'CAT2.dat',header,'%.0f');
% writeM2T(CAT3,'CAT3.dat',header,'%.0f');
% writeM2T(CAT4,'CAT4.dat',header,'%.0f');
% writeM2T(CAT5,'CAT5.dat',header,'%.0f');
% writeM2T(CAT6,'CAT6.dat',header,'%.0f');
% writeM2T(CATE,'CATE.dat',header,'%1.2f');

CATe1 = [catsIMP1; catsnIMP1];
CATe2 = [catsIMP2; catsnIMP2];
CATe3 = [catsIMP3; catsnIMP3];
CATe4 = [catsIMP4; catsnIMP4];
CATe5 = [catsIMP5; catsnIMP5];
CATe6 = [catsIMP6; catsnIMP6];
CATeE = [catsIMPENT; catsnIMPENT];

% Uncomment the lines below to write the data to a tabdelimited file
% header = {'IMP','Dyadnr','session1','session2','session3','session4','session5','session6'};
% writeM2T(CATe1,'CATimp1.dat',header,'%.0f');
% writeM2T(CATe2,'CATimp2.dat',header,'%.0f');
% writeM2T(CATe3,'CATimp3.dat',header,'%.0f');
% writeM2T(CATe4,'CATimp4.dat',header,'%.0f');
% writeM2T(CATe5,'CATimp5.dat',header,'%.0f');
% writeM2T(CATe6,'CATimp6.dat',header,'%.0f');
% writeM2T(CATeE,'CATimpE.dat',header,'%1.2f');


%-----------------------------
% 2. Kolmogorov-Smirnov tests
%-----------------------------

n=6;
alphaN=0.05;
alpha=alphaN/n; % Bonferroni adjustment
%alpha=1-(1-alphaN)^(1/n); % Sidak adjusment

categ = {'Other','Mutual Hostility','Mother Attack','Permissive','Mutual Positive','Entropy of rp'};
disp(' ');disp(' ');disp(' ');

for i =1:n
 [KSe1.h(i),KSe1.p(i),KSe1.stats(i)]=kstest2(CATe1(CATe1(:,1)==0,2+i),CATe1(CATe1(:,1)==1,2+i),alpha);
end

disp('--------------------------------------');
disp('IMP-NOIMP difference for each session:');
disp(categ{1});
disp(1:6);
disp(KSe1.h);
disp(['(1 = sig. at alpha = ',num2str(alpha,'%1.3f')]);
disp(' ');

for i=1:n
 [KSe2.h(i),KSe2.p(i),KSe2.stats(i)]=kstest2(CATe2(CATe2(:,1)==0,2+i),CATe2(CATe2(:,1)==1,2+i),alpha);
end

disp('--------------------------------------');
disp('IMP-NOIMP difference for each session:');
disp(categ{2});
disp(1:6);
disp(KSe2.h);
disp(['(1 = sig. at alpha = ',num2str(alpha,'%1.3f')]);
disp(' ');


for i=1:n
 [KSe3.h(i),KSe3.p(i),KSe3.stats(i)]=kstest2(CATe3(CATe3(:,1)==0,2+i),CATe3(CATe3(:,1)==1,2+i),alpha);
end

disp('--------------------------------------');
disp('IMP-NOIMP difference for each session:');
disp(categ{3});
disp(1:6);
disp(KSe3.h);
disp(['(1 = sig. at alpha = ',num2str(alpha,'%1.3f')]);
disp(' ');

for i=1:n
 [KSe4.h(i),KSe4.p(i),KSe4.stats(i)]=kstest2(CATe4(CATe4(:,1)==0,2+i),CATe4(CATe4(:,1)==1,2+i),alpha);
end

disp('--------------------------------------');
disp('IMP-NOIMP difference for each session:');
disp(categ{4});
disp(1:6);
disp(KSe4.h);
disp(['(1 = sig. at alpha = ',num2str(alpha,'%1.3f')]);
disp(' ');

for i=1:n
 [KSe5.h(i),KSe5.p(i),KSe5.stats(i)]=kstest2(CATe5(CATe5(:,1)==0,2+i),CATe5(CATe5(:,1)==1,2+i),alpha);
end

disp('--------------------------------------');
disp('IMP-NOIMP difference for each session:');
disp(categ{5});
disp(1:6);
disp(KSe5.h);
disp(['(1 = sig. at alpha = ',num2str(alpha,'%1.3f')]);
disp(' ');


for i=1:n
 [KSeE.h(i),KSeE.p(i),KSeE.stats(i)]=kstest2(CATeE(CATeE(:,1)==0,2+i),CATeE(CATeE(:,1)==1,2+i),alpha);
end

disp('--------------------------------------');
disp('IMP-NOIMP difference for each session:');
disp(categ{6});
disp(1:6);
disp(KSeE.h);
disp(['(1 = sig. at alpha = ',num2str(alpha,'%1.3f')]);
disp(' ');

keep CATe1 CATe2 CATe3 CATe4 CATe5 CATe6 CATeE categ KSe1 KSe2 KSe3 KSe4 KSe5 KSeE alpha

save('KSresults.mat');


%---------------------------------------------
% 3. Plot the results
%---------------------------------------------

% This maximizes the figure window (better for grabbing to a file)
fig=gcf;
units=get(fig,'units');
set(fig,'units','normalized','outerposition',[0 0 1 1]);
set(fig,'units',units);

ymax = 25;

subplot(2,3,1)

ci = bootci(15000,@mean,CATe1(CATe1(:,1)==1,3:8));
h1=errorbar([0.9:5.9],mean(CATe1(CATe1(:,1)==1,3:8)),...
 (mean(CATe1(CATe1(:,1)==1,3:8))-ci(1,1:6)),...
 (mean(CATe1(CATe1(:,1)==1,3:8))-ci(2,1:6)),'-ko','MarkerFaceColor',[.7 .7 .7]);hold on;
ci = bootci(15000,@mean,CATe1(CATe1(:,1)==0,3:8));
h2=errorbar([1.1:6.1],mean(CATe1(CATe1(:,1)==0,3:8)),...
 (mean(CATe1(CATe1(:,1)==0,3:8))-ci(1,1:6)),...
 (mean(CATe1(CATe1(:,1)==0,3:8))-ci(2,1:6)),'--ks','MarkerFaceColor',[.7 .7 .7]);hold on;
h3=plot([1:6],mean(CATe1(:,3:8)),':k');hold on;
%plot([1.5 1.5],[0 ymax],'-','Color',[.7 .7 .7]);


ax0=gca;
set(ax0,'FontSize',14);

xlabel('Session');ylabel('Average Recurrence Rate (CI_{.95})');
legend([h1,h2,h3],'IMP dyad','Non IMP dyad','Sample mean','Location','Best');

ylim([0 ymax]);
xlim([0.5 6.5]);
title(categ(1));

subplot(2,3,2)
ci = bootci(15000,@mean,CATe2(CATe2(:,1)==1,3:8));
h1=errorbar([0.9:5.9],mean(CATe2(CATe2(:,1)==1,3:8)),...
 (mean(CATe2(CATe2(:,1)==1,3:8))-ci(1,1:6)),...
 (mean(CATe2(CATe2(:,1)==1,3:8))-ci(2,1:6)),'-ko','MarkerFaceColor',[.7 .7 .7]);hold on;
ci = bootci(15000,@mean,CATe2(CATe2(:,1)==0,3:8));
h2=errorbar([1.1:6.1],mean(CATe2(CATe2(:,1)==0,3:8)),...
 (mean(CATe2(CATe2(:,1)==0,3:8))-ci(1,1:6)),...
 (mean(CATe2(CATe2(:,1)==0,3:8))-ci(2,1:6)),'--ks','MarkerFaceColor',[.7 .7 .7]);hold on;
h3=plot([1:6],mean(CATe2(:,3:8)),':k');hold on;
%plot([1.5 1.5],[0 ymax],'-','Color',[.7 .7 .7]);


ax0=gca;
set(ax0,'FontSize',14);

xlabel('Session');ylabel('Average Recurrence Rate (CI_{.95})');

legend([h1,h2,h3],'IMP dyad','Non IMP dyad','Sample mean','Location','Best');
ylim([0 ymax]);
xlim([0.5 6.5]);
title(categ(2));

subplot(2,3,3)
ci = bootci(15000,@mean,CATe3(CATe3(:,1)==1,3:8));
h1=errorbar([0.9:5.9],mean(CATe3(CATe3(:,1)==1,3:8)),...
 (mean(CATe3(CATe3(:,1)==1,3:8))-ci(1,1:6)),...
 (mean(CATe3(CATe3(:,1)==1,3:8))-ci(2,1:6)),'-ko','MarkerFaceColor',[.7 .7 .7]);hold on;
ci = bootci(15000,@mean,CATe3(CATe3(:,1)==0,3:8));
h2=errorbar([1.1:6.1],mean(CATe3(CATe3(:,1)==0,3:8)),...
 (mean(CATe3(CATe3(:,1)==0,3:8))-ci(1,1:6)),...
 (mean(CATe3(CATe3(:,1)==0,3:8))-ci(2,1:6)),'--ks','MarkerFaceColor',[.7 .7 .7]);hold on;
h3=plot([1:6],mean(CATe3(:,3:8)),':k');hold on;
%plot([1.5 1.5],[0 ymax],'-','Color',[.7 .7 .7]);


ax0=gca;
set(ax0,'FontSize',14);

xlabel('Session');ylabel('Average Recurrence Rate (CI_{.95})');

legend([h1,h2,h3],'IMP dyad','Non IMP dyad','Sample mean','Location','Best');
ylim([0 ymax]);
xlim([0.5 6.5]);
title(categ(3));

subplot(2,3,4)
ci = bootci(15000,@mean,CATe4(CATe4(:,1)==1,3:8));
h1=errorbar([0.9:5.9],mean(CATe4(CATe4(:,1)==1,3:8)),...
 (mean(CATe4(CATe4(:,1)==1,3:8))-ci(1,1:6)),...
 (mean(CATe4(CATe4(:,1)==1,3:8))-ci(2,1:6)),'-ko','MarkerFaceColor',[.7 .7 .7]);hold on;
ci = bootci(15000,@mean,CATe4(CATe4(:,1)==0,3:8));
h2=errorbar([1.1:6.1],mean(CATe4(CATe4(:,1)==0,3:8)),...
 (mean(CATe4(CATe4(:,1)==0,3:8))-ci(1,1:6)),...
 (mean(CATe4(CATe4(:,1)==0,3:8))-ci(2,1:6)),'--ks','MarkerFaceColor',[.7 .7 .7]);hold on;
h3=plot([1:6],mean(CATe4(:,3:8)),':k');hold on;
%plot([1.5 1.5],[0 ymax],'-','Color',[.7 .7 .7]);


ax0=gca;
set(ax0,'FontSize',14);

xlabel('Session');ylabel('Average Recurrence Rate (CI_{.95})');

legend([h1,h2,h3],'IMP dyad','Non IMP dyad','Sample mean','Location','Best');
ylim([0 ymax]);
xlim([0.5 6.5]);
title(categ(4));

subplot(2,3,5)
ci = bootci(15000,@mean,CATe5(CATe5(:,1)==1,3:8));
h1=errorbar([0.9:5.9],mean(CATe5(CATe5(:,1)==1,3:8)),...
 (mean(CATe5(CATe5(:,1)==1,3:8))-ci(1,1:6)),...
 (mean(CATe5(CATe5(:,1)==1,3:8))-ci(2,1:6)),'-ko','MarkerFaceColor',[.7 .7 .7]);hold on;
ci = bootci(15000,@mean,CATe5(CATe5(:,1)==0,3:8));
h2=errorbar([1.1:6.1],mean(CATe5(CATe5(:,1)==0,3:8)),...
 (mean(CATe5(CATe5(:,1)==0,3:8))-ci(1,1:6)),...
 (mean(CATe5(CATe5(:,1)==0,3:8))-ci(2,1:6)),'--ks','MarkerFaceColor',[.7 .7 .7]);hold on;
h3=plot([1:6],mean(CATe5(:,3:8)),':k');hold on;
%plot([1.5 1.5],[0 ymax],'-','Color',[.7 .7 .7]);


ax0=gca;
set(ax0,'FontSize',14);

xlabel('Session');ylabel('Average Recurrence Rate (CI_{.95})');

legend([h1,h2,h3],'IMP dyad','Non IMP dyad','Sample mean','Location','Best');
ylim([0 ymax]);
xlim([0.5 6.5]);
title(categ(5));

subplot(2,3,6)
ci = bootci(15000,@mean,CATeE(CATeE(:,1)==1,3:8));
h1=errorbar([0.9:5.9],mean(CATeE(CATeE(:,1)==1,3:8)),...
 (mean(CATeE(CATeE(:,1)==1,3:8))-ci(1,1:6)),...
 (mean(CATeE(CATeE(:,1)==1,3:8))-ci(2,1:6)),'-ko','MarkerFaceColor',[.7 .7 .7]);hold on;
ci = bootci(15000,@mean,CATeE(CATeE(:,1)==0,3:8));
h2=errorbar([1.1:6.1],mean(CATeE(CATeE(:,1)==0,3:8)),...
 (mean(CATeE(CATeE(:,1)==0,3:8))-ci(1,1:6)),...
 (mean(CATeE(CATeE(:,1)==0,3:8))-ci(2,1:6)),'--ks','MarkerFaceColor',[.7 .7 .7]);hold on;
h3=plot([1:6],mean(CATeE(:,3:8)),':k');hold on;
%plot([1.5 1.5],[0 ymax],'-','Color',[.7 .7 .7]);


ax0=gca;
set(ax0,'FontSize',14);

xlabel('Session');ylabel('Average Entropy (CI_{.95})');

legend([h1,h2,h3],'IMP dyad','Non IMP dyad','Sample mean','Location','Best');
set(gca,'XTick',[1 2 3 4 5 6]);
ylim([2 5]);
set(gca,'YTick',[2 2.5 3 3.5 4 4.5 5]);
xlim([0.5 6.5]);
title('Entropy of the diagonal line structures in the rp');

% Grab to EPS
grab('Figure3',0');
clear all

%%
% Calulate Kolmogorov-Smirnov Z from D statistic
load('KSresults.mat')
n1=numel(CATeE(CATeE==1));
n2=numel(CATeE(CATeE==0));
KSZeE=KSeE.stats.*(sqrt((n1*n2)/(n1+n2)));


%% Figure 1 RP examples
% Grab 6 sessions from 10 dyads

load('CRQA_dyadstates.mat');
dyadnum = unique(TS(:,1));
dyadnum(dyadnum==1108) = [];

% These dyads will be plotted
dyadnums=[6 30];
r=numel(dyadnums);
mrkr={'o','s'};
lsp={'-ko','--ks'};

f0=figure;
maximize(f0);
cm=colormap(gray(2));
cm=flipud(cm);
colormap(cm);

cnt=0;
subs   = reshape(1:6*r*2,6,2*r)';
for i=1:2:2*r
 cnt=cnt+1;
 subsRP(cnt,:) = subs(i+1,:);
 subsTS(cnt,:) = subs(i,:);
end


cnt=0;
%for i=1:r
 for j=1:6
  rp=RP(6,j).rp;
  cnt=cnt+1;
  
  %subplot(r*2,6,subsRP(i,j))
  subplot(2,6,j)
  imagesc(rp,[0 5]); hold on;
  plot([1 72],[1 72],'-','LineWidth',2,'Color',[.5 .5 .5]); hold on;
  axis square xy
  
  
  ax0=gca;
  set(ax0,'FontSize',14);
  
  
  title(['RP of session ',num2str(j)]);
  %if j==1; ylabel(['Dyad: ',num2str(dyadnum(dyadnums(i)))]);end
  %ylabel(['Dyad: ',num2str(dyadnum(dyadnums(i)))]);
  xlabel(['H_{DLL}: ',num2str(Out(6,j).ENT_dl,'%1.3f')]);
  set(gca,'XTickLabel',[],'YTickLabel',[]);
  ents(i,j)=Out(6,j).ENT_dl;
  
  rp=RP(30,j).rp;
  cnt=cnt+1;
  
  %subplot(r*2,6,subsRP(i,j))
  subplot(2,6,j+6)
  imagesc(rp,[0 5]); hold on;
  plot([1 72],[1 72],'-','LineWidth',2,'Color',[.5 .5 .5]); hold on;
  axis square xy
  
  
  ax0=gca;
  set(ax0,'FontSize',14);
  
  
  title(['RP of session ',num2str(j)]);
  %if j==1; ylabel(['Dyad: ',num2str(dyadnum(dyadnums(i)))]);end
  %ylabel(['Dyad: ',num2str(dyadnum(dyadnums(i)))]);
  xlabel(['H_{DLL}: ',num2str(Out(30,j).ENT_dl,'%1.3f')]);
  set(gca,'XTickLabel',[],'YTickLabel',[]);
  ents(i,j)=Out(30,j).ENT_dl;
  
  
  
  
 end
 %     subplot(r*2,6,[subsTS(i,1) subsTS(i,6)]);
 %     %plot(1:6,ents(i,:),'-k','LineStyle',lst,'Marker',mrkr{i},'MarkerFaceColor',[.7 .7 .7]); hold on;
 %     plot(1:6,ents(i,:),lsp{i},'MarkerFaceColor',[.7 .7 .7]); hold on;
 %     xlim([0.6 6.4]); ylim([0.5 4.5]);
 %     set(gca,'XTick',[1:6], 'XTickLabel',[],'YTick',[1 2 3 4],...
 %         'YGrid','on','TickLength',[.005 .005]); %,...
 %          % 'XTickLabel',{'Session: 1','Session: 2','Session: 3','Session: 4','Session: 5','Session: 6'});
 %     title(['Dyad: ',num2str(dyadnum(dyadnums(i)))]);
 %     ylabel('Entropy (H_{DLL})');
 
%end

grab('Figure1',0);
