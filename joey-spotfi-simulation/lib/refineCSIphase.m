function [ret] = refineCSIphase(csi)
    %REFINECSI fix warp phase disorder
    %   by Fischer (c)2018 Peking University
    %   warplab recorded csi data often have discontinuities in phase,
    %   The phase disorder should be fixed before use

    % assume phase change between two consecutive csi is less than a
    % threshold, any phase change larger than this value is considered
    % malformed
    phase_diff_threshold = 0.8; % in radius

    ret = csi;

    %% step 0: check input validaty
    if ndims(csi) == 3 || size(csi, 2) > 64
        return;
    end

    %% step 1: segmentation based on if the phase is consecutive
    amp = abs(csi);
    phase = unwrap(angle(csi));
    dphase = diff(phase);
    malform = abs(dphase) > phase_diff_threshold;
    malform_idx = sum(malform, 2) > 30; % at least 30 subcarriers agree with malform

    if sum(malform_idx) == 0 % no need for fixing
        return;
    end

    %% step 2: calculate phase compensation at discontinuity point
    rela = zeros(size(dphase));
    comp = dphase(malform_idx, :);
    rela(malform_idx, :) = comp;
    compensate = mean(abs(comp));
    x1 = find(compensate(1:32) ~= 0);
    x2 = find(compensate(33:64) ~= 0) + 32;
    % refine compensation factor
    p1 = polyfit(x1, compensate(x1), 1);
    p2 = polyfit(x2, compensate(x2), 1);
    ncomp = compensate;
    ncomp(x1) = polyval(p1, x1);
    ncomp(x2) = polyval(p2, x2);

    %% step 3: decide compensate direction
    signlow = sign(sum(sign(comp(:, 1:32)), 2));
    signhigh = sign(sum(sign(comp(:, 33:64)), 2));
    fixsign = cat(2, repmat(signlow, 1, 32), repmat(signhigh, 1, 32));
    rela(malform_idx, :) = fixsign;

    %% step 4: fix phase by translating the unconsecutive phases
    fixphase = phase;
    fix = zeros(1, 64);

    for i = 1:length(csi) - 1
        fix = fix - rela(i, :);
        fixphase(i + 1, :) = fixphase(i + 1, :) + fix .* ncomp;
    end

    %% step 5: restore csi
    ret = amp .* exp(1i * fixphase);
    return;

    %% for debugging purpose
    %{
    figure;
    subplot(3,1,1);
    plot(phase(:,15), '.');
    subplot(3,1,2);
    plot(fixphase(:,15), '.');
    subplot(3,1,3);
    plot(compensate);
    hold on;
    plot(ncomp);
    %}

end
