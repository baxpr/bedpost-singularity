#!/bin/bash

export PATH=/wkdir/src:$PATH

wrapper.sh \
--project TESTPROJ \
--subject TESTSUBJ \
--session TESTSESS \
--scan TESTSCAN \
--bedpost_params "-n 3 --model=1 -b 1000 -w 1" \
--dwi_niigz ../INPUTS/eddy.nii.gz \
--bval_txt ../INPUTS/eddy.bvals \
--bvec_txt ../INPUTS/eddy.eddy_rotated_bvecs \
--mask_niigz ../INPUTS/b0_mask.nii.gz \
--fa_niigz ../INPUTS/dtifit_FA.nii.gz \
--v1_niigz ../INPUTS/dtifit_V1.nii.gz \
--tensor_niigz ../INPUTS/dtifit_tensor.nii.gz \
--outdir ../OUTPUTS
