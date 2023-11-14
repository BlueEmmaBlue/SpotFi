function  plotLineColor(csi)
%PLOTLINECOLOR Plot complex CSI data in color
%   Detailed explanation goes here
if size(csi,1)>size(csi,2)
    csi = csi(:,1);
else
    csi=csi(1,:);
end
    x = real(csi);
    y = imag(csi);
    y(end) = nan;
    c = 1:length(csi);
    patch(x,y,c,'EdgeColor','flat','Marker','o','MarkerFaceColor','flat','LineWidth',0.1);
% plot(x,y,c,'EdgeColor','flat','Marker','o','MarkerFaceColor','flat','LineWidth',0.1);
    colormap( gca, 'jet' );
%     axis equal;
%     hold on;
%     plot(complex(0, 0), 'ro');
end


