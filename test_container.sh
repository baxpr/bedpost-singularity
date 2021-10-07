#!/usr/bin/env bash

singularity run --contain --cleanenv \
    --bind INPUTS:/tmp \
    --bind INPUTS:/INPUTS \
    --bind OUTPUTS:/OUTPUTS \
    bedpost-singularity_v3.0.0-beta2.simg \
    --label_info 'TEST LABEL' \
    --dwi_niigz /INPUTS/PREPROCESSED/dwmri.nii.gz \
    --bvec_txt /INPUTS/PREPROCESSED/dwmri.bvec \
    --bval_txt /INPUTS/PREPROCESSED/dwmri.bval \
    --mask_niigz /INPUTS/PREPROCESSED/mask.nii.gz \
    --outdir /OUTPUTS
