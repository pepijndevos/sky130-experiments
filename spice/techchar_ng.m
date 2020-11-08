% techchar.m addaptation to ngspice
% Based on B. Murmanns file.

clear all;
close all;
 
% Parameters for HSpice runs
VGS_step = 25e-3;
VDS_step = 25e-3;
VS_step = 0.2;
VGS_max = 5;
VDS_max = 5;
VS_max = 3;
VGS = 0:VGS_step:VGS_max;
VDS = 0:VDS_step:VDS_max;
VS =  0:VS_step:VS_max;
L = [(0.6:0.15:1.15) (1.15:0.1:2.1)];
W = 5;

% Initialize output structures
nch.ID     = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.VT     = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.GM     = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.GMB    = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.GDS    = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.CGG    = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.CGS    = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.CGD    = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.CGB    = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.CDD    = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.CSS    = zeros(length(L), length(VGS), length(VDS), length(VS));
nch.VGS    = VGS';
nch.VDS    = VDS';
nch.VS     = VS';
nch.L      = L';
nch.W      = W;
pch.ID     = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.VT     = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.GM     = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.GMB    = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.GDS    = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.CGG    = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.CGS    = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.CGD    = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.CGB    = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.CDD    = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.CSS    = zeros(length(L), length(VGS), length(VDS), length(VS));
pch.VGS    = VGS';
pch.VDS    = VDS';
pch.VS     = VS';
pch.L      = L';
pch.W      = W;

% HSpice Simulation loop
for i = 1:length(L)
    for j = 1:length(VS)
          % write out circuit parameters for hspice simulation
          fid=fopen('techchar_params.sp', 'w');
          fprintf(fid,'*** simulation parameters **** %s\n', datestr(now));
          fprintf(fid,'.temp 25\n');
          fprintf(fid,'.param width  = %d\n', W*1e-6);
          fprintf(fid,'.param length = %d\n', L(i)*1e-6);
          fprintf(fid,'.param subvol = %d\n', VS(j));
          fprintf(fid,'.param gsstep = %d\n', VGS_step);
          fprintf(fid,'.param dsstep = %d\n', VDS_step);
          fprintf(fid,'.param gsmax  = %d\n', VGS_max);
          fprintf(fid,'.param dsmax  = %d\n', VDS_max);
          fclose(fid);
        
          % Run Hspice 
          h = ngspice('./techchar.ngsp');
          
%           % Read results
           nch.ID(i,:,:,j)  = vec2mat(h.imn_id_,length(VGS));
           nch.VT(i,:,:,j)  = vec2mat(h.vmn_vth_,length(VGS));
           nch.GM(i,:,:,j)  = vec2mat(h.mn_gm_,length(VGS));
           nch.GMB(i,:,:,j) = vec2mat(h.mn_gmbs_,length(VGS));
           nch.GDS(i,:,:,j) = vec2mat(h.mn_gds_,length(VGS));
           nch.CGG(i,:,:,j) = vec2mat(h.mn_cgg_,length(VGS));
           nch.CGS(i,:,:,j) = vec2mat(h.mn_cgs_,length(VGS)); 
           nch.CGD(i,:,:,j) = vec2mat(h.mn_cgd_,length(VGS));
           nch.CGB(i,:,:,j) = vec2mat(h.mn_cbg_,length(VGS)); 
           nch.CDD(i,:,:,j) = vec2mat(h.mn_cdd_,length(VGS));  
           nch.CSS(i,:,:,j) = vec2mat(h.mn_cgs_,length(VGS)) - vec2mat(h.mn_cbs_,length(VGS));   
           
           
           h = ngspice('./techchar_p.ngsp');
           pch.ID(i,:,:,j)  = vec2mat(h.imp_id_,length(VGS));
           pch.VT(i,:,:,j)  = vec2mat(h.vmp_vth_,length(VGS));
           pch.GM(i,:,:,j)  = vec2mat(h.mp_gm_,length(VGS));
           pch.GMB(i,:,:,j) = vec2mat(h.mp_gmbs_,length(VGS));
           pch.GDS(i,:,:,j) = vec2mat(h.mp_gds_,length(VGS));
           pch.CGG(i,:,:,j) = vec2mat(h.mp_cgg_,length(VGS));
           pch.CGS(i,:,:,j) = vec2mat(h.mp_cgs_,length(VGS)); 
           pch.CGD(i,:,:,j) = vec2mat(h.mp_cgd_,length(VGS));
           pch.CGB(i,:,:,j) = vec2mat(h.mp_cbg_,length(VGS)); 
           pch.CDD(i,:,:,j) = vec2mat(h.mp_cdd_,length(VGS));  
           pch.CSS(i,:,:,j) = vec2mat(h.mp_cgs_,length(VGS)) - vec2mat(h.mp_cbs_,length(VGS));   
    end
end

save('500nch', 'nch');
save('500pch', 'pch');
