#!/bin/bash

# Parse options
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --info_string)
        info_string="$2"
        shift; shift
        ;;
    --restore_dir)
        restore_dir="$2"
        shift; shift
        ;;
    --outdir)
        outdir="$2"
        shift; shift
        ;;
    *)
        shift
        ;;
  esac
done


# Get to working directory
cd "${outdir}"


### RESTORE PNGs ###

# V1
fsleyes render -of restore_v1.png \
    -hc -hl -xz 1200 -yz 1200 -zz 1200 --size 600 300 \
    "${restore_dir}"/fa \
    "${restore_dir}"/v1 -ot linevector

# TENSORS
fsleyes render -of restore_tensors.png \
    -vl 64 65 45 --hidex --hidez -hc -hl -yz 1700 --size 600 300 \
    "${restore_dir}"/fa \
    "${restore_dir}"/dt -ot tensor


### BEDPOSTX PNGs ###

# DYADS1
fsleyes render -of bedpost_dyads.png \
    -hc -hl -xz 1200 -yz 1200 -zz 1200 --size 600 300 \
    bedpostx.bedpostX/dyads1 -ot rgbvector

# DYADS1 MODULATED BY MEAN F1
fsleyes render -of bedpost_dyads_mod.png \
    -hc -hl -xz 1200 -yz 1200 -zz 1200 --size 600 300 \
    bedpostx.bedpostX/dyads1.nii.gz
	    -ot rgbvector -b 70 -c 50 \
        -mo bedpostx.bedpostX/mean_f1samples.nii.gz 

# VECTOR MAP
fsleyes render -of bedpost_vecs1 \
    -vl 64 65 45 --hidex --hidez -hc -hl -yz 1500 --size 600 300 \
    bedpostx.bedpostX/mean_fsumsamples.nii.gz \
    bedpostx.bedpostX/dyads1.nii.gz \
        -ot linevector -xc 1 0 0 -yc 1 0 0 -zc 1 0 0 -lw 2 \
    bedpostx.bedpostX/dyads2_thr0.05.nii.gz \
        -ot linevector -xc 0 1 0 -yc 0 1 0 -zc 0 1 0 -lw 2 \
    bedpostx.bedpostX/dyads3_thr0.05.nii.gz \
        -ot linevector -xc 0 0 1 -yc 0 0 1 -zc 0 0 1 -lw 2

# VECTOR MAP
fsleyes render -of bedpost_vecs2 \
    -vl 65 67 45 --hidex --hidey -hc -hl -zz 2000 --size 600 300 \
    bedpostx.bedpostX/mean_fsumsamples.nii.gz \
    bedpostx.bedpostX/dyads1.nii.gz \
        -ot linevector -xc 1 0 0 -yc 1 0 0 -zc 1 0 0 -lw 2 \
    bedpostx.bedpostX/dyads2_thr0.05.nii.gz \
        -ot linevector -xc 0 1 0 -yc 0 1 0 -zc 0 1 0 -lw 2 \
    bedpostx.bedpostX/dyads3_thr0.05.nii.gz \
        -ot linevector -xc 0 0 1 -yc 0 0 1 -zc 0 0 1 -lw 2


### Combine PNGs to PDF ###



