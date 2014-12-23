%% Choose trace
neur = 6;
sig = de(neur,:);

%% Create Predictor Matrix
shifts = [0 1 2 4 8 16 32 64 128];
shifts = [-fliplr(shifts(2:end)),shifts];
nShifts = length(shifts);
X = []; Y = [];
Y = sig;
validInd = max(abs(shifts))+1:length(sig)-max(abs(shifts));


for nShift = 1:nShifts
    sWidth = abs(shifts(nShift));
    sShift = shifts(nShift);
    xBasis = makeGLMbasis(xV,sWidth,sShift);
    yBasis = makeGLMbasis(yV,sWidth,sShift);
    x2Basis = makeGLMbasis(xV.^2,sWidth,sShift);
    y2Basis = makeGLMbasis(yV.^2,sWidth,sShift);
    
    X = cat(1,X,xBasis,yBasis,x2Basis,y2Basis);
end
X = X';


X = X(validInd,:);
Y = Y(validInd);

%% Set lasso options

opt = statset('UseParallel',true);
[B FitInfo] = lassoglm(X,Y,'poisson','CV',5,'Options',opt);
display('Done!'),
lassoPlot(B,FitInfo,'plottype','CV');
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log');