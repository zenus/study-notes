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
