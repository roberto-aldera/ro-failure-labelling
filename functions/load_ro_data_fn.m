% loading from file
function [xyz_yaw_raw,MaxEVec_raw,C_matrix_raw] = ...
            load_ro_data_fn(filepath)     
    xyz_yaw_raw = csvread(filepath+'xyz_yaw.csv');
    MaxEVec_raw = csvread(filepath+'MaxEVec.csv');
    C_matrix_raw = csvread(filepath+'compatibility_matrix.csv');
end
    