%% Choose trace
sig = de(10,:);

%% Filter Signals
baseW = 15;
f_fast = gausswin(baseW)/sum(gausswin(baseW));
f_med = gausswin(baseW*10)/sum(gausswin(baseW*10));
f_slow = gausswin(baseW*100)/sum(gausswin(baseW*100));

%Fast
fX_fast = conv(xV,f_fast,'same');
fY_fast = conv(yV,f_fast,'same');
fX2_fast = sqrt(fX_fast.^2);
fY2_fast = sqrt(fY_fast.^2);
fSig_fast = conv(sig,f_fast,'same');
mvPred_fast = cat(1,fX_fast,fY_fast,fX2_fast,fY2_fast);

%Medium
fX_med = conv(xV,f_med,'same');
fY_med = conv(yV,f_med,'same');
fX2_med = sqrt(fX_med.^2);
fY2_med = sqrt(fY_med.^2);
mvPred_med = cat(1,fX_med,fY_med,fX2_med,fY2_med);

%Slow
fX_slow = conv(xV,f_slow,'same');
fY_slow = conv(yV,f_slow,'same');
fX2_slow = sqrt(fX_slow.^2);
fY2_slow = sqrt(fY_slow.^2);
mvPred_slow = cat(1,fX_slow,fY_slow,fX2_slow,fY2_slow);


%% Create Predictor Matrix
nShifts = 10;
fastShift = 6;
medShift = 30;
slowShift = 150;
maxShift = nShifts*slowShift;

X = []; Y = [];
shiftInd = -nShifts:nShifts;
validInd = [maxShift+1 length(fSig_fast)-maxShift];
for nShift = 1:2*nShifts+1
    indF = validInd + shiftInd(nShift)*fastShift;
    X = cat(1,X,mvPred_fast(:,indF(1):indF(2)));
    indM = validInd + shiftInd(nShift)*medShift;
    X = cat(1,X,mvPred_med(:,indM(1):indM(2)));
    indS = validInd + shiftInd(nShift)*slowShift;
    X = cat(1,X,mvPred_slow(:,indS(1):indS(2)));
end
X = X';

Y = fSig_fast(validInd(1):validInd(2))';

%% Set lasso options

opt = statset('UseParallel',true);
%parpool(),
% [B FitInfo] = lassoglm(X,Y,'gamma','link','log','CV',5,'Options',opt);

[B FitInfo] = lassoglm(X,Y,'poisson','CV',5,'Options',opt);
display('Done!'),

lassoPlot(B,FitInfo,'plottype','CV');
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log');