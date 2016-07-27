function template = gw_getTemplateEvents(path,filename,ligo)
%Leemos datos del template
NFFT = 4*ligo.fs;
template_hd5 = hdf5read([path filename],'template');
template_p= template_hd5(:,1);
template_c= template_hd5(:,2);
t_m1 = hdf5read([path filename],'/meta','m1');
t_m2 = hdf5read([path filename],'/meta','m2');
t_a1 = hdf5read([path filename],'/meta','a1');
t_a2 = hdf5read([path filename],'/meta','a2');
t_approx = hdf5read([path filename],'/meta','approx');
template_offset = 16.;
time = ligo.timegps;
template.nofft = (template_p + template_c*1.j);
dwindow = blackman(length(template.nofft));   
template.fft = fft(template.nofft.*dwindow,NFFT) / ligo.fs;
%ttime = time-time(0)-template_offset;