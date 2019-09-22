  窗口傅里叶变换或短时傅里叶变换(Short Time FourierTransform, STFT)（以下统一简称为STFT）能够完成局部分析的关键是“窗口”，
  窗口的尺度是局部性程度的表征。当窗函数取为高斯窗时一般称为Gabor变换。选高斯窗的原因在于：
  -1）高斯函数的Fourier变换仍是高斯函数，这使得Fourier逆变换也用窗函数局部化了，同时体现了频率域的局部化；
  -2）根据Heisenberg测不准原理，高斯函数窗口面积已达到测不准原理下界，是时域窗口面积达到最小的函数，即Gabor变换是最优的STFT。