<strong> Adaptive digital audio effects </strong>
<ul>
<li>Sound-feature extraction
   <ul>Loudness-related sound features
     <li>Amplitude envelop</li>
     <li>Sound energy</li>
     <li>Loudness</li>
      <li>
    Time features: beat detection and tracking
   </li>
      <li>
    Pitch extraction
    <p>The main task of pitch extraction is to estimate a fundamental frequency f0, which in musical terms
is the pitch of a sound segment, and follow the fundamental frequency over the time. We can use
this pitch information to control effects like time stretching and pitch shifting based on the PSOLA
method, which is described in Chapter 6, but it also plays a major role in sound modeling with
spectral models, which is treated extensively in Chapter 10. Moreover, the fundamental frequency
can be used as a control parameter for a variety of audio effects based either on time-domain or
on frequency-domain processing </p>
   </li>
        <li>
   Center of gravity of a spectrum (spectral centroid)
    <p>A good indication of the instantaneous richness of a sound can be measured by the center of
gravity of its spectrum, as depicted in Figure 9.27. A sound with a fixed pitch, but with stronger
harmonics has a higher center of gravity. It should be noted here that this center of gravity is
linked to the pitch of the sound, and that this should be taken into account during the use of this
feature. Thus, a good indicator of the instantaneous richness of a sound can be the ratio of the
center of gravity divided by the pitch</p>
   </li>
   </ul>
    
</li>

</ul>
