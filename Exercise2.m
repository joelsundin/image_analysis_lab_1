% Read the image
I = imread('images/hand2BW.png');

function otsu_threshold = otsu_method(I)
    % Get the histogram of the image
    [counts, bin_locations] = imhist(I);
    
    % Normalize the histogram counts to get probabilities
    pixel_count = sum(counts);
    normalized_hist = counts / pixel_count;
    
    % Compute cumulative sums and means
    cumulative_sum = cumsum(normalized_hist);
    cumulative_mean = cumsum(bin_locations .* normalized_hist);
    global_mean = cumulative_mean(end);
    
    % Initialize variables
    between_class_variance = zeros(length(bin_locations), 1);
    
    % Compute between-class variance for each possible threshold
    for t = 1:length(bin_locations)
        fprintf('Testing threshold value: %d\n', t);
        if cumulative_sum(t) == 0 || cumulative_sum(t) == 1
            % Skip t values where one of the classes would be empty
            continue;
        end
        
        % Probabilities for class 0 (background) and class 1 (foreground)
        prob_class0 = cumulative_sum(t);
        prob_class1 = 1 - prob_class0;
        
        % Means for class 0 and class 1
        mean_class0 = cumulative_mean(t) / prob_class0;
        mean_class1 = (global_mean - cumulative_mean(t)) / prob_class1;
        
        % Between-class variance
        between_class_variance(t) = prob_class0 * prob_class1 * (mean_class0 - mean_class1)^2;
        fprintf('Value for between-class variance: %f\n', between_class_variance(t));
    end

    % Find the threshold that maximizes the between-class variance
    [~, otsu_threshold] = max(between_class_variance);
    
    % Display the thresholded image
    thresholded_image = I > otsu_threshold;
    imshow(thresholded_image);
    title(['Otsu Threshold: ', num2str(otsu_threshold/256)]);
end


otsu_method(I)/256
graythresh(I)