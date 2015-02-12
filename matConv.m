function convSig = matConv(sig,gWinStd,mode)
% Creates a gaussian window filter with the specified standard deviation
% and applies convolution to each row of the sig matrix
%
% convSig = matConv(sig,gWinStd,mode
%
% sig is nxt matrix of n signals at t timepoints
% gWinStd is desired standard deviation of filter
% mode is convolution mode, optional, default is 'same'

if ~exist('mode','var') || isempty(mode)
    mode = 'same';
end

nSigs = size(sig,1);
gWin = gausswin(gWinStd*5 + 1)/sum(gausswin(gWinStd*5 + 1));
t = conv(sig(1,:),gWin,mode);
convSig = nan(nSigs,length(t));
for n = 1:nSigs
    convSig(n,:) = conv(sig(n,:),gWin,mode);
end