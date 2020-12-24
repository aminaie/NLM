
clc
clear
close

imRGB = imread('retina.png');

noisyRGB = imnoise(imRGB,'gaussian',0,0.015); % adding noise

noisyLAB = rgb2lab(noisyRGB); % Convert the noisy RGB image to the L*a*b color space
%, so that the non-local means filter smooths perceptually similar colors.

%roi = [210,24,52,41]; % region of interest to be filtered
patch = noisyLAB;%imcrop(noisyLAB,roi);

% calculate Euclidean distance from the origin
patchSq = patch.^2;
edist = sqrt(sum(patchSq,3));
patchSigma = sqrt(var(edist(:)));


%Set the 'DegreeOfSmoothing'
DoS = 1.5*patchSigma;
denoisedLAB = imnlmfilt(noisyLAB,'DegreeOfSmoothing',DoS);

%Convert the filtered L*a*b image to the RGB color space
denoisedRGB = lab2rgb(denoisedLAB,'Out','uint8');

%Compare a patch from the noisy RGB image (left) and the same patch from the non-local means filtered RGB image (right).
roi2 = [178,68,110,110];
%montage({imcrop(noisyRGB,roi2),imcrop(denoisedRGB,roi2)})
montage({noisyRGB,denoisedRGB})