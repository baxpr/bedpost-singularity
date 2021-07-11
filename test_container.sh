#!/usr/bin/env bash

singularity run --contain --cleanenv \
    --bind INPUTS:/tmp \
    --bind INPUTS:/INPUTS \
    --bind OUTPUTS:/OUTPUTS \
    bedpost-singularity_v2.0.0-beta3.simg \
    --label_info 'TEST LABEL' \
    --dwi_niigz /INPUTS/PREPROCESSED/dwmri.nii.gz \
    --bvec_txt /INPUTS/PREPROCESSED/dwmri.bvec \
    --bval_txt /INPUTS/PREPROCESSED/dwmri.bval \
    --mask_niigz /INPUTS/PREPROCESSED/mask.nii.gz \
    --fa_niigz /INPUTS/SCALARS/dwmri_tensor_fa.nii.gz \
    --v1_niigz /INPUTS/SCALARS/dwmri_tensor_v1.nii.gz \
    --tensor_niigz /INPUTS/TENSOR__dwmri_tensor.nii.gz \
    --outdir /OUTPUTS
