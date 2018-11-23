function classification = classify_poses(xyz_yaw,num_instances)
classification = zeros(1,num_instances);
dxyz_yaw = [zeros(1,4); diff(xyz_yaw)];
for i = 1:num_instances
    if(abs(dxyz_yaw(i,1)) > 1)
        classification(i) = 1;
    elseif(abs(dxyz_yaw(i,2)) > 0.1)
        classification(i) = 1;
    elseif(abs(dxyz_yaw(i,4)) > 0.1)
        classification(i) = 1;
    end
end
end