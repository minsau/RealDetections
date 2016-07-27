%%
% Comenzamos leyendo los datos de los datos de ligo
clc
clear all
close all
path = 'Data/';
filename = 'H-H1_LOSC_4_V1-1135136334-32.hdf5';
titulo = 'Hanford Interferometer';
makeplot = true;
injection = false;
tamSegment = 32;
ligoFile = readLigo(filename,path,titulo,makeplot, injection,tamSegment);

%%
path = 'Data/';
filename = 'GW151226_4_template.hdf5';
template = gw_getTemplateEvents(path,filename,ligoFile);
if(makeplot)
   plot(template.fft);
   set(gca,'XScale','Log','YScale','Log')
end

%%
%Incializar otras cosas por ejemplo el vector de frecuencias
f        = linspace(0,fs/2,nffthalf)';
datafreq = np.fft.fftfreq(template.size)*fs;
df = np.abs(datafreq(1) - datafreq[0]);


%%
%Calcular data

data = gw_computedataEvents(ligoFile,template);
if(makeplot)
   plot(abs(data.fft));
   set(gca,'XScale','Log','YScale','Log')
end

%%
%Función para encontrar la onda gravitacional

