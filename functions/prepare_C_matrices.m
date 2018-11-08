function allCs = prepare_C_matrices(C_matrix_raw,num_instances)
num_processed = 1;
allCs = cell(1,num_instances);
for i = 1:num_instances
    current_C_matrix_size = C_matrix_raw(num_processed,1);
    C_matrix_temp = C_matrix_raw(num_processed:(current_C_matrix_size+num_processed-1), ...
        1:current_C_matrix_size);
    allCs{i} = C_matrix_temp;
    num_processed = num_processed+current_C_matrix_size;
end
end