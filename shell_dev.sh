singularity shell \
--cleanenv \
--bind INPUTS:/INPUTS \
--bind INPUTS_FAILED:/INPUTS_FAILED \
--bind OUTPUTS_FAILED:/OUTPUTS_FAILED \
--bind OUTPUTS:/OUTPUTS \
--bind `pwd`:/wkdir \
test.simg
