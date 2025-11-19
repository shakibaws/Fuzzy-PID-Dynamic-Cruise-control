%% build_fuzzy_pid.m
% Run this script ONCE to create fuzzy_pid.fis

% Create Mamdani FIS
fis = mamfis('Name','fuzzyPID');

% === Inputs: e and de ===
fis = addInput(fis,[-10 10],'Name','e');      % error
fis = addInput(fis,[-10 10],'Name','de');     % derivative of error

% Membership functions for e
fis = addMF(fis,'e','trapmf',[-10 -10 -5 0],'Name','Negative');
fis = addMF(fis,'e','trimf',[-5 0 5],'Name','Zero');
fis = addMF(fis,'e','trapmf',[0 5 10 10],'Name','Positive');

% Membership functions for de
fis = addMF(fis,'de','trapmf',[-10 -10 -5 0],'Name','Negative');
fis = addMF(fis,'de','trimf',[-5 0 5],'Name','Zero');
fis = addMF(fis,'de','trapmf',[0 5 10 10],'Name','Positive');

% === Outputs: alpha_p and alpha_i (scaling factors) ===
fis = addOutput(fis,[0.5 1.5],'Name','alpha_p');
fis = addOutput(fis,[0.5 1.5],'Name','alpha_i');

fis = addMF(fis,'alpha_p','trimf',[0.5 0.5 1.0],'Name','Small');
fis = addMF(fis,'alpha_p','trimf',[0.8 1.0 1.2],'Name','Medium');
fis = addMF(fis,'alpha_p','trimf',[1.0 1.5 1.5],'Name','Large');

fis = addMF(fis,'alpha_i','trimf',[0.5 0.5 1.0],'Name','Small');
fis = addMF(fis,'alpha_i','trimf',[0.8 1.0 1.2],'Name','Medium');
fis = addMF(fis,'alpha_i','trimf',[1.0 1.5 1.5],'Name','Large');

% === Rules (9 simple rules) ===
ruleList = [...
    1 1 3 3 1 1;  % e N, de N -> alpha_p Large,  alpha_i Large
    1 2 3 2 1 1;  % e N, de Z -> Large,  Medium
    1 3 2 1 1 1;  % e N, de P -> Medium, Small
    2 1 2 3 1 1;  % e Z, de N -> Medium, Large
    2 2 1 1 1 1;  % e Z, de Z -> Small,  Small
    2 3 2 1 1 1;  % e Z, de P -> Medium, Small
    3 1 2 2 1 1;  % e P, de N -> Medium, Medium
    3 2 2 3 1 1;  % e P, de Z -> Medium, Large
    3 3 1 1 1 1]; % e P, de P -> Small,  Small

fis = addRule(fis,ruleList);

% Save to file
writeFIS(fis,'fuzzy_pid');

disp('Fuzzy system saved as fuzzy_pid.fis');