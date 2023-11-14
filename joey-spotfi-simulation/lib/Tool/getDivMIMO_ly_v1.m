function [ret, denominator] = getDivMIMO_ly_v1(rx)
    %GETDIVMIMO get best channel ratio
    %   Detailed explanation goes here

    r1 = rx{1, 1};
    r2 = rx{1, 2};
    r3 = rx{1, 3};

    nanidx = isnan(r1(:, 1));
    x = 1:length(r1);

    denominator = 0;
    % ret = [r1./r2, r2./r1, r1./r3, r3./r1, r2./r3, r3./r2];

    r1avg = mean(mean(abs(r1)));
    r2avg = mean(mean(abs(r2)));
    r3avg = mean(mean(abs(r3)));
    level = [r1avg r2avg r3avg];

    [~, maxIndex] = max(level);
    [~, minIndex] = min(level);

    % for idx=1:3
    %     if  idx~=minIndex && idx~=maxIndex
    %         break;
    %     end
    % end
    disp(['level = ', num2str(level)]);
    % disp(['r', num2str(idx), '/r', num2str(maxIndex)]);
    % ret = [r1 ./ r2, r1 ./ r3, r2 ./ r3, r2 ./ r1, r3 ./ r1, r3 ./ r2];
    ret = cat(3,r1 ./ r2, r1 ./ r3, r2 ./ r3, r2 ./ r1, r3 ./ r1, r3 ./ r2);
    % ret = rx{1,idx}./rx{1,maxIndex};
    % ret = [r3.*r1./(r2.*r2)];
    % for i=1:10
    %    ret(:,i)=(ret(:,i)./ret(:,i+10))./(ret(:,i+10)./ret(:,i+20));
    % end
    % ret=ret(:,1:10);
    %

    denominator = maxIndex;
    % fill nan position in the stream
    if sum(nanidx) >= 1
        ret = interp1(x(~nanidx), ret(~nanidx, :), x);
    end

    % append nan endings with the last non-nan data
    idx = length(x);
    nanflag = sum(~isnan(ret), 2);

    while ~nanflag(idx, 1)
        idx = idx - 1;
    end

    ret(idx, :) = ret(idx - 1, :);

    while idx ~= length(x)
        ret(idx + 1, :) = ret(idx, :);
        idx = idx + 1;
    end

    % if r1avg > r3avg
    %     ret = r3 ./ r1;
    % else
    %     ret = r1 ./ r3;
    % end

end
