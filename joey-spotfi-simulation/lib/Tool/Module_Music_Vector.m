function a_vector = Module_Music_Vector(aoaPhase,antennaNum)
for antennaID=1:antennaNum
    a_vector(antennaID,1) = aoaPhase^(antennaID-1);
end
end