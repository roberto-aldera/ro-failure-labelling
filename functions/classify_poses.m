function classification = classify_poses(xyz_yaw,num_instances,failure_label)
classification = ones(1,num_instances)*(-failure_label); %initialise to be all good
dxyz_yaw = [zeros(1,4); diff(xyz_yaw)];
for i = 1:num_instances
    if(abs(dxyz_yaw(i,1)) > 1)
        classification(i) = failure_label;
    elseif(abs(dxyz_yaw(i,2)) > 0.5) %was 0.1
        classification(i) = failure_label;
    elseif(abs(dxyz_yaw(i,4)) > 0.1)
        classification(i) = failure_label;
    end
end
end