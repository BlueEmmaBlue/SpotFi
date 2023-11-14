function plot_detail_csi(csi, id, sp, ep,folder_path)

    lenid = length(id);

    if lenid <= 5
        col = lenid;
        raw = 1;
    else
        col = 4;
        raw = ceil(lenid / 4);
    end

    figure;

    for i = 1:lenid
        subplot(raw, col, i)
%         plotLineColor(fliplr(csi(id(i), sp:ep))); axis equal; xlabel('I'); ylabel('Q'); title(['Sub ', num2str(id(i))]);
        tmp_csi = csi(sp:ep,id(i),1);
        plotLineColor(fliplr(tmp_csi)); axis equal; xlabel('I'); ylabel('Q'); title(['Sub ', num2str(id(i))]);
        [center_x, center_y, radius] = circleLeastFit(tmp_csi);
        hold on; plot(center_x, center_y, 'o');
        cc = center_x + 1j * center_y + radius * cos(0:0.01:2 * pi) + 1j * radius * sin(0:0.01:2 * pi);
        hold on; plot(cc);
    end

    figure;
    % csi = csi.';
    % csi = movmean(csi, winn);
    % csi = csi.';
%         for j = 1:size(csi,2)
%             for k = 1:size(csi,3)
%                 csi(:,j,k) = movmean(csi(:,j,k),winn);
%             end
%         end

    for i = 1:lenid
        subplot(raw, col, i)
%         plotLineColor(fliplr(csi(id(i), sp:ep))); axis equal; xlabel('I'); ylabel('Q'); title(['Sub ', num2str(id(i))]);
        tmp_csi = csi(sp:ep,id(i),1);
        plotLineColor(fliplr(tmp_csi)); axis equal; xlabel('I'); ylabel('Q'); title(['Sub ', num2str(id(i))]);
        [center_x, center_y, radius] = circleLeastFit(tmp_csi);
        hold on; plot(center_x, center_y, 'o');
        cc = center_x + 1j * center_y + radius * cos(0:0.01:2 * pi) + 1j * radius * sin(0:0.01:2 * pi);
        hold on; plot(cc);
    end

end
