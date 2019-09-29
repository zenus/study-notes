<p>The classical way of using a phase vocoder for time stretching is to keep the magnitude unchanged and to modify the phase in such a way that the instantaneous frequencies are preserved.</p>

<strong>Hints and drawbacks</strong> 
<p>As we have noticed, phase vocoding can produce artifacts. It is important
to know them in order to face them.</p>
<ul>
<li>(1) Changing the phases before the IFFT is equivalent to using an all pass filter whose Fourier
transform contains the phase correction that is being applied. If we do not use a window
for the resynthesis, we can ensure the circular convolution aspect of this filtering operation.
We will have discontinuities at the edges of the signal buffer. So it is necessary to use a
  synthesis window.</li>
<li>(2) Nevertheless, even with a resynthesis window (also called tapering window) the circular
aspect still remains: the result is the aliased version of an infinite IFFT. A way to counteract
  this is to choose a zero-padded window for analysis and synthesis.</li>
<li>(3) Shape of the window: one must ensure that a perfect reconstruction is given with a ratio RRas
equal to one (no time stretching). If we use the same window for analysis and synthesis,
the sum of the square of the windows, regularly spaced at the resynthesis hope size, should
  be one.</li>
  <li>(4) For a Hanning window without zero-padding the hop size Rs has to be a divisor of N/4.</li>
<li>(5) Hamming and Blackman windows provide smaller side lobes in the Fourier transform.However, they have the inconvenience of being non-zero at the edges, so that no tapering is done by using these windows alone. The resynthesis hop size should be a divisor</li>
of N/8.
<li>(6) Truncated Gaussian windows, which are good candidates, provide a sum that always has
  oscillations, but which can be below the level of perception.</li>
  
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

<strong>Integer ratio time stretching<strong>
<p>When the time-stretching ratio is an integer (e.g., time stretching by 200%, 300%), the unwrapping
is no longer necessary in the algorithm, because the 2π modulo relation is still preserved when the
phase is multiplied by an integer. The key point here is that we can make a direct multiplication
of the analysis phase to get the phase for synthesis. So in this case it is more obvious and elegant
  to use the following algorithm</p>

