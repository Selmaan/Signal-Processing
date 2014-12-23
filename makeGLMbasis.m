function glm_basis = makeGLMbasis(sig,fWidth,fShift)
% Function to create basis for glm model from a signal
%
% glm_basis = makeGLMbasis(sig,fWidth,fShift)
%
% fWidth is std of gaussian filter (in samples), 0 for no filtering
% fShift shifts signal (positive = current index contains future signal) 
%   shifts create undefined data at beginning or end that is filled as nan

alpha = 3;
fPts = fWidth*alpha*2+1;
f = gausswin(fPts,alpha);
f = f/sum(f);

fSig = conv(sig,f,'same');
glm_basis = nan(size(sig));
ind = 1:length(sig);
if fShift >= 0
    glm_basis(1:end-fShift) = fSig(1+fShift:end);
elseif fShift < 0
    glm_basis(1-fShift:end) = fSig(1:end+fShift);
end