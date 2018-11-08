function classification = classify_poses(total_xyz_yaw,num_instances)
classification = zeros(1,num_instances);
LastSuccessfulPoints = [total_xyz_yaw(2,1),total_xyz_yaw(2,2); ...
    total_xyz_yaw(1,1),total_xyz_yaw(1,2)];

for i = 3:num_instances
    CurrentPoints = [total_xyz_yaw(i-1,1),total_xyz_yaw(i-1,2); ...
        total_xyz_yaw(i,1),total_xyz_yaw(i,2)];
    PreviousPoints = [total_xyz_yaw(i-2,1),total_xyz_yaw(i-2,2); ...
        total_xyz_yaw(i-1,1),total_xyz_yaw(i-1,2)];
    if(pdist(CurrentPoints,'Euclidean')>(3*pdist(LastSuccessfulPoints,'Euclidean')))
        classification(i) = 1;
    else
        LastSuccessfulPoints = PreviousPoints;
    end
end
end