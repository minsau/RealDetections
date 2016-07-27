function SNR = gw_matchedfilterEvents(data,template,noise)
optimal = data_fft * template_fft.conjugate() / power_vec;
    optimal_time = 2*np.fft.ifft(optimal)*fs;
    
    sigmasq = 1*(template_fft * template_fft.conjugate() / power_vec).sum() * df;
    sigma = np.sqrt(np.abs(sigmasq));
    SNR_complex = optimal_time/sigma;
   
    peaksample = int(data.size / 2);  % location of peak in the template
    SNR_complex = np.roll(SNR_complex,peaksample);
    SNR = abs(SNR_complex);

    % find the time and SNR value at maximum:
    indmax = np.argmax(SNR);
    timemax = time[indmax];
    SNRmax = SNR[indmax];
    
    plot(time-timemax, SNR);