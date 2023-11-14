function [csi_list,timestampList_New,packetLossFlagList,rssi_aNew,rssi_bNew,rssi_cNew,agc_list_new]=Module_predoSimpleDopplerPacketLoss( filename)
global sampleRate;
sampleRate=400;
%Read File---------------------------
csi_src_cell1 = read_bf_file( filename );
%END Read File-----------------------

%scaled csi-----------------------------
% csi_src_cell1 = Module_Scaled(csi_src_cell1);
%END scaled------------------------------

packetNum = length(csi_src_cell1);
new_csi=[csi_src_cell1{:}];
csi_list=zeros(1,3,30,packetNum);
timestampList=zeros(1,packetNum);
rssi_a = zeros(1,packetNum);
rssi_b = zeros(1,packetNum);
rssi_c = zeros(1,packetNum);
agc_list = zeros(1,packetNum);
realNum = 0;
for i=1:packetNum
    if(isempty(csi_src_cell1{i,1}))
        continue;
    end
      realNum = realNum +1;
    csi_list(:,:,:,realNum)=csi_src_cell1{i,1}.csi;
     agc_list(1,realNum) = csi_src_cell1{i,1}.agc;
     rssi_a(realNum) = csi_src_cell1{i,1}.rssi_a;
    rssi_b(realNum) = csi_src_cell1{i,1}.rssi_b;
    rssi_c(realNum) =  csi_src_cell1{i,1}.rssi_c;
    timestampList(1,realNum)=(csi_src_cell1{i,1}.timestamp_low-csi_src_cell1{1,1}.timestamp_low)/(1e6);
end
if realNum ~= packetNum
    disp(['There is an empty CSI !!!']);
end
csi_list = csi_list(:,:,:,1:realNum) ;
agc_list = agc_list(1:realNum);
 rssi_a    = rssi_a(1:realNum) ;
 rssi_b   = rssi_b(1:realNum);
 rssi_c = rssi_c(1:realNum) ;
  timestampList=  timestampList(1:realNum);
[ timestampList] = Module_checkTimestampBackroll( timestampList);
%% deal with uneven arrival
packetLossFlagList = [];
csi_list_new = [];
timestampListNew = [];
rssi_aNew= [];
rssi_bNew = [];
rssi_cNew = [];
timeLen = length(timestampList);
csi_list_new(:,:,:,1)= csi_list(:,:,:,1);
timestampListNew = [ timestampListNew,timestampList(1)];
rssi_aNew(1) = rssi_a(1);
rssi_bNew(1) = rssi_b(1);
rssi_cNew(1) = rssi_c(1);
agc_list_new(1) = agc_list(1);
packetLossFlagList =  [packetLossFlagList,0];
packetLossSum = 0;
packetNum = 1;
for timeID = 2:timeLen
    lossNum = round((timestampList(timeID)-timestampList(timeID-1))*sampleRate);
    for lossID = 1:lossNum-1
        packetNum = packetNum +1;
        csi_list_new(:,:,:,packetNum) = csi_list(:,:,:,timeID-1);
         agc_list_new(packetNum) = agc_list(timeID-1);
         rssi_aNew(packetNum) = rssi_a(timeID-1);
        rssi_bNew(packetNum) = rssi_b(timeID-1);
        rssi_cNew(packetNum) = rssi_c(timeID-1);
        timestampListNew(packetNum) = timestampList(timeID-1)+ lossID/sampleRate;
        packetLossFlagList(packetNum) =1;
    end
    packetNum = packetNum +1;
    csi_list_new(:,:,:,packetNum) = csi_list(:,:,:,timeID);
    agc_list_new(packetNum) = agc_list(timeID);
    timestampListNew(packetNum) = timestampList(timeID);
    packetLossFlagList(packetNum) = 0;
    packetLossSum = packetLossSum + lossNum -1;
end
    disp([filename,' loss packet: ',num2str(packetLossSum)]);
    timestampList_New=zeros(packetNum,1);
%     for i=1:packetNum
    timestampList_New=[new_csi.timestamp_low];
%     end
end