function [best_slope, coefficients, errors] = segmented_fit(x, y, num_segments)
    % 对给定的x和y数据进行分段拟合，并找到平方误差最小的拟合直线

    % 将数据分为num_segments个段并拟合
    coefficients = zeros(num_segments, 2);

    for i = 1:num_segments
        indices = (i - 1) * floor(length(x) / num_segments) + 1:i * floor(length(x) / num_segments);
        coefficients(i, :) = polyfit(x(indices), y(indices), 1);
    end

    % 计算每个拟合直线的平方误差
    errors = zeros(num_segments, 1);

    for i = 1:num_segments
        y_predicted = polyval(coefficients(i, :), x);
        errors(i) = sum((y(indices) - y_predicted(indices)) .^ 2);
    end

    % 找到平方误差最小的拟合直线
    [~, min_index] = min(errors);
    best_slope = coefficients(min_index, 1);

    % 绘制所有拟合直线和最佳拟合直线
    plot(x, y, 'o');
    hold on;

    for i = 1:num_segments
        x_fit = linspace(min(x(indices)), max(x(indices)), 100);
        y_fit = polyval(coefficients(i, :), x_fit);
        plot(x_fit, y_fit);
    end

    x_fit = linspace(min(x), max(x), 100);
    y_fit = polyval(coefficients(min_index, :), x_fit);
    plot(x_fit, y_fit, 'LineWidth', 2);

    % 显示结果
    fprintf('Best slope: %.2f\n', best_slope);
end
