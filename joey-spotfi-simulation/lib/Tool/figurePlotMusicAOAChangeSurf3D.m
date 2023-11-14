function figurePlotMusicAOAChangeSurf3D( filename, p_mu,aoaList,tofList,class,back)
% index=findstr(filename,'.dat'); %#ok<*FSTR>
% item_name_pre=filename(1:index-1);
% index2=strfind(item_name_pre,'/');
% item_name_only=item_name_pre(index2(length(index2))+1:length(item_name_pre));
%plot-------------------------------
surf(tofList,aoaList,p_mu,'EdgeColor','none');
shading interp;
axis xy; axis tight;
view(0,90);
xlabel ('Time [s]');
ylabel ('aoa [angle]');
set(gca, 'xminortick', 'on');
set(gca, 'yminortick', 'on');
set(gca,'tickdir','out');
colorbar();
% Module_SaveFigureWithFig(filename,class,back);
end