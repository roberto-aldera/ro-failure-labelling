hasBeenRun = false;
if(hasBeenRun == false)
    clear;clf;
    dateAndTime = "2018-11-23-13-48-07/"; % or 2018-11-21-17-44-28
    filename = '/Users/roberto/data/RO-logging/'+dateAndTime;
    [xyz_yaw_raw,MaxEVec_raw,C_matrix_raw] = load_ro_data_fn(filename);
end
start_index = 1;
end_index = length(xyz_yaw_raw) - 0;
xyz_yaw = xyz_yaw_raw(start_index:end_index,:);
MaxEVec = MaxEVec_raw(start_index:end_index,:);

[a,b] = size(MaxEVec);
num_instances = a;

[m,n] = size(xyz_yaw);
total_xyz_yaw = zeros(m,n);

angle_offset = -deg2rad(atand(xyz_yaw_raw(1,1)/xyz_yaw_raw(1,2)));
vel = sqrt(xyz_yaw_raw(:,1).^2+xyz_yaw_raw(:,2).^2);

for i = 2:num_instances
    total_xyz_yaw(i,4) = total_xyz_yaw(i-1,4) + xyz_yaw(i,4);
end

RR = [cos(angle_offset), -sin(angle_offset); sin(angle_offset), cos(angle_offset)];
yaw = zeros(m);
xyz_yaw_world = zeros(m,n);

for i = 1:num_instances
    yaw(i) = total_xyz_yaw(i,4) - angle_offset;
    xyz_yaw_world(i,1) = vel(i)*cos(yaw(i));
    xyz_yaw_world(i,2) = vel(i)*sin(yaw(i));
    
    if(i>2)
        total_xyz_yaw(i,1) = total_xyz_yaw(i-1,1) + xyz_yaw_world(i,1);
        total_xyz_yaw(i,2) = total_xyz_yaw(i-1,2) + xyz_yaw_world(i,2);
    end
        xyz_yaw(i, 1:2) = (RR * xyz_yaw(i, 1:2)')';
end

% local_xyz_yaw = zeros(m,n);
% for i = 1:num_instances
%     local_xyz_yaw(i,1) = vel(i)*cos(xyz_yaw(i,4));
%     local_xyz_yaw(i,2) = vel(i)*sin(xyz_yaw(i,4));
%     local_xyz_yaw(i,4) = xyz_yaw(i,4);
% end

classification = classify_poses(xyz_yaw,num_instances);

for i = 1:num_instances
    MaxEVec(i,:) = sort(MaxEVec(i,:),'descend');
end

allCs = prepare_C_matrices(C_matrix_raw,num_instances);

f1 = figure(1);
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

% diffMaxEVec = [zeros(1, b); diff(MaxEVec)];
previous_was_failure = false;
for i = 2:num_instances
    if(classification(i) == 1)
        colour = 'r';
    elseif(i < (num_instances-2) && classification(i+2) == 1)
        colour = 'c';
        classification(i) = 1;
        previous_was_failure = true;
    elseif(i < (num_instances-1) && previous_was_failure == true && classification(i) == 0)
        colour = 'c';
        classification(i) = 1;
        previous_was_failure = false;
    else
        colour = 'b';
    end
    sf(1) = subplot(2,2,1);
    title('Poses for RO performance');
    hold on;
    plot(total_xyz_yaw(i,1),total_xyz_yaw(i,2), 'o','LineWidth',3,'MarkerEdgeColor',colour);
    axis equal
    
    sf(2) = subplot(2,2,2);
    title('Eigenvectors');
    xlabel('Element index');
    ylabel('Eigenvector element magnitude');
    hold on;
    plot(MaxEVec(i,:),'.','MarkerSize',1,'Color',colour);
    
    sf(4) = subplot(2,2,4);
    %     plot(diff((MaxEVec(i,:))),'.','MarkerSize',1,'Color',colour);
    %     plot(MaxEVec(i-1,:) - (MaxEVec(i,:)),'.','MarkerSize',1,'Color',colour);
    temp_eigvals = eig(allCs{i});
    plot(temp_eigvals(temp_eigvals>0), 'Color', colour);
    hold on;
    title('Eigenvalues');
    xlabel('Element index');
    ylabel('Eigenvalue magnitude');
    
    %     hold on;
    %     title('test(MaxEVec)');
    %     xlabel('Element index');
    %     ylabel('Magnitude');
    %     pause(0.5);
end

h = zeros(2, 1);
h(1) = plot(NaN,NaN,'or');
h(2) = plot(NaN,NaN,'ob');
legend(h, 'Failure','Success');

csvwrite(filename+'sorted_eigenvectors.csv',MaxEVec);
csvwrite(filename+'labels.csv',classification);