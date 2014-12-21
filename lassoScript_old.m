%% Choose trace
sig = de(6,:);

%% Filter Signals
f = gausswin(10)/sum(gausswin(10));
fX = conv(xV,f,'same');
fY = conv(yV,f,'same');
fX2 = sqrt(fX.^2);
fY2 = sqrt(fY.^2);
fSpd = sqrt(fX.^2 + fY.^2);
fSig = conv(sig,f,'same');
mvPred = cat(1,fX,fY,fX2,fY2);


%% Create Predictor Matrix

X = []; Y = [];
nShifts = 6;
shiftInd = -nShifts:nShifts;
sizeShift = 10;
maxShift = nShifts*sizeShift;
validInd = [maxShift+1 length(fX)-maxShift];
for nShift = 1:2*nShifts+1
    ind = validInd + shiftInd(nShift)*sizeShift;
    X = cat(1,X,mvPred(:,ind(1):ind(2)));
end
X = X';

Y = fSig(validInd(1):validInd(2))';

%% Set lasso options

opt = statset('UseParallel',true);
%parpool(),
[B FitInfo] = lassoglm(X,Y,'poisson','CV',5,'Options',opt);

%[B FitInfo] = lassoglm(X,Y,'gamma','link','log','CV',5);
display('Done!'),
lassoPlot(B,FitInfo,'plottype','CV');
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log');
