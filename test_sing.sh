#!/bin/bash

singularity run \
--cleanenv \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
baxpr-bedpost-singularity-master-v1.0.0.simg \
--project TESTPROJ \
--subject TESTSUBJ \
--session TESTSESS \
--scan TESTSCAN \
--preprocessed_dir /INPUTS/PREPROCESSED \
--restore_dir /INPUTS/RESTORE \
--bedpost_params "--nf=3 --fudge=1 --bi=1000" \
--outdir /OUTPUTS
