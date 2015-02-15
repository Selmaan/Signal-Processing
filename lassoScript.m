% %% Choose trace
% neur = 5;
% sig = de(neur,:);

%% Create Predictor Matrix
Y_scale = 1;
shifts = [0 1 2 3 5 8 13 21 34 55 89 144 233];
%shifts = [0:1:10 12 15 19 24 30 40 55 75 100 130 170];
shifts = [-fliplr(shifts(2:end)),shifts];
widths = abs(shifts)/2;
%widths = ones(1,length(shifts)) * 1;
nShifts = length(shifts);
X = [];
Y = sig*Y_scale;
validInd = max(abs(shifts))+1:length(sig)-max(abs(shifts));


for nShift = 1:nShifts
    sWidth = widths(nShift);
    sShift = shifts(nShift);
    xBasis = makeGLMbasis(xV,sWidth,sShift);
    yBasis = makeGLMbasis(yV,sWidth,sShift);
    spdBasis = makeGLMbasis(sqrt(xV.^2+yV.^2),sWidth,sShift);

    X = cat(1,X,xBasis,yBasis,spdBasis);
end
X = X';


X = X(validInd,:);
Y = Y(validInd);

%% Set lasso options
opt = [];
opt.alpha = 1e-1;
nFolds = 8;
foldID = [];
%foldID = floor((1:length(Y))/(length(Y)+1) * nFolds) + 1;

CVerr = cvglmnet(X,Y,'poisson',glmnetSet(opt),'deviance',nFolds,foldID,true);
cvglmnetPlot(CVerr),
figure,glmnetPlot(CVerr.glmnet_fit,'lambda'),
%% 
fitCoef = cvglmnetCoef(CVerr);
%fitCoef = cvglmnetCoef(CVerr,'lambda_min');
p = reshape(fitCoef(2:end),3,[]);
x=-750:750;
b = zeros(1,1.5e3+1);
b(751) = x1;

bases = [];
for shift = 1:length(shifts)
    sWidth = widths(shift);
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
    plot(x,basis*std(X(:,size(X,2)/2-1.5+nV)))
end