function k = get_norTime(dataLen,samp_rate)
%GET_NORTIME normalized time process
%   
defineT=6;
dataT=dataLen/samp_rate;
k=defineT/dataT;
% k=1;

end

