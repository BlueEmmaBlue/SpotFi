direroot = 'D:\baseline\plate_outdoor\';
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

    for i = 1:3
        csi_data = [csi_data, pc1{1, i}];
    end

    save(fullfile(direroot, [fname, '.mat']), 'csi_data', 'time_stamp');
end
