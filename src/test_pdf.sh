#!/bin/bash
xvfb-run -n $(($$ + 99)) -s '-screen 0 1600x1200x24 -ac +extension GLX' \
make_pdf.sh \
--info_string "TESTPROJ TESTSUBJ TESTSESS TESTSCAN" \
--restore_dir ../INPUTS_FAILED/RESTORE \
--outdir ../OUTPUTS_FAILED

# apt-get install mesa-utils not enough but it does provide glxgears, which works:
LIBGL_DEBUG=verbose xvfb-run -n $(($$ + 99)) -s '-screen 0 1600x1200x24 -ac +extension GLX' glxgears
LIBGL_DEBUG=verbose xvfb-run -n $(($$ + 99)) -s '-screen 0 1600x1200x24 -ac +extension GLX' glxinfo -B

# We have /usr/lib/x86_64-linux-gnu/dri/swrast_dri.so
# libgl1-mesa-dev doesn't fix
# libicu doesn't fix
# libglu1-mesa-dev doesn't fix
restore_dir=../INPUTS_FAILED/RESTORE
dims="2400 1200"
xvfb-run -n $(($$ + 99)) -s '-screen 0 1600x1200x24 -ac +extension GLX' \
fsleyes render -of restore_v1.png \
    -hc -hl -xz 1200 -yz 1200 -zz 1200 --size ${dims} \
    "${restore_dir}"/fa \
    "${restore_dir}"/v1 -ot linevector

# Conda frozen env issue:
# https://github.com/conda/conda/issues/9367
# https://github.com/conda/conda/issues/9367#issuecomment-560343340
# Try other ver https://repo.anaconda.com/miniconda/

# NO HELP
# From here: https://git.fmrib.ox.ac.uk/samh/profumo/blob/d1f883bf49895542b2f1b6a75650f12b3a4ce67a/Docker/Dockerfile
# freeglut                freeglut3
# gtk2                    gtk+2.0 (libgtk2.0-0 only?)
# mesa-dri-drivers        libgl1-mesa-dri
# xorg-x11-server-Xvfb    xvfb


# Works in dwi-reorder fsl 6.0.2:
xvfb-run -n $(($$ + 99)) -s '-screen 0 1600x1200x24 -ac +extension GLX' \
fsleyes render \
  --scene ortho --hideCursor --layout grid \
  --outfile ortho.png --size 1000 1000 \
  "${restore_dir}"/fa \
  --interpolation linear

# /usr/local/fsl/bin/FSLeyes/fsleyes: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/l, for GNU/Linux 2.6.32, BuildID[sha1]=373ec5dee826653796e927ac3d65c9a8ec7db9da, stripped

