function [ret, l] = getRefCSI(x1, x2, x3)
   %% genetic algorithm
    l = zeros(1,3);
    x1Temp = x1(1:1:end);
    x2Temp = x2(1:1:end);
    x3Temp = x3(1:1:end);
    IntCon = [];
    rng default % For reproducibility
    refCSI = @(x)abs(x(1)*exp(-1j*x(2))*x1Temp+x(3)*exp(-1j*x(4))*x2Temp+x(5)*exp(-1j*x(6))*x3Temp);
    fun = @(x)refCostFunction(refCSI(x));
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = [0.1, 0.01, 0.1, 0.01, 0.1, 0.01];
    ub = [10, 2*pi, 10, 2*pi, 10, 2*pi];
    nonlcon = [];
    optimoptions('ga','UseParallel',true,'UseVectorized',true);
    x = ga(fun,6,A,b,Aeq,beq,lb,ub,nonlcon,IntCon);
    l(1) = x(1)*exp(-1j*x(2));
    l(2) = x(3)*exp(-1j*x(4));
    l(3) = x(5)*exp(-1j*x(6));
    %l = [7.28122275567821 - 6.39041227757515i,0.249045670012927 + 0.309284155166637i,-1.71719908055265 - 2.45797222824868i];
    ret = l(1)*x1+l(2)*x2+l(3)*x3;
end

function ret = refCostFunction(x)
    option = 2;
    if option == 1
        %% variable coefficient
        ret = std(x)/mean(x);
    elseif option == 2
        %% sBNR
        ret = getSBNR(x, [10 30]);
    end
end

function ret = getSBNR(x, freqRange)
% calculate SBNR
    global samp_rate scaleSize
    
    x = zscore(x);
    
    % transform x from 1xN to Nx1
    if size(x,1) < size(x,2)
        x = x.';
    end  
    
    % zero padding
    x = [x; zeros(round(8192*scaleSize)-length(x),1)];
   
    N = length(x);
    if mod(N,2) == 1
        N = N + 1;
        x = [x; x(end)];
    end
    
    xdft = fft(x);
    xdft = xdft(1:N/2+1);
    
    psdx = (1/(samp_rate*N)) * abs(xdft).^2;
    
    psdx(2:end-1) = 2*psdx(2:end-1);
    
    psdx = psdx ./ sum(psdx); % normalize it, the max value is BNR
    
    freq = (0:samp_rate/N:samp_rate/2).*60; % convert to bpm
    
    % a norm breath rate is 10-37 (bpm)
    temp = find(freq>=freqRange(1) & freq<=freqRange(2));
    lIdx = temp(1);
    rIdx = temp(end);
    
    psdx1 = psdx(lIdx:rIdx);
    %[ret, ~] = max(psdx1);
    ret = sum(psdx1);

end