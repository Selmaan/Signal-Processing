function [F_est F P_est V_est] = getDeconv(Forig,doPlot)

if ~exist('doPlot','var') | isempty(doPlot)
    doPlot = 0;
end

%% F
F=Forig-min(Forig)+eps;

%% V
V.Ncells = 1;
V.T = length(F);
V.Npixels = 1;
V.dt = 1/30;
%V.dt = 1/30*10;
V.fast_thr = 0;
V.fast_poiss = 0;
V.fast_nonlin = 0;
V.fast_plot = doPlot;
V.fast_iter_max = 1;
V.fast_ignore_post = 0;
V.est_sig = 0;
V.est_lam = 0;
V.est_gam = 0;
V.est_a = 0;
V.est_b = 0;

%% P

P.a = 0.1;
P.b = median(F);
fTemp = F(F<P.b);
P.sig = mad([fTemp,2*max(fTemp)-fTemp],0);
tau = 1.5;
P.gam = 1 - (V.dt/tau); %3-V.dt
P.lam = 1;

%% deconvolve
[F_est P_est V_est]=deconvFO(F,V,P);
if doPlot
    clf,plot(conv(F,gausswin(15)/sum(gausswin(15)),'same')),hold on,plot(F_est),
end
