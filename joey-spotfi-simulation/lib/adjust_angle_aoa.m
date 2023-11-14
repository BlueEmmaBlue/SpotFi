function [angle,best_per]=adjust_angle_aoa(ta,b)
c=normalize(ta(1:end));
d=normalize(b(1:end));
best_ang=0;
best_per=100000;
for i=-pi:pi/36:pi
    e=d*exp(1j*i);
    dis=sum(abs(e-c));
% dis=dtw(e,c,60);
    if dis<best_per
        best_per=dis;
        best_ang=i;
    end
end
for i=(best_ang-pi/18):pi/360:(best_ang+pi/18)
    e=d*exp(1j*i);
    dis=sum(abs(e-c));
% dis=dtw(e,c,60);
    if dis<best_per
        best_per=dis;
        best_ang=i;
    end
end
angle=best_ang;
end