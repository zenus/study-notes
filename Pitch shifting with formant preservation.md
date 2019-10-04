<strong>Pitch shifting with formant preservation</strong>
<ul>
<li><div>Inverse formant move plus pitch shifting
  <p>A possible way to remove the artifacts is to perform a formant move in the inverse direction of the
    pitch shifting.</p></div></li>
  <li><div>Resampling plus formant move
    <p>It is also possible to combine an interpolation scheme with a formant move inside an analysissynthesis loop. The block diagram in Figure 8.25 demonstrates this approach. The input segments
are interpolated from length N1 to length N2. This interpolation or resampling also changes the
time duration and thus performs pitch shifting in the time domain. The resampled segment is
then applied to an FFT/IFFT-based analysis/synthesis system, where the correction function for
      the formant move is computed by the cepstrum method</p></div></li>
  <li><div>Resampling of the excitation signal
    <p>Instead of moving the formants, an alternative technique is to calculate an excitation signal by
removing the spectral envelope, to process the excitation signal by a pitch shifting algorithm and
to filter the pitch shifted excitation signal with the original spectral envelope. LPC algorithms
can be used for this approach</p></div></li>
</ul>
