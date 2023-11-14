function [timeList,p_mu_ans,peakPowerList,effectivePacketNumList]=Module_AoAMUSICTimeSyn(CSIData,timestampList,packetLossFlagList,filename)
global freqList;
global aoaMusicTip;
global aoaList;
global aoaSnapShotNum;
global aoaSignalNum;
global aoaSub;
global antennaSpace;
packetNum=size(CSIData,4);
timeIDList=[];
for timeID=1:aoaMusicTip:packetNum
    timeEnd = timeID+aoaSnapShotNum-1;
    if timeEnd>packetNum
        break;
    end
    timeIDList=[timeIDList,timeID];
end
ansNum=length(timeIDList);
aoaNum=length(aoaList);
p_mu_ans=zeros(aoaNum,ansNum);
peakPowerList=zeros(1,ansNum);
effectivePacketNumList = zeros(1,ansNum);
disp(['*************************AoA MUSIC of ' ,filename,' is Beginning!*******************']);
processTimeB = now*3600*24;
for timeIndex=1:ansNum
    %% deal with the loss packet
    timeStartID=timeIDList(timeIndex);
    timeEnd=timeStartID+aoaSnapShotNum-1;
    csi_now = [];
    timestamp_now = [];
    effectiveLen = 0;
    for tmpID = timeStartID :timeEnd
        if packetLossFlagList(tmpID) <1
          effectiveLen = effectiveLen +1;
          csi_now(:,:,effectiveLen) = squeeze(CSIData(1,:,:,tmpID));
          timestamp_now(effectiveLen) = timestampList(tmpID);
        end
    end
    if(effectiveLen<5) 
        continue;
    end
    effectivePacketNumList(timeIndex) = effectiveLen;
    
%     csi_music=sum(csi_now,2);
%     csi_music=squeeze(csi_music);

%     a=csi_now(1,:,:);
%     csi_now=[csi_now(1,:,:);csi_now(3,:,:);csi_now(2,:,:)];
    csi_music = squeeze(csi_now(:,aoaSub,:));
%     [csi_music] =Module_calibratewithRefSignal(csi_music );

% new code: i don't know whether it is needed.
% csi_music=[csi_music(2,:)/csi_music(1,:);csi_music(3,:)/csi_music(1,:)];

    [p_mu,eigValueSort]=Module_mySimpleMUSIC(csi_music,aoaList,freqList(aoaSub),aoaSignalNum,antennaSpace);
    log_p_mu = log(p_mu);
    p_mu_ans(:,timeIndex)=log_p_mu;
    [peak,~]=max(log_p_mu);
    peakPowerList(timeIndex)=peak;
end
processTimeE = now*3600*24;
disp(['*************************AoA MUSIC of  is Endding with Time is ',num2str(processTimeE-processTimeB),'s!*******************']);
timeList=timestampList(timeIDList);
end