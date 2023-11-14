function ret = fixNAN(ret)
    for i=1:size(ret, 2)
        csi_first = 0;
        csi_final = 0;
        for j = 1:size(ret, 1)
            if (~isnan(ret(j, i)) && ~isinf(ret(j, i)))
                csi_first = ret(j, i);
                break;
            end
        end
        for j = 1:size(ret, 1)
            if (~isnan(ret(size(ret, 1)+1-j, i)) && ~isinf(ret(size(ret, 1)+1-j, i)))
                csi_final = ret(size(ret, 1)+1-j, i);
                break;
            end
        end
        inte_ret = [csi_first; ret(:, i); csi_final];
        x = 1:length(inte_ret);
        nanidx = isnan(inte_ret) | isinf(inte_ret);
        inte_ret = interp1(x(~nanidx), inte_ret(~nanidx), x);
        ret(:, i) = inte_ret(2:end-1);
    end
end