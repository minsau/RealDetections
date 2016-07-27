function ligo = readLigo(filename,path,titulo,makeplot, injection,tamSegment)
    ligo.path = path;
    ligo.filename = filename;
    % Sampling frequency and period
    ligo.ts                   = hdf5read([ligo.path ligo.filename],'/strain/Strain','Xspacing');
    ligo.fs                   = 1/ligo.ts;
    ligo.Npoints              = double(hdf5read([ligo.path ligo.filename],'/strain/Strain','Npoints'));
    ligo.Tblock               = ligo.Npoints/ligo.fs;

    % Get the start and end time of the data
    ligo.gpsini               = double(hdf5read([ligo.path ligo.filename],'/strain/Strain','Xstart'));
    ligo.gpsend               = ligo.gpsini + ligo.Tblock-1*ligo.ts;

    % Read the strain values
    ligo.strain               = hdf5read([ligo.path ligo.filename],'/strain/Strain');
    ligo.timegps              = linspace(ligo.gpsini,ligo.gpsend,length(ligo.strain))';
    ligo.timesec              = ligo.timegps - ligo.timegps(1);
    ligo.tamSegment           = tamSegment;
    
    %% COMPUTE SEGMENTS INFORMATION
    if(injection)
        cadena = strsplit(filename,'-');
        if(strcmp(cadena(1),'H'))
            indices = {'gps','interferometro','m1','m2','d','status','r1','r2'}
            log = loadFile('../Injections/H1_cleanlog_cbc_without_spaces.txt',indices,' ');
        else
            indices = {'gps','interferometro','m1','m2','d','status','r1','r2'}
            log = loadFile('../Injections/L1_cleanlog_cbc_without_spaces.txt',indices,' ');
        end
        for i=1:length(log.gps)
            if(log.gps(i) >= ligo.gpsini) && (log.gps(i) <= ligo.gpsend)
                ligo.m1           = log.m1(i);
                ligo.m2           = log.m2(i);
                ligo.d            = log.d(i);
                ligo.gpsinjection = log.gps(i);
            end
        end
        
        % Duration of the data segment and overlap (seconds)
        ligo.segments.Twin        = tamSegment;           % even and power of two
        ligo.segments.Tove        = ligo.segments.Twin/2;
        ligo.NFFT                 = ligo.segments.Twin * ligo.fs;
        % Number of segments
        ligo.segments.Nseg        = 2*(ligo.Tblock/ligo.segments.Twin)-1;
        
        % % Debugging: Compute Tblock
        % Tblock   = ((ligo.segments.Nseg-1)*(ligo.segments.Tove*ligo.fs)+ligo.segments.Twin*ligo.fs)*ligo.ts
        
        % Time ini and Time end of each segment (seconds)
        Tini                      = (1:ligo.segments.Tove:ligo.Tblock-ligo.segments.Tove)';
        Tend                      = Tini+ligo.segments.Twin-1;
        
        % Sample ini and Sample end of each segment (sample)
        Sini                      = (Tini-1)*ligo.fs+1;
        Send                      = (Tend-0)*ligo.fs+0;
        
        % Time and samples of each interval
        ligo.segments.Tint        = [Tini Tend];
        ligo.segments.Sint        = [Sini Send];
        
        % Get segment where the GW was injected
        tcoal                     = ligo.gpsinjection - ligo.gpsini;
        d                         = ligo.segments.Tint - tcoal;
        md                        = abs(d(:,1)+d(:,2));
        [~, ligo.segments.seginj] = min(md);
    end