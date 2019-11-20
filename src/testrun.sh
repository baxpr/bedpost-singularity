#!/bin/bash
wrapper.sh \
--project TESTPROJ \
--subject TESTSUBJ \
--session TESTSESS \
--scan TESTSCAN \
--bedpost_params "--nf=3 --fudge=1 --bi=1000" \
--preprocessed_dir ../INPUTS/PREPROCESSED \
--restore_dir ../INPUTS/RESTORE \
--outdir ../OUTPUTS
