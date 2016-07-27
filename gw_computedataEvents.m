function data = gw_computedataEvents(ligo,template);
    NFFT = 4*ligo.fs;
    psd_window = blackman(NFFT);
    [data.psd, data.freqs]     = pwelch(ligo.strain,psd_window,NFFT/2,NFFT,ligo.fs);
    dwindow = blackman(length(template.nofft));
    data.fft = fft(ligo.strain .* dwindow,NFFT) / ligo.fs;