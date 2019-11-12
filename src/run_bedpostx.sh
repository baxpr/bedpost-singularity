
# BEDPOSTX
.../fsl/bin/bedpostx <dtiqa>/bedpostx --nf=3 --fudge=1  --bi=1000


### VISUALIZE RESTORE FILES ###
# V1
fsleyes render -of out -hc -hl -xz 1200 -yz 1200 -zz 1200 --size 600 300 \
	<dtiqa>/RESTORE/fa \
	<dtiqa>/RESTORE/v1 -ot linevector

# TENSORS
fsleyes render -of out -vl 64 65 45 --hidex --hidez -hc -hl -yz 1700 --size 600 300 \
	<dtiqa>/RESTORE/fa \
	<dtiqa>/RESTORE/dt -ot tensor

### VISUALIZE BEDPOSTX FILES ###
# DYADS1
fsleyes render -of out -hc -hl -xz 1200 -yz 1200 -zz 1200 --size 600 300 \
	<dtiqa>/bedpostx.bedpostX/dyads1 -ot rgbvector

# DYADS1 MODULATED BY MEAN F1
fsleyes render -of out -hc -hl -xz 1200 -yz 1200 -zz 1200 --size 600 300 \
	<dtiqa>/bedpostx.bedpostX/dyads1.nii.gz -ot rgbvector -b 70 -c 50 \
	-mo <dtiqa>/bedpostx.bedpostX/mean_f1samples.nii.gz 

# VECTOR MAP
fsleyes render -of out -vl 64 65 45 --hidex --hidez -hc -hl -yz 1500 --size 600 300 \
	<dtiqa>/bedpostx.bedpostX/mean_fsumsamples.nii.gz \
	<dtiqa>/bedpostx.bedpostX/dyads1.nii.gz         -ot linevector -xc 1 0 0 -yc 1 0 0 -zc 1 0 0 -lw 2 \
	<dtiqa>/bedpostx.bedpostX/dyads2_thr0.05.nii.gz -ot linevector -xc 0 1 0 -yc 0 1 0 -zc 0 1 0 -lw 2 \
	<dtiqa>/bedpostx.bedpostX/dyads3_thr0.05.nii.gz -ot linevector -xc 0 0 1 -yc 0 0 1 -zc 0 0 1 -lw 2

# VECTOR MAP
fsleyes render -of out -vl 65 67 45 --hidex --hidey -hc -hl -zz 2000 --size 600 300 \
	<dtiqa>/bedpostx.bedpostX/mean_fsumsamples.nii.gz \
	<dtiqa>/bedpostx.bedpostX/dyads1.nii.gz         -ot linevector -xc 1 0 0 -yc 1 0 0 -zc 1 0 0 -lw 2 \
	<dtiqa>/bedpostx.bedpostX/dyads2_thr0.05.nii.gz -ot linevector -xc 0 1 0 -yc 0 1 0 -zc 0 1 0 -lw 2 \
	<dtiqa>/bedpostx.bedpostX/dyads3_thr0.05.nii.gz -ot linevector -xc 0 0 1 -yc 0 0 1 -zc 0 0 1 -lw 2




