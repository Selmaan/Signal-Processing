%% Choose trace
neur = 6;
sig = de(neur,:);

%% Create Predictor Matrix
Y_scale = 3;
shifts = [0 1 2 3 5 8 13 21 34 55 89 144 233];
shifts = [-fliplr(shifts(2:end)),shifts];
nShifts = length(shifts);
X = [];
Y = sig*Y_scale;
validInd = max(abs(shifts))+1:length(sig)-max(abs(shifts));


for nShift = 1:nShifts
    sWidth = abs(shifts(nShift))/2;
    sShift = shifts(nShift);
    xBasis = makeGLMbasis(xV,sWidth,sShift);
    yBasis = makeGLMbasis(yV,sWidth,sShift);
    spdBasis = makeGLMbasis(sqrt(xV.^2+yV.^2),sWidth,sShift);
    %x2Basis = makeGLMbasis(xV.^2,sWidth,sShift);
    %y2Basis = makeGLMbasis(yV.^2,sWidth,sShift);
    
    %X = cat(1,X,xBasis,yBasis,x2Basis,y2Basis);
    X = cat(1,X,xBasis,yBasis,spdBasis);
end
X = X';


X = X(validInd,:);
Y = Y(validInd);

%% Set lasso options

opt = statset('UseParallel',true);
%[B1 FitInfo1] = lassoglm(X,Y,'poisson','Alpha',1,'CV',5,'Options',opt);
%[B05 FitInfo05] = lassoglm(X,Y,'poisson','Alpha',0.5,'CV',5,'Options',opt);
%[B01 FitInfo01] = lassoglm(X,Y,'poisson','Alpha',0.1,'CV',5,'Options',opt);
[B FitInfo] = lassoglm(X,Y,'poisson','Alpha',1e-4,'Lambda',logspace(0,-4,100),'CV',6,'Options',opt);
home,
display('Done!'),
neur,
lassoPlot(B,FitInfo,'plottype','CV');
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log');

%% 
lassoPlot(B,FitInfo,'plottype','CV');
p = reshape(B(:,FitInfo.Index1SE),3,[]);
x=-750:750;
b = zeros(1,1.5e3+1);
b(751) = 1;

bases = [];
for shift = 1:length(shifts)
    sWidth = abs(shifts(shift))/2;
    sShift = shifts(shift);
    bases(shift,:) = makeGLMbasis(b,sWidth,sShift);
end

%rawFig = figure;hold on
normFig = figure;hold on
for nV=1:3
    basis = zeros(size(b));
    for shift = 1:length(shifts)
        basis = basis + bases(shift,:) * p(nV,shift);
    end
    %figure(rawFig),
    %plot(x,basis)
    figure(normFig),
    plot(x,basis*std(X(:,36+nV)))
end