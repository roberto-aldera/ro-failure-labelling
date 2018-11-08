hasBeenRun = true;
if(hasBeenRun == false)
    clear;clf;
    % Read in values and plot them
    dateAndTime = "2018-11-06-17-09-38/";
    filename = '/Users/roberto/data/RO-logging/'+dateAndTime;
    xyz_yaw_raw = csvread(filename+'xyz_yaw.csv');
    MaxEVec_raw = csvread(filename+'MaxEVec.csv');
    C_matrix_raw = csvread(filename+'compatibility_matrix.csv');
end
start_index = 1;
end_index = length(xyz_yaw_raw) - 0;
xyz_yaw = xyz_yaw_raw(start_index:end_index,:);
MaxEVec = MaxEVec_raw(start_index:end_index,:);

C_matrix = C_matrix_raw(start_index:end_index,:);

[a,b] = size(MaxEVec);
num_instances = a;

max_C_size = max(C_matrix_raw(:,1));
current_C_matrix_size = C_matrix_raw(1,1);
C_matrix_temp = C_matrix_raw(1:current_C_matrix_size, 1:current_C_matrix_size);
blanks = max_C_size - current_C_matrix_size;
D = padarray(C_matrix_temp,[blanks blanks],0,'post');
allCs = D;
num_processed = C_matrix_raw(1,1) + 1;
current_C_matrix_size = C_matrix_raw(num_processed,1);

for i = 2:num_instances
    C_matrix_temp = C_matrix_raw(num_processed:(current_C_matrix_size+num_processed-1), ...
        1:current_C_matrix_size);
    blanks = max_C_size - current_C_matrix_size;
    D = padarray(C_matrix_temp,[blanks blanks],0,'post');
    allCs = cat(3,allCs,D);
    num_processed = num_processed+current_C_matrix_size;
    current_C_matrix_size = C_matrix_raw(num_processed,1);
end

[m,n] = size(xyz_yaw);
total_xyz_yaw = zeros(m,n);
for i = 2:num_instances
    total_xyz_yaw(i,1) = total_xyz_yaw(i-1,1) + xyz_yaw(i,1);
    total_xyz_yaw(i,2) = total_xyz_yaw(i-1,2) + xyz_yaw(i,2);
end
%  figure(1);
%  plot(total_xyz_yaw(:,1),total_xyz_yaw(:,2), 'o--','LineWidth',3, ...
%         'MarkerEdgeColor','r');
%  axis equal
%
% figure(2);
% clf;
%
for i = 1:num_instances
    MaxEVec(i,:) = sort(MaxEVec(i,:),'descend');
    %     plot(MaxEVec(i,:),'o');
    %     hold on;
end

% classification = zeros(1,num_instances);
% LastSuccessfulPoints = [0,0;0,0];
LastSuccessfulPoints = [total_xyz_yaw(2,1),total_xyz_yaw(2,2); ...
    total_xyz_yaw(1,1),total_xyz_yaw(1,2)];

for i = 3:num_instances
    CurrentPoints = [total_xyz_yaw(i-1,1),total_xyz_yaw(i-1,2); ...
        total_xyz_yaw(i,1),total_xyz_yaw(i,2)];
    PreviousPoints = [total_xyz_yaw(i-2,1),total_xyz_yaw(i-2,2); ...
        total_xyz_yaw(i-1,1),total_xyz_yaw(i-1,2)];
    %     LastSuccessfulPoints = PreviousPoints;
    if(pdist(CurrentPoints,'Euclidean')>(3*pdist(LastSuccessfulPoints,'Euclidean')))
%         classification(i) = 1;
    else
        LastSuccessfulPoints = PreviousPoints;
    end
end


f1 = figure(3);
clf;
colour = [];
sf(1) = subplot(2,2,1);
plot(total_xyz_yaw(:,1),total_xyz_yaw(:,2), ':','LineWidth',3, ...
    'MarkerEdgeColor','k','Color',[0.9290    0.6940    0.1250]);
xlabel('X position (m)');
ylabel('Y position (m)');

sf(3) = subplot(2,2,3);
plot(xyz_yaw(:,1),'o--');
hold on;
plot(xyz_yaw(:,2),'o--');
hold on;
plot(rad2deg(xyz_yaw(:,4)),'o--');
xlabel('Pose iteration');
ylabel('m/s, degrees');
legend('X speed', 'Y speed','Yaw rate');
title('Speeds and yaw rates');
% t = linspace(0, num_instances, num_instances);


newTemp = [zeros(1, 1803); diff(MaxEVec,1,1)];

for i = 2:num_instances
    if(classification(i) == 1)
        colour = 'r';
        %     elseif(classification(i-1) == 1 && classification(i) == 0)
        %         colour = 'g';
    else
        colour = 'b';
    end
    sf(1) = subplot(2,2,1);
    title('Poses for RO performance Blenheim loop 3 - 15-08-2018, around frame 2220');
    hold on;
    plot(total_xyz_yaw(i,1),total_xyz_yaw(i,2), 'o','LineWidth',3,'MarkerEdgeColor',colour);
    axis equal
    
    sf(2) = subplot(2,2,2);
    title('Eigenvectors');
    xlabel('Element index');
    ylabel('Eigenvector magnitude');
    hold on;
    plot(newTemp(i,:),'.','Color',colour);
    
%     sf(3) = subplot(2,2,3);
%     plot(t(i),xyz_yaw(i,1),'o--','Color',colour);
%     hold on;
%     plot(t(i),xyz_yaw(i,2),'o--','Color',colour);
%     hold on;
%     plot(t(i),xyz_yaw(i,4),'o--','Color',colour);
%     hold on;
    
    sf(4) = subplot(2,2,4);
    temp_eigvals = eig(allCs(:,:,i));
    plot(temp_eigvals(temp_eigvals>0), 'Color', colour);
    hold on;
    title('Eigenvalues');
    xlabel('Element index');
    ylabel('Eigenvalue magnitude');
    pause(0.5);
end

h = zeros(2, 1);
h(1) = plot(NaN,NaN,'or');
h(2) = plot(NaN,NaN,'ob');
legend(h, 'Failure','Success');

% figure(4);
% [v,d] = eig(allCs(:,:,1));
% for i = 1:num_instances
%     if(classification(i) == 1)
%         colour = 'r';
%     else
%         colour = 'b';
%     end
%     temp_eigvals = eig(allCs(:,:,i));
%
%     plot(temp_eigvals, 'Color', colour);
%     hold on;
% end

% figure(4);
% plot(xyz_yaw(:,4),'o--');

%  figure(2);
%  plot(total_X_Y_Z_yaw(1,:),total_X_Y_Z_yaw(2,:), 'o--','LineWidth',3, ...
%         'MarkerEdgeColor',classificationColour(2));


