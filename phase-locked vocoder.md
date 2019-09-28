<strong>Phase-locked vocoder</strong>
<p>One of the most successful approaches to reduce the phase dispersion was proposed in [LD99a]. If
we consider the processed sound to be mostly composed of quasi-sinusoidal components, then we
can approximate its spectrum as the sum of the complex convolution of each of those components
by the analysis window transform (this will be further explained in the spectral processing chapter).
When we transform the sound, for instance time stretching it, the phase of those quasi-sinusoidal
components has to propagate accordingly. What is really interesting here is that for each sinusoid
the effect of the phase propagation on the spectrum is nothing more than a constant phase rotation
of all the spectral bins affected by it. This method is referred to as phase-locked vocoder, since
the phase of each spectral bin is locked to the phase of one spectral peak.</p>
