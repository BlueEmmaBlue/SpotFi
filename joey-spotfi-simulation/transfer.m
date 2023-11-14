clear all;
% direroot = 'D:\baseline\plate_outdoor\';
direroot = 'D:\baseline\test\';
saveroot = 'D:\baseline\plate_outdoor_new';
ss = [direroot, 'los1m*'];
% ss=[direroot,'silence*'];
dlist = dir(ss);
len = length(dlist);

for f = 1:len
    fn = dlist(f).name;
    fname = fn;
    fileDir = [direroot, fname];
    disp('-------------->');
    disp(fileDir);
    [time1, pc1, a1, rssi, agc, ntx, nrx] = m_getcsi([fname]);
    csi_data = [];
    time_stamp = time1';
    % 转换数据
    complexArraySize = size(pc1{1});
    % 假设要截取的列数为N
    numRows = complexArraySize(1);

    % 初始化新的cell数组
    csi_trace = cell(numRows, 1);

    % 循环处理每个原始数据
   for i = 1:numRows
        % 初始化一个1x3x30的复数数组
        combinedStructArray = struct();

        combinedArray = complex(zeros(1, 3, 30), zeros(1, 3, 30));

        % 循环处理每个cell
        for j = 1:3
            % 从每个cell中提取第i行
            extractedRow = pc1{j}(i, :);

            % 将提取的行放入combinedArray中的第j个元素
            combinedArray(1, j, :) = extractedRow;
        end
        combinedStructArray.csi = combinedArray;
        combinedStructArray.rssi_a = rssi(1,1);
        combinedStructArray.rssi_b = rssi(2,1);
        combinedStructArray.rssi_c = rssi(3,1);
        combinedStructArray.agc = agc(1,1);
        csi_trace{i} = combinedStructArray;
   end

    % for i = 1:3
    %     csi_data = [csi_data, pc1{1, i}];
    % end

    save(fullfile(saveroot, [fname, '.mat']), 'csi_trace');
end







