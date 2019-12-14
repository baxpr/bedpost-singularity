singularity shell \
--cleanenv \
--bind INPUTS:/INPUTS \
--bind INPUTS_FAILED:/INPUTS_FAILED \
--bind OUTPUTS_FAILED:/OUTPUTS_FAILED \
--bind OUTPUTS:/OUTPUTS \
--bind `pwd`:/wkdir \
baxpr-bedpost-singularity-master-v1.0.0.simg
