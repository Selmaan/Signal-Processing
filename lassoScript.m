%% Choose trace
sig = de(3,:);

%% Filter Signals
f = gausswin(15)/sum(gausswin(15));
fX = conv(xV,f,'same');
fY = conv(yV,f,'same');
fX2 = sqrt(fX.^2);
fY2 = sqrt(fY.^2);
fSpd = sqrt(fX.^2 + fY.^2);
fSig = conv(sig,f,'same');
mvPred = cat(1,fX,fY,fX2,fY2,fSpd,fSig);


%% Create Predictor Matrix

X = []; Y = [];
nShifts = 10;
shiftInd = -nShifts:nShifts;
sizeShift = 10;
maxShift = nShifts*sizeShift;
validInd = [maxShift+1 length(fX)-maxShift];
for nShift = 1:2*nShifts+1
    ind = validInd + shiftInd(nShift)*sizeShift;
    X = cat(1,X,mvPred(:,ind(1):ind(2)));
end
X = X';

Y = sig(validInd(1):validInd(2))';

%% Set lasso options

% opt = statset('UseParallel',true);
% parpool(),
% [B FitInfo] = lassoglm(X,Y,'gamma','link','log','CV',5,'Options',opt);

[B FitInfo] = lassoglm(X,Y,'gamma','link','log','CV',5);
display('Done!'),
