function [F_est F P_est V_est] = getDeconv(Forig,doPlot)
%% F
F=Forig-min(Forig)+eps;

%% V
V.Ncells = 1;
V.T = length(F);
V.Npixels = 1;
V.dt = 1/30;
V.fast_thr = 0;
V.fast_poiss = 0;
V.fast_nonlin = 0;
V.fast_plot = doPlot;
V.fast_iter_max = 5;
V.fast_ignore_post = 0;
V.est_sig = 1;
V.est_lam = 0;
V.est_gam = 0;
V.est_a = 1;
V.est_b = 1;

%% P

P.a = 0.2;
P.b = prctile(F,25);
P.sig = mad(Forig(Forig<1),1) * 1.4826;
P.gam = 1-V.dt;
P.lam = V.dt;

%% deconvolve
[F_est P_est V_est]=deconvFO(F,V,P);
clf,plot(conv(F,gausswin(15)/sum(gausswin(15)),'same')),hold on,plot(F_est),
