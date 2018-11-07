function iqm_test()
% Test computing all supported image quality metrics one by one.
    disp('Starting testing...');
    %% Utility test
    fprintf('Testing tools...');
    global iqm_svm_scale;
    global iqm_svm_predict;
    [status, output] = system(sprintf('%s', iqm_svm_scale));
    if status ~= 1
        error('status:%i\n%s', status, output);
    end
    [status, output] = system(sprintf('%s', iqm_svm_predict));
    if status ~= 1
        error('status:%i\n%s', status, output);
    end
    fprintf('\t Success!\n')
    %% Metric test
    disp('Testing metrics...');
    n_errors = 0;
    %% Read test images
    img = imread('blurred.png');
    img_ref = imread('deblurred.png');
    disp('Image loaded.');
    assert(~isa(img, 'double') && size(img, 3) == 3 && mean(mean2(img)) > 1);
    fprintf('Image dimension: %i x %i\n', size(img, 2), size(img, 1));
    disp('Iterating through all metrics...');
    %% Iteration
    global iqm_function_handles;
    counter = 0;
    for name_cell = keys(iqm_function_handles)
        counter = counter + 1;
        name = name_cell{1};
        try
            assert(~isa(img, 'double') && size(img, 3) == 3 && mean(mean2(img)) > 1, 'Image invalidated!');
            fprintf('%2i.%-8s ', counter, name);
            result = iqm(name, img, img_ref);
            assert(~isempty(result), 'No value returned.');
            fprintf('Result: %8.2f  Success!\n', result);
        catch ME
            warning('on');
            warning('%s\n\t%s FAILED\n', getReport(ME), name);
            n_errors = n_errors + 1;
        end
    end
    %% Conclude
    disp('NOTE: Even succeeded ones may have computed a wrong value. Further checking needed!');
    if n_errors == 0
        fprintf('\tALL PASSED!\n');
    else
        error('Number of error: %i\n', n_errors);
    end
end
