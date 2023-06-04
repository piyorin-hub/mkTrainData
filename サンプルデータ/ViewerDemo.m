load("HF001.mat")
cmap = parula(256);
fig = figure("Name","Viewer");
os = orthosliceViewer(v, "Colormap",cmap, 'Parent',fig);
vs = volshow(v);
disp('HF001')

load("HF009.mat");
% vs.Data = new;  
os.delete();
os = orthosliceViewer(v, "Colormap", cmap, 'Parent', fig);
disp('HF009')