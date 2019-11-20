singularity shell \
--cleanenv \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
--bind `pwd`:/wkdir \
baxpr-bedpost-singularity-master-v1.0.0.simg
