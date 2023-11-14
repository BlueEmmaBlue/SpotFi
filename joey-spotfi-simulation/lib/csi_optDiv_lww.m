function [ret, u] = csi_optDiv_lww(rx)

    rx1 = fixNAN(rx{1, 1});
    rx2 = fixNAN(rx{1, 2});
    rx3 = fixNAN(rx{1, 3});
    

    [weights, ~] = m_opt_min_lww(100,6,rx1,rx2,rx3);
    w = [weights(1)+1j*weights(2); weights(3)+1j*weights(4); weights(5)+1j*weights(6)];

    u = w(1).*rx1 + w(2).*rx2 + w(3).*rx3;

    
    ret(:, :, 1) = rx1 ./ u;
    ret(:, :, 2) = rx2 ./ u;
    ret(:, :, 3) = rx3 ./ u;

end

function [x,fval]=m_opt_min_lww(w,nvars,csi1,csi2,csi3)
   
    LB = -w*ones(nvars,1);  %定义域下限
    UB = -LB;               %定义域上限

    options = optimoptions('ga','ConstraintTolerance', 1e-6, 'MaxGenerations', 1000);

    [x,fval] = ga(@(weight) ref_fitness_min_lww(weight,csi1,csi2,csi3),nvars,[],[],[],[],LB,UB,[],options);
    disp("fval is :" + num2str(fval));

end

function y = ref_fitness_min_lww(w,csi1,csi2,csi3)

      mixsig = (w(1)+1j*w(2)).*csi1 + (w(3)+1j*w(4)).*csi2 + (w(5)+1j*w(6)).*csi3;
      arx = abs(mixsig);
      arx = hampel(arx);
      arx = movmean(arx, 20, 1);

      y = mean(var(arx) ./ (mean(arx).^2), 2);

end
