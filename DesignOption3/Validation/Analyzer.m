warning('off','all')
warning
% fileName = '../../../Design Fitting/DesignOption1/Latest Exp110-Jul-2015 12:20:32.mat';
% 
% load(fileName);
fileName = '../../../Design Fitting/DesignOption3/RCVs.mat';

load(fileName);


par = 10;
Q = 2;

BC1 = C1;
BC2 = C2;
BC3 = C3;
BR1 = R1;
BR2 = R2;
BR3 = R3;
BR0 = R0;
BV1 = V1;
BV2 = V2;
BV3 = V3;
BIr = IrrigationC;

s = zeros(Q^par, 1546);

Count = 1;
for p =[0.02, 0.05]
    if(Q==2)
        DC1 = [(1-p)*BC1, (1+p)*BC1];
        DC2 = [(1-p)*BC2, (1+p)*BC2];
        DC3 = [(1-p)*BC3, (1+p)*BC3];
        DR1 = [(1-p)*BR1, (1+p)*BR1];
        DR2 = [(1-p)*BR2, (1+p)*BR2];
        DR3 = [(1-p)*BR3, (1+p)*BR3];
        DR0 = [(1-p)*BR0, (1+p)*BR0];
        DV1 = [(1-p)*BV1, (1+p)*BV1];
        DV2 = [(1-p)*BV2, (1+p)*BV2];
        DV3 = [(1-p)*BV3, (1+p)*BV3];
        DIR = [(1-p)*BIr; (1+p)*BIr];
    elseif(Q==3)
        DC1 = [(1-p)*BC1, BC1, (1+p)*BC1];
        DC2 = [(1-p)*BC2, BC2, (1+p)*BC2];
        DR1 = [(1-p)*BR1, BR1, (1+p)*BR1];
        DR2 = [(1-p)*BR2, BR2, (1+p)*BR2];
        DV1 = [(1-p)*BV1, BV1, (1+p)*BV1];
        DV2 = [(1-p)*BV2, BV2, (1+p)*BV2];
        DIR = [(1-p)*BIr; BIr; (1+p)*BIr];
    end
    format shortg;
    c = clock;
    startCount = Count;
    for i=1:Q
        for j=1:Q
            for k =1:Q
                for l=1:Q
                    for m =1:Q
                        for n=1:Q
                            for o=1:Q
                                for pt =1:Q
                                    for q=1:Q
                                         for r=1:Q
                                            bpar = par;
                                            if(bpar>0)
                                                C1 = DC1(i);
                                            end
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                C2 = DC2(j);
                                            end
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                R1 = DR1(k);
                                            end
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                R2 = DR2(l);
                                            end
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                V1 = DV1(m);
                                            end
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                V2 = DV2(n);
                                            end
                                            
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                R3 = DR3(o);
                                            end
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                C3 = DC3(pt);
                                            end
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                V3 = DV3(q);
                                            end
                                            bpar=bpar-1;
                                            if(bpar>0)
                                                R0 = DR0(r);
                                            end
%                                             bpar=bpar-1;
%                                             if(bpar>0)
%                                                 IrrigationC = DIR(r,:);
%                                             end
                                            sim('Design3');
                                            format shortg
                                            clc
                                            d = clock;
                                            number = (i-1)*Q^(par-1) + (j-1)*Q^(par-2) +(k-1)*Q^(par-3) +(l-1)*Q^(par-4) + (m-1)*Q^(par-5) + (n-1)*Q^(par-6) +(o-1)*Q^(par-7)+(pt-1)*Q^(par-8)+(q-1)*Q^(par-9)+r;
                                            secs = (d(4)-c(4))*3600 + (d(5)-c(5))*60 + d(6)-c(6);
                                            speed = number/secs;
                                            x = floor((Q^par-number)/speed);
                                            hours = floor(x/3600)
                                            mins = floor((x-hours*3600)/60)
                                            seconds = floor(x-hours*3600-mins*60)
                                            s(Count, :) = ScopeData3(:, 2);
                                            Count=Count+1;  
                                         end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    clc
    load(fileName);
    endCount = Count-1;
    lowerbound = zeros(size(s, 2)-1, 1);
    upperbound = zeros(size(s, 2)-1, 1);
    for i = 2:size(s, 2)
        lowerbound(i-1) = min(s(startCount:endCount, i));
        upperbound(i-1) = max(s(startCount:endCount, i));
    end
    eval(sprintf('LowerBound%d = lowerbound', p*1000));
    eval(sprintf('UpperBound%d = upperbound', p*1000));
    save(['sAt'  num2str(p*100) '.mat'], 'UpperBound*', 'LowerBound*' );
end

fileName = '../../../Design Fitting/DesignOption2/Latest Exp110-Jul-2015 12:20:32.mat';
%%