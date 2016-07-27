function file = loadFile(filename,vars,delimiter)
clc
datset = dataset('File',filename,'Delimiter',delimiter,'ReadVarNames',false);
 for i=1:length(vars)
     j = int2str(i);
     file.(vars{i})= eval(['datset.Var' j]);
 end
