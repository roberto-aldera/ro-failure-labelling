% generate bigger dataset from multiple places - 4 datasets together should
% be 2023 frames

% 2018-03-09-13-33-34-thorsmork-boulders-1
% Frame 100 to 1067
labels_1 = csvread('/Users/roberto/data/RO-logging/2018-11-19-14-17-36/labels.csv');
maxEVec_1 = csvread('/Users/roberto/data/RO-logging/2018-11-19-14-17-36/sorted_eigenvectors.csv');

% Penfold/2018-08-15-10-31-14-blenheim-loop-2
% Frame 2200 to 2506 
labels_2 = csvread('/Users/roberto/data/RO-logging/2018-11-19-14-14-58/labels.csv');
maxEVec_2 = csvread('/Users/roberto/data/RO-logging/2018-11-19-14-14-58/sorted_eigenvectors.csv');

% Penfold/2018-08-15-10-45-32-blenheim-loop-3
% Frame 2100 to 2345
labels_3 = csvread('/Users/roberto/data/RO-logging/2018-11-19-14-10-39/labels.csv');
maxEVec_3 = csvread('/Users/roberto/data/RO-logging/2018-11-19-14-10-39/sorted_eigenvectors.csv');

% Muttley/2018-06-21-15-58-58-rural-loop-v4-radar-leopon-trial-sunny-long-range
% Frame 220 to 725
labels_4 = csvread('/Users/roberto/data/RO-logging/2018-11-19-14-01-12/labels.csv');
maxEVec_4 = csvread('/Users/roberto/data/RO-logging/2018-11-19-14-01-12/sorted_eigenvectors.csv');

% Muttley/2017-08-21-11-24-08-jericho-backstreets-loops-with-radar-1
% Frame 200 to 1221
labels_5 = csvread('/Users/roberto/data/RO-logging/2018-11-22-11-32-19/labels.csv');
maxEVec_5 = csvread('/Users/roberto/data/RO-logging/2018-11-22-11-32-19/sorted_eigenvectors.csv');

% Muttley/2018-06-21-15-58-58-rural-loop-v4-radar-leopon-trial-sunny-long-range
% Frame 750 to 1408
labels_6 = csvread('/Users/roberto/data/RO-logging/2018-11-22-11-56-16/labels.csv');
maxEVec_6 = csvread('/Users/roberto/data/RO-logging/2018-11-22-11-56-16/sorted_eigenvectors.csv');

% Muttley/2017-08-18-11-21-04-oxford-10k-with-radar-1
% Frame 200 to 1211
labels_7 = csvread('/Users/roberto/data/RO-logging/2018-11-22-12-07-01/labels.csv');
maxEVec_7 = csvread('/Users/roberto/data/RO-logging/2018-11-22-12-07-01/sorted_eigenvectors.csv');

classifications = {labels_1,labels_2,labels_3,labels_4,labels_5,labels_6,labels_7};
maxEVecs = {maxEVec_1,maxEVec_2,maxEVec_3,maxEVec_4,maxEVec_5,maxEVec_6,maxEVec_7};

csvwrite('/Users/roberto/data/RO-logging/labels-ro-dataset.csv',classifications);
csvwrite('/Users/roberto/data/RO-logging/1maxEVecs-ro-dataset.csv',maxEVecs{1});
csvwrite('/Users/roberto/data/RO-logging/2maxEVecs-ro-dataset.csv',maxEVecs{2});
csvwrite('/Users/roberto/data/RO-logging/3maxEVecs-ro-dataset.csv',maxEVecs{3});
csvwrite('/Users/roberto/data/RO-logging/4maxEVecs-ro-dataset.csv',maxEVecs{4});
csvwrite('/Users/roberto/data/RO-logging/5maxEVecs-ro-dataset.csv',maxEVecs{5});
csvwrite('/Users/roberto/data/RO-logging/6maxEVecs-ro-dataset.csv',maxEVecs{6});
csvwrite('/Users/roberto/data/RO-logging/7maxEVecs-ro-dataset.csv',maxEVecs{7});


