#!/bin/bash

echo Making PDF:
echo bedpost_dir = "${bedpost_dir}"

# Get to working directory
cd "${outdir}"

# PNG dimensions
dims="2400 1200"


### DTI PNGs ###

# V1
echo V1
fsleyes render -of restore_v1.png \
    -hc -hl -xz 1200 -yz 1200 -zz 1200 --size ${dims} \
    dtifit/dti_FA \
    dtifit/dti_V1 -ot linevector

# TENSORS
echo TENSORS
fsleyes render -of restore_tensors.png \
    --hidex --hidez -hc -hl -yz 1700 --size ${dims} \
    dtifit/dti_FA \
    dtifit/dti_tensor -ot tensor


### BEDPOSTX PNGs ###

# DYADS1
echo DYADS1
fsleyes render -of bedpost_dyads.png \
    -hc -hl -xz 1200 -yz 1200 -zz 1200 --size ${dims} \
    "${bedpost_dir}"/dyads1 \
    -ot rgbvector

# DYADS1 MODULATED BY MEAN F1
echo DYADS1 MOD
fsleyes render -of bedpost_dyads_mod.png \
    -hc -hl -xz 1200 -yz 1200 -zz 1200 --size ${dims} \
    "${bedpost_dir}"/dyads1 \
	    -ot rgbvector -b 70 -c 50 \
        -mo "${bedpost_dir}"/mean_f1samples 

# VECTOR MAP
echo VECTOR MAP 1
fsleyes render -of bedpost_vecs1.png \
    --hidex --hidez -hc -hl -yz 1500 --size ${dims} \
    "${bedpost_dir}"/mean_fsumsamples \
    "${bedpost_dir}"/dyads1 \
        -ot linevector -xc 1 0 0 -yc 1 0 0 -zc 1 0 0 -lw 2 \
    "${bedpost_dir}"/dyads2_thr0.05.nii.gz \
        -ot linevector -xc 0 1 0 -yc 0 1 0 -zc 0 1 0 -lw 2 \
    "${bedpost_dir}"/dyads3_thr0.05.nii.gz \
        -ot linevector -xc 0 0 1 -yc 0 0 1 -zc 0 0 1 -lw 2

# VECTOR MAP
echo VECTOR MAP 2
fsleyes render -of bedpost_vecs2.png \
    --hidex --hidey -hc -hl -zz 2000 --size ${dims} \
    "${bedpost_dir}"/mean_fsumsamples \
    "${bedpost_dir}"/dyads1 \
        -ot linevector -xc 1 0 0 -yc 1 0 0 -zc 1 0 0 -lw 2 \
    "${bedpost_dir}"/dyads2_thr0.05.nii.gz \
        -ot linevector -xc 0 1 0 -yc 0 1 0 -zc 0 1 0 -lw 2 \
    "${bedpost_dir}"/dyads3_thr0.05.nii.gz \
        -ot linevector -xc 0 0 1 -yc 0 0 1 -zc 0 0 1 -lw 2


### Combine PNGs to PDF ###

# Page 1, bedpost vector map
convert \
-size 2600x3365 xc:white \
-gravity center \( bedpost_vecs1.png -resize 2400x1200 \) -geometry +0-650 -composite \
-gravity center \( bedpost_vecs2.png -resize 2400x1200 \) -geometry +0+650 -composite \
-gravity center -pointsize 48 -annotate +0-1300 "Dyad vectors (bedpostx)" \
-gravity SouthEast -pointsize 48 -annotate +50+50 "$(date)" \
-gravity NorthWest -pointsize 48 -annotate +50+50 "${label_info}" \
page1.png

# Page 2, bedpost dyads
convert \
-size 2600x3365 xc:white \
-gravity center \( bedpost_dyads.png -resize 2400x1200 \) -geometry +0-650 -composite \
-gravity center \( bedpost_dyads_mod.png -resize 2400x1200 \) -geometry +0+650 -composite \
-gravity center -pointsize 48 -annotate +0-1300 "First dyad (bedpostx)" \
-gravity SouthEast -pointsize 48 -annotate +50+50 "$(date)" \
-gravity NorthWest -pointsize 48 -annotate +50+50 "${label_info}" \
page2.png

# Page 3, DTI
convert \
-size 2600x3365 xc:white \
-gravity center \( restore_v1.png -resize 2400x1200 \) -geometry +0-650 -composite \
-gravity center \( restore_tensors.png -resize 2400x1200 \) -geometry +0+650 -composite \
-gravity center -pointsize 48 -annotate +0-1300 "Tensor reconstruction (dtifit)" \
-gravity SouthEast -pointsize 48 -annotate +50+50 "$(date)" \
-gravity NorthWest -pointsize 48 -annotate +50+50 "${label_info}" \
page3.png

convert page1.png page2.png page3.png bedpost.pdf


# Clean up
rm *.png
