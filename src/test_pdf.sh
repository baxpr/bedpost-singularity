#!/bin/bash
xvfb-run -n $(($$ + 99)) -s '-screen 0 1600x1200x24 -ac +extension GLX' \
make_pdf.sh \
--info_string "TESTPROJ TESTSUBJ TESTSESS TESTSCAN" \
--restore_dir ../INPUTS/RESTORE \
--outdir ../OUTPUTS

