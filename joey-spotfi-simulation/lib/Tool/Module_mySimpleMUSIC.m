function [p_mu,eigValueSort]=Module_mySimpleMUSIC(csi_music,aoaList,center_freq,signalNum,d)
lamda=299792458/center_freq;
antennaNum = size(csi_music,1);
noiseNum = antennaNum -signalNum;
packetNum=size(csi_music,2);
covMatrix=csi_music*csi_music';
covMatrix=covMatrix/packetNum;
% nobalance setting need try
[eV,eD] = eig(covMatrix);
eigValue=diag(eD);
[eigValueSort,eigValueIndex] = sort(eigValue);
   
noiseMatrix = eV(:,eigValueIndex(1:noiseNum));
noiseMatrix_H = noiseMatrix';
Index=0;
    for aoa=aoaList
        Index=Index+1;
        aoaPhase=exp(1i*2*pi*d*aoa/lamda);
        a_vector = Module_Music_Vector(aoaPhase,antennaNum);
        a_vector_H = a_vector';
        temp1=1/abs(a_vector_H*noiseMatrix*noiseMatrix_H*a_vector);
        p_mu(Index)=temp1;
    end
end